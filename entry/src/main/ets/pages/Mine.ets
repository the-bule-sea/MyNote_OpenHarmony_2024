import promptAction from '@ohos.promptAction';
import pasteboard from '@ohos.pasteboard';

// 此页代码为原创

@Entry
@Component
struct MinePage {
  @State appName: string = "MyNote"
  @State appVersion: string = "1.0.0"
  @State developerName: string = "the-bule-sea"
  @State developerName2: string = "Ifilk"
  @State developerName3: string = "TechNinja-Sun"
  @State githubUrl: string = "https://github.com/the-bule-sea/MyNote_OpenHarmony_2024"
  @State developerUrl: string = "https://github.com/the-bule-sea"
  @State developerUrl2: string = "https://github.com/Ifilk"
  @State developerUrl3: string = "https://github.com/TechNinja-Sun"

  handleCopyText(text) {
    // 创建剪贴板内容对象
    let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
    // 获取系统剪贴板
    let systemPasteboard = pasteboard.getSystemPasteboard()
    // 将数据写入系统剪贴板
    systemPasteboard.setData(pasteData).then(() => {
      promptAction.showToast({
        message: '地址复制成功',
      })
    }).catch((err) => {
      promptAction.showToast({
        message: err.message,
      })
    });
  }

  build() {
    Column({ space: 20 }) {
      // 应用图标和标题
      Stack({ alignContent: Alignment.Center }) {
        Image($r('app.media.icon')) // 替换为你的图片资源路径
          .width(100)
          .height(100)
          .margin({ top: 20 })
        Text(this.appName)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 150 })
      }
      Divider() // 分割线

      // 开发者信息部分
      Column() {
        Text('应用开发者')
          .fontSize(16)
          .fontWeight(600)
          .margin({ bottom: 12 }) // 调整标题与头像之间的间距

        Row() { // 控制头像之间的间距
          // 第一个头像和名字
          Column() {
            Button() {
              Image($r('app.media.avat_S'))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Cover)
            }
            .onClick(()=>{
              this.handleCopyText(this.developerUrl)
            })
            .shadow({
              radius: 5,
              offsetX: 2,
              offsetY: 2
            })
            .width(60)
            .height(60)
            .borderRadius(30)
            .clip(true)

            Text(this.developerName)
              .fontSize(14)
              .fontColor(Color.Gray)
              .textAlign(TextAlign.Center)
          }
          // 第二个头像和名字
          Column() {
            Button() {
              Image($r('app.media.avat_I'))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Cover)
            }
            .onClick(()=>{
              this.handleCopyText(this.developerUrl2)
            })
            .shadow({
              radius:5,
              offsetX:2,
              offsetY:2
            })
            .width(60)
            .height(60)
            .borderRadius(30)
            .clip(true)

            Text(this.developerName2)
              .fontSize(14)
              .fontColor(Color.Gray)
              .textAlign(TextAlign.Center)
          }
          // 第三个头像和名字
          Column() {
            Button() {
              Image($r('app.media.avat_T'))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Cover)
            }
            .onClick(()=>{
              this.handleCopyText(this.developerUrl3)
            })
            .shadow({
              radius:5,
              offsetY:2,
              offsetX:2
            })
            .width(60)
            .height(60)
            .borderRadius(30)
            .clip(true)

            Text(this.developerName3)
              .fontSize(14)
              .fontColor(Color.Gray)
              .textAlign(TextAlign.Center)
          }
        }
        .size({width: "100%"})
        .justifyContent(FlexAlign.SpaceAround) // 头像均匀分布
        .margin({ top: 12 }) // 调整头像与“应用开发者”标题之间的间距
      }
      .width('100%')

      Divider() // 分割线

      // 应用信息部分
      Column({ space: 10 }) {
        Row() {
          Text('应用版本')
            .fontSize(16)
            .flexGrow(1)
            .align(Alignment.Start)
          Text(this.appVersion)
            .fontSize(14)
            .fontColor(Color.Gray)
            .align(Alignment.End)
        }
        .width('100%')

        Divider()
        Row() {
          Text('开源仓库')
            .fontSize(16)
            .flexGrow(1)
            .align(Alignment.Start)
          Button(){
            Image($r('app.media.icon_github'))
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Cover)
          }
          .backgroundColor('')
          .borderRadius(30)
          .clip(true)
          .align(Alignment.End)
          .width(30)
          .height(30)
          .shadow({
            radius:3
          })
          .onClick(()=>{
            // promptAction.showToast({message: '已复制项目开源地址'})
            this.handleCopyText(this.githubUrl)
          })
        }
        .width('100%')
      }
      .padding(20) // 为信息列表添加内边距
    }
    .padding(20) // 为整个页面添加内边距
    .height('100%')
    .backgroundColor($r('app.color.block_container'))
  }
}