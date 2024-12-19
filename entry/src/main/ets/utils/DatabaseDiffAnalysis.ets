// 数据库差量分析专栏
import Note from '../model/Note';
import NoteTable from '../database/NoteTable';
import { Server } from '../server/Server';
import { conveyNoteDtoToNote, conveyToRemoteId, storeLocalIdAndRdbID } from '../server/Model';
import promptAction from '@ohos.promptAction';

// 假设：未上传的note的id<1000
// 已同步的note使用server分配的id
// 两阶段同步：Remote -> Local, Local -> Remote

// 将远程的Note同步到本地， 返回更新的Note数量
export function syncFromRemoteCompletely(server: Server, db: NoteTable): Promise<Note[]>{
  return new Promise((resolve, reject) => {
    console.log('远程同步')
    server.getAllNotes().then(r => {
      console.log('getAllNotes response', JSON.stringify(r.data))
      // 获取Array<Note>
      let temp: Array<Note> = []
      const noteDtoList = r.data
      for (let index = 0; index < noteDtoList.length; index++) {
        const element = noteDtoList[index];
        // 将远程Note对象转化为本地Note对象
        temp.push(conveyNoteDtoToNote(element))
      }
      const remote = temp
      let local = []
      for (let i = 0; i < remote.length; i++) {
        const element = remote[i]
        // md 全删了
        db.deleteAll(() => {
          db.insertData(element, (id: number) => {
            storeLocalIdAndRdbID(element.id, id)
            element.id = id
            local.push(element)
          })
          resolve(local)
        })
      }
      // db.getRdbStore(() => {
      //   db.query((result: Note[]) => {
      //     let updatedRowsCount = 0
      //     for (let index = 0; index < result.length; index++) {
      //       // 本地note对象
      //       const element = result[index];
      //       for (let _index = 0; _index < remote.length; _index++) {
      //         // remote note对象
      //         const _element = remote[_index];
      //         if (_element.id === element.id){
      //           // 如果本地的上一次编辑时间大于远程的上一次编辑时间就更新
      //           if (element.updateTime > _element.updateTime)
      //             db.updateData(_element, () => {
      //               // 记录更新行数
      //               updatedRowsCount++
      //             })
      //         }
      //       }
      //     }
      //     // 提交更新行数
      //     resolve(updatedRowsCount)
      //   })
      // })
    }).catch(r => console.log('server.getAllNotes()', r))
  })
}

// 将本地Note记录全部提交到服务器，返回更新行数
export function pushToRemoteCompletely(server: Server, db: NoteTable): Promise<number>{
  return new Promise(async (resolve, reject) => {
    db.getRdbStore(() => {
      db.query((result: Note[]) => {
        let updatedRowsCount = 0
        for (let index = 0; index < result.length; index++) {
          const element = result[index];
          // 将未同步的笔记createNote
          // 假定未同步的笔记Id小于1000
          // TODO 合理的策略判断未同步笔记
          if (element.id < 1000)
            server.createNotes(element.title, element.content)
          // 将已同步的笔记updateNode
          else {
            conveyToRemoteId(element.id).then( remoteId =>
              server.updateNoteById(remoteId, element.title, element.content).catch(r => {
                updatedRowsCount++;
              }).catch(e => reject(e))
            )
          }
        }
        resolve(updatedRowsCount)
      })
    })
  })
}

// 推送单个更新到服务器
export function pushToRemote(server: Server, note: Note): Promise<boolean>{
  return new Promise((resolve, reject) => {
    console.log('rdb.id: ', note.id)
    conveyToRemoteId(note.id).then( remoteId => {
      server.updateNoteById(remoteId, note.title, note.content)
      resolve(true)
    }).catch(e => reject(e))
  })
}