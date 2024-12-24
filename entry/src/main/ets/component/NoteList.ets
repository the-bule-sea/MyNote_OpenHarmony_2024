import data from '@ohos.telephony.data'
import Note from '../model/Note'

interface TimeFormat{
  range: string
  formatDate: string
  formatTime: string
}

function getFormatTime(timeStamp:number):TimeFormat{
  const today = new Date();
  const date = new Date(timeStamp);

  console.log("新建时间为",data.toString())
  const diffTime = today.getTime() - date.getTime();
  const diffDays = Math.floor(diffTime / (24 * 60 * 60 * 1000));

  let range: string = ''

  if (diffDays === 0){
    range = '今天'
  }else if(diffDays === 1){
    range = '昨天'
  }else if(diffDays === 2){
    range = '前天'
  }else{
    range = '三天前'
  }

  const month: string = (date.getMonth() + 1).toString().padStart(2, '0') // 确保结果字符串至少有两个字符长
  const day: string = date.getDate().toString().padStart(2, '0')
  const hours: string = date.getHours().toString().padStart(2, '0')
  const minute: string = date.getMinutes().toString().padStart(2, '0')

  const formatDate: string = `${month}月${day}日`
  const formatTime: string = `${hours}:${minute}`

  return { range, formatDate, formatTime }

}

@Component
export default struct NoteList{

  @ObjectLink note:Note
  onNoteClick :(note:Note)=>void

   build(){
      Row(){
        Column(){
          // 顶部标题
          Text(this.note.title)
            .fontWeight(600)
            .padding({top:12})

          // 中部内容
          Text(this.note.content)
            .fontColor('#565c5a')
            .fontSize(18)
            .maxLines(4)
            .margin(2)

          // 底部内容
          Column(){
            // 横向剪切线
            Divider()
              .color('#cad4d2')
            // 底部时间
            Row({ space: 10 }) {
              Text(getFormatTime(this.note.updateTime).range)
                .fontSize(12).fontColor('#BFA290')
              Text(getFormatTime(this.note.updateTime).formatDate)
                .fontSize(12).fontColor('#BFA290')
              Text(getFormatTime(this.note.updateTime).formatTime)
                .fontSize(12).fontColor('#BFA290')
            }
            .justifyContent(FlexAlign.End)
            // .height(25)
          }
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .backgroundColor($r('app.color.block_container'))
        // .padding(16)
        .borderRadius(8)
        .height('100%')
      }
      .borderRadius(10)
      .padding(8)
      .height(200)
      .width('50%')
     .onClick(()=>{
       this.onNoteClick(this.note)
     })
   }
}

// @Preview
// @Component
// struct NoteListPreview{
//   @State note: Note = new Note(1, 1733463675067,'新建笔记', '使用毫秒时间戳曼波,然后发送曼波光线wow,op,原来,你也玩mc,鸣潮启动!!!!')
//
//   build(){
//     NoteList({note: this.note})
//   }
// }