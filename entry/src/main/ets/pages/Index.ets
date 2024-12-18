import CustomEditDialog from '../component/CustomEditDialog';
import CustomTitle from '../component/CustomTitle'
import CustomAddDialog from '../component/CustomAddDialog'
import CustomSearch from  '../component/CustomSearch'
import NoteList from '../component/NoteList'
import Note from '../model/Note'

// 整体代码思路参考开源:https://gitee.com/J-Design/easy-memo
// CustomSearch , CustomAddDialog 与 CustomEditDialog 参考开源同上
// 关系型数据库参考同上

// 页面设计、组件设计原创


@Entry
@Component
@Preview

struct Index {

  // 是否展示新建笔记自定义弹窗
  @State isAddDialogShow: boolean = false

  // 新建内容
  @State addTitle:string = ''
  @State addContent:string = ''

  // note列表
  @State noteList: Note[] = []

  // 缓存note
  originNoteList :Note[] = []

  // 编辑笔记弹窗
  @State isEditDialogShow : boolean = false

  // 编辑内容
  @State editContent:string = ''
  @State editTitle:string = ''

  // 当前note索引
  editNoteIndex : number = -1

  // 点击
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

  // 关闭方法
  closeDialog = ()=>{
    this.isAddDialogShow = false
    this.addTitle = ''
    this.addContent = ''
    this.isEditDialogShow = false
    this.editTitle = ''
    this.editContent = ''
    this.editNoteIndex = -1
  }

  // 新增
  createNote = ()=>{
    const date: Date = new Date()
    const newNote : Note = new Note(0, date.getTime(), this.addTitle, this.addContent) // 当时加入编辑后，发现新增出问题了，原来是这里忘记从editContent改为addContent了
    this.NoteTable.insertData(newNote, (id: number) => {
      newNote.id = id
      this.originNoteList.push(newNote)
      this.noteList = this.originNoteList
      this.closeDialog()
    })
  }

  // 删除笔记
  deleteNote = ()=>{
    if (this.editNoteIndex !== -1) {
      this.NoteTable.deleteData(this.originNoteList[this.editNoteIndex], () => {
        this.originNoteList.splice(this.editNoteIndex, 1)
        this.noteList = this.originNoteList
        this.closeDialog()
      })
    }
  }

  // 修改笔记
  saveNote = ()=>{
    const date: Date = new Date()
    this.originNoteList[this.editNoteIndex].content = this.editContent
    this.originNoteList[this.editNoteIndex].updateTime = date.getTime()
    this.originNoteList[this.editNoteIndex].title = this.editTitle
    this.NoteTable.updateData(this.originNoteList[this.editNoteIndex], () => {
      this.noteList = this.originNoteList
      this.closeDialog()
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
        this.noteList = this.originNoteList
      })
    })
  }

  // 搜索
  @State @Watch('onSearchKeywordsChange') keywords : string = ''
  // 搜索过滤
  onSearchKeywordsChange(){
    if (this.keywords.length === 0){
      this.noteList = this.originNoteList
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
                (note:Note,index:number) =>{
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

    }
    .backgroundColor('#f1f1f3')
    .width('100%')
    .height('100%')
  }
}