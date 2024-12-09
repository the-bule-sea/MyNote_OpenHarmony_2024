import router from '@ohos.router';
import preferences from '@ohos.data.preferences';

@Entry
@Component
struct NoteList {
  @State private notes: Array<{ title: string; content: string }> = [];
  private storage: preferences.Preferences | null = null;
  async onPageShow() {
    try {
      const context = globalThis.getContext();
      const fileName = 'notes.preferences';
      console.log("notes初始化");
      this.storage = await preferences.getPreferences(context, fileName);

      if (this.storage) {
        console.log("storage有值")
        const storedNotes = await this.storage.getAll();
        console.log("storedNotes的值",JSON.stringify(storedNotes));
        try {
          // 如果 storedNotes 是对象，且有 notes 字段
          if (typeof storedNotes === 'object' && 'notes' in storedNotes) {
            console.log("storedNotes是对象，且有notes字段");
            // const notesString = storedNotes.notes; // 获取 notes 字段的值
            const notesString = (storedNotes as { notes: string }).notes;
            this.notes = JSON.parse(notesString); // 解析为数组并赋值
            console.log("notes数据",JSON.stringify(this.notes));
          } else {
            console.error('Invalid storedNotes format:', storedNotes);
          }
        } catch (err) {
          console.error('Error parsing storedNotes.notes:', err);
        }
      }
    } catch (err) {
      console.error('Failed to initialize preferences:', err);
    }
  }

  build() {
    Column() {
      Text('便签列表')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16 });

      ForEach(this.notes, (note, index) => {
        Button(note.title)
          .type(ButtonType.Normal)
          .onClick(() => this.openEditor(note, index))
          .margin(8)
          .width('90%')
          .backgroundColor('#99CCCC')
          .borderRadius(2);
      });

      Button('添加便签')
        .onClick(() => this.addNote())
        .backgroundColor('#007dff')
        .borderRadius(8)
        .width('50%')
        .margin({ top: 20 });
    }
    .padding(16)
    .width('100%')
    .height('100%');
  }

  private openEditor(note: { title: string; content: string }, index: number) {
    router.pushUrl({
      url: 'pages/Editor',
      params: { note, index },
    });
  }

  private addNote() {
    router.pushUrl({ url: 'pages/Editor',
    });
  }
}