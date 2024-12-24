// ArkUI设计部分参考开源项目[基于ArkTS的笔记Demo练习应用](https://gitee.com/J-Design/easy-memo)

@Component
export default struct LoginDialog{

  @Link username : string
  @Link password : string
  onSubmit:()=>void


  build(){
    Stack(){
      // 蒙层
      Rect()
        .height('100%')
        .width('100%')
        .fill('rgba(0,0,0,0.4)')
        .blur(10)
      // 卡片
      Column(){
        // 标题
        Text('请登录以使用云同步功能')
          .height('10%')
          .margin({left: 20, right:20, top: 20})
        // 文本区域
        TextInput({
          placeholder: '请输入用户名',
          text: this.username
        })
          .onChange((value:string)=>{
            this.username = value
          })
          .height('10%')
          .margin(20)
        // 文本区域
        TextInput({
          placeholder: '请输入密码',
          text: this.password,

        })
          .type(InputType.Password)
          .onChange((value:string)=>{
            this.password = value
          })
          .height('10%')
          .margin(20)

        // 按钮
        Row(){
          Button('登录')
            .width(150)
            .margin({top: 20})
            .onClick(() => {
              this.onSubmit()
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
      }
      .width('100%')
      .height('40%')
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
  @State username : string = ''
  @State password : string = ''

  build(){
    LoginDialog({username:$username, password:$password})
  }
}