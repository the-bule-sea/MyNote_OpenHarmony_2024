@Component
export default struct CustomAddDialog{

  @Link addContent : string
  @Link addTitle : string
  onClose:()=>void
  onCreate:()=>void


  build(){
    Stack(){
      // 蒙层
      Rect()
        .height('100%')
        .width('100%')
        .fill('rgba(0,0,0,0.4)')
        .blur(10)
        .onClick(()=>{
          this.onClose()
        })
      // 卡片
      Column(){
        // 标题
        TextArea({
          placeholder: '请输入标题',
          text: this.addTitle
        })
          .onChange((value:string)=>{
            this.addTitle = value
          })
          .height('10%')
          .margin({left: 20, right:20, top: 20})
        // 文本区域
        TextArea({
          placeholder: '请输入笔记',
          text: this.addContent
        })
          .onChange((value:string)=>{
            this.addContent = value
          })
          .height('60%')
          .margin(20)

        // 按钮
        Row(){
          Column(){
            Image($r("app.media.icon_back"))
              .width(30)
          }
          .backgroundColor('#32628d')
          .width(60)
          .height(60)
          .borderRadius(30)
          .justifyContent(FlexAlign.Center)
          .onClick(()=>{
            this.onClose()
          })

          Column(){
            Image($r("app.media.icon_save"))
              .width(30)
          }
          .backgroundColor('#32628d')
          .width(60)
          .height(60)
          .borderRadius(30)
          .justifyContent(FlexAlign.Center)
          .onClick(()=>{
            this.onCreate()
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
      }
      .width('100%')
      .height('60%')
      .borderRadius({topLeft: 16,topRight: 16})
      .backgroundColor('#cfe5ff')
    }
    .height('100%')
    .width('100%')
    .alignContent(Alignment.Bottom)
  }
}

@Preview
@Component
struct CustomEditDialogPreview{
  @State addContent : string = ''
  @State addTitle : string = ''

  build(){
    CustomAddDialog({addContent:$addContent, addTitle:$addTitle})
  }
}