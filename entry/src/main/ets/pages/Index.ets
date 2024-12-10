import router from '@ohos.router';

import CustomTitle from '../component/CustomTitle'



@Entry
@Component
@Preview

struct Index {


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
        // .onClick(() => {
        //   // this.isEditDialogShow = true
        //   this.isAddDialogShow = true
        // })


    }
    .backgroundColor('#f1f1f3')
    .width('100%')
    .height('100%')
  }




}