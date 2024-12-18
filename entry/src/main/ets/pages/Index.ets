import router from '@ohos.router';
import CustomEditDialog from '../component/CustomEditDialog';
import CustomTitle from '../component/CustomTitle'
import CustomAddDialog from '../component/CustomAddDialog'
import CustomSearch from  '../component/CustomSearch'
import NoteList from '../component/NoteList'
import Note from '../model/Note'



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