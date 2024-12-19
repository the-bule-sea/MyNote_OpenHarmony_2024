import router from '@ohos.router';
import CustomEditDialog from '../component/CustomEditDialog';
import CustomAddDialog from '../component/CustomAddDialog'
import CustomSearch from '../component/CustomSearch';
import CustomTitle from '../component/CustomTitle'
import NoteList from '../component/NoteList';
import Note from '../model/Note';
import NoteTable from '../database/NoteTable';
import LoginDialog from '../component/LoginDialog';
import { Server } from '../server/Server';
import { pushToRemote, pushToRemoteCompletely, syncFromRemoteCompletely } from '../utils/DatabaseDiffAnalysis';
import promptAction from '@ohos.promptAction';
import { conveyToLocalId, conveyToRemoteId, storeLocalIdAndRdbID } from '../server/Model';


@Entry
@Component
@Preview

struct Index {
  // 初始化数据库
  private  NoteTable = new NoteTable(()=>{

  })

  // 缓存的原始数组
  originNoteList :Note[] = []

  // note 列表
  @State noteList: Note[] = []

  // 新增笔记弹窗
  @State isAddDialogShow : boolean = false

  // 新建内容
  @State addTitle:string = ''
  @State addContent:string = ''

  // 新增笔记
  createNote = ()=>{
    const date: Date = new Date()
    const newNote : Note = new Note(0, date.getTime(), this.addTitle, this.addContent) // 当时加入编辑后，发现新增出问题了，原来是这里忘记从editContent改为addContent了
    this.server.createNotes(newNote.title, newNote.content).then(r => {
        console.log('createNotes', JSON.stringify(r))
        this.NoteTable.insertData(newNote, (id: number) => {
          storeLocalIdAndRdbID(conveyToLocalId(r.data), id)
          newNote.id = id
          this.originNoteList.push(newNote)
          this.noteList = this.originNoteList.sort((a, b) => b.updateTime - a.updateTime)
      })
    }).catch(e => {
      console.log('createNote', e)
      this.NoteTable.insertData(newNote, (id: number) => {
        newNote.id = id
        this.originNoteList.push(newNote)
        this.noteList = this.originNoteList.sort((a, b) => b.updateTime - a.updateTime)
      })
    })
    this.closeDialog()
  }

  // 编辑笔记弹窗
  @State isEditDialogShow : boolean = false

  //ifilk: 登录弹窗
  @State isLoginDialogShow: boolean = false
  @State username: string = ''
  @State password: string = ''
  server: Server

  // 编辑暂存
  @State editContent:string = ''
  @State editTitle:string = ''

  // 当前note索引
  editNoteIndex : number = -1

  // 点击笔记卡片时的方法
  clickNote = (note:Note)=>{
    for (let i = 0; i < this.originNoteList.length; i++){
      if(this.originNoteList[i].id === note.id){ // 判断是否相等，然后进行后续操作
        this.editNoteIndex  = i
        this.isEditDialogShow = true
        this.editContent = note.content
        this.editTitle = note.title
      }
    }
  }

  // 删除笔记
  deleteNote = () =>{
    if (this.editNoteIndex !== -1) {
      const note = this.originNoteList[this.editNoteIndex]
      console.log('', note.id)
      this.NoteTable.deleteData(note, () => {
        this.originNoteList.splice(this.editNoteIndex, 1)
        this.noteList = this.originNoteList.sort((a, b) => b.updateTime - a.updateTime)
        conveyToRemoteId(note.id).then(r => {
          this.server.deleteNoteById(r).then(m => {
            promptAction.showToast({
              message: '删除成功',
            })
          }).catch(e => {
            console.log(e)
          })
        }).catch(e => {
          console.log(e)
        })
      })
      this.closeDialog()
    }
  }

  // 修改笔记
  saveNote = ()=>{
    const date: Date = new Date()
    this.originNoteList[this.editNoteIndex].content = this.editContent
    this.originNoteList[this.editNoteIndex].updateTime = date.getTime()
    this.originNoteList[this.editNoteIndex].title = this.editTitle
    this.NoteTable.updateData(this.originNoteList[this.editNoteIndex], () => {
      this.noteList = this.originNoteList.sort((a, b) => b.updateTime - a.updateTime)
      pushToRemote(this.server, this.originNoteList[this.editNoteIndex]).catch(e => {
        promptAction.showToast({
          message: '无法推送到云端, ' + e,
        })
      })
      this.closeDialog()
    })

  }

  // 关闭方法
  closeDialog = ()=>{
    this.isAddDialogShow = false
    this.addTitle = ''
    this.addContent = ''
    this.isEditDialogShow = false
    this.editTitle = ''
    this.editContent = ''
    this.editNoteIndex = -1

    this.isLoginDialogShow = false
  }

  // ifilk: 登录提交
  onSubmit = () => {
    // 确保server对象单例
    if (this.server === undefined)
      this.server = new Server()

    this.server.login(this.username, this.password).then(r => {
      // 设置token
      // console.log("设置token", r.headers['www-authorization'])
      this.server.set_authorization_token(r.headers['www-authorization'])
      this.isLoginDialogShow = false

      promptAction.showToast({
        message: '登录成功',
      })

      // 远程拉取更新
      syncFromRemoteCompletely(this.server, this.NoteTable).then(result => {
        promptAction.showToast({
          message: '同步成功: ' + result.length,
        })
        this.originNoteList = result
        this.noteList = this.originNoteList.sort((a, b) => b.updateTime - a.updateTime)
      }).catch(e => {
        //TODO 报错信息处理
        console.log("syncFromRemoteCompletely失败", e)
      })

      // // 本地推送更新
      // pushToRemoteCompletely(this.server, this.NoteTable).catch(e => {
      //   //TODO 报错信息处理
      //   console.log(e)
      // })

    }).catch(e => {
      // TODO 弹窗提醒
      // 打开LogDialog
      this.isLoginDialogShow = true
      promptAction.showToast({
        message: '登录出现错误' + e.toString(),
      })
      console.log(e)
    })
  }


  // 页面初始化时加载的数据
  aboutToAppear(){
    this.originNoteList = []
    this.noteList = []
    this.keywords = ''
    this.isAddDialogShow = false
    this.isEditDialogShow = false
    this.addTitle = ''
    this.addContent = ''
    this.editNoteIndex = -1
    this.editTitle = ''
    this.editContent = ''
    this.NoteTable.getRdbStore(() => {
      this.NoteTable.query((result: Note[]) => {
        this.originNoteList = result
        this.noteList = this.originNoteList.sort((a, b) => b.updateTime - a.updateTime)
      })
    })

    // ifilk
    this.isLoginDialogShow = true
    // 确保server对象单例
    if (this.server === undefined) {
      this.server = new Server()
    }
    // else {
    //   // 存在sever对象拉取更新
    //
    //   // 远程拉取更新
    //   syncFromRemoteCompletely(this.server, this.NoteTable).catch(e => {
    //     //TODO 报错信息处理
    //     console.log(e)
    //   })
    //
    //   // 本地推送更新
    //   pushToRemoteCompletely(this.server, this.NoteTable).catch(e => {
    //     //TODO 报错信息处理
    //     console.log(e)
    //   })
    // }
  }

  // 搜索
  @State @Watch('onSearchKeywordsChange') keywords : string = ''

  // 搜索过滤
  onSearchKeywordsChange(){
    if (this.keywords.length === 0){
      this.noteList = this.originNoteList.sort((a, b) => b.updateTime - a.updateTime)
    } else{
      let resultList : Note[] = []
      for (const note of this.originNoteList){
        // 标题或者具体内容过滤
        if (note.content.includes(this.keywords) || note.title.includes(this.keywords)){
          resultList.push(note)
        }
      }
      this.noteList = resultList
    }
  }

  build() {
    Stack({alignContent: Alignment.BottomEnd}) { // 堆叠布局，按钮放右下角

      // 主体
      Column() {
        // 顶部标题
        CustomTitle()
        // 搜索栏
        CustomSearch({keywords:$keywords})
          .padding(16)
          .width('100%')
        // 笔记瀑布组件
        Scroll(){
          Column(){
            Flex({alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap}){
              ForEach(
                this.noteList,
                (note:Note, index:number) =>{
                  NoteList({note:this.noteList[index], onNoteClick:this.clickNote})
                },
                (note:Note)=>{return note.content}
              )
            }
            .padding(8)
            .width('100%')
          }
        }
        .scrollBarWidth(5)
        .edgeEffect(EdgeEffect.Spring)
        .scrollBarColor('#9dcbfc')
      }
      .width('100%')
      .height('100%')

      // 悬浮按钮
      Button('+')
        .backgroundColor('#32628d')
        .size({width: 80, height: 80})
        .fontSize(50)
        .fontColor('#f1f1f3')
        .margin(50)
        .shadow({
          radius: 20,
          color: '#CCCCCC',
          offsetY: 15,
          offsetX: 15
        })
        .onClick(() => {
          // this.isEditDialogShow = true
          this.isAddDialogShow = true
        })

      // 新建弹窗
      if (this.isAddDialogShow){
        CustomAddDialog({addContent:$addContent, addTitle:$addTitle, onCreate:this.createNote, onClose:this.closeDialog})
      }

      // 编辑弹窗
      if (this.isEditDialogShow){
        CustomEditDialog({editContent:$editContent, editTitle:$editTitle, onClose:this.closeDialog, onDelete:this.deleteNote, onSave:this.saveNote})
      }

      // ifilk: 登录弹窗
      if (this.isLoginDialogShow){
        LoginDialog({username:$username, password:$password, onSubmit:this.onSubmit})
      }
    }
    .backgroundColor('#f1f1f3')
    .width('100%')
    .height('100%')
  }
}