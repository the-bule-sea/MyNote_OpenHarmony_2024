import router from '@ohos.router';

@Component
export default struct CustomTitle{
  // 顶部标题
  build(){
    Row() {
      Text($r('app.string.app_name'))
        .fontColor($r('app.color.color_text_major'))
        .fontSize(32)
        .fontWeight(600)
        .layoutWeight(1)
        .margin({ left: 16 })
        .align(Alignment.Start)
      Blank()
      Image($r("app.media.icon_settings"))
        .width(46)
        .height(46)
        .margin({ right: 16 })
        .padding(6)
        .backgroundColor('#f3f3f3')
        .borderRadius(8)
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          router.pushUrl({ url: 'pages/Mine' })
        })
    }
    .margin({top:5, bottom:3})
    .backdropBlur(10)
    .height(56)
    .width('100%')
  }
}