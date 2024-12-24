// ArkUI设计部分参考开源项目[基于ArkTS的笔记Demo练习应用](https://gitee.com/J-Design/easy-memo)

@Component
export default struct CustomSearch{
  @Link keywords:string

  build(){
    Row(){
      Row(){
        Image($r('app.media.icon_search'))
          .width(16)
          .margin({left:10})
          .backgroundColor($r('app.color.block_container'))
        TextInput({
          placeholder: '搜索',
          text:this.keywords
        })
          .onChange((value:string)=>{
            this.keywords = value
          })
          .backgroundColor($r('app.color.block_container'))
      }
    }
    .margin({top:4, bottom: 4})
    .padding({right:52})
    .backgroundColor($r('app.color.block_container'))
    .borderRadius(16)


  }
}

@Preview
@Component
struct CustomSearchPreview{
  @State keywords:string = ''

  build(){
    CustomSearch({keywords:$keywords})
  }
}