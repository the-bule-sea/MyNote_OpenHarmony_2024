// 此页代码原创

import Note from '../model/Note'
import dataPreference from '@ohos.data.preferences'
import preferences from '@ohos.data.preferences'

export interface NoteDTO{
  id: string                //笔记id
  title: string             //笔记标题
  content: string           //笔记正文
  ownerId: string           //笔记所有者id
  lastModifiedDate: string  //上一次编辑时间，utc标准时间
  createdDate: string       //笔记创建时间，utc标准
}

// 将NoteDto转化为Note对象
export function conveyNoteDtoToNote(noteDto: NoteDTO){
  return new Note(
    conveyToLocalId(noteDto.id),
    new Date(noteDto.lastModifiedDate).getTime(),
    noteDto.title,
    noteDto.content
  )
}

// 专栏：uuid2int存储
// uuid 的类型是bigint（16字节）无法直接转化为number（int 8字节）
// 散列化存储（Map<crc32(uuid), uuid>）
// 并将散列化的uuid（crc32(uuid)）作为本地数据库存储
const KEY = 'SERVER_UUID'
const LOCAL_ID_AND_DB_ID = 'LOCAL_ID_AND_DB_ID'
// 工具函数UUID string2int
function crc32(str: string): number {
  const table: number[] = Array(256)
    .fill(0)
    .map((_, i) => {
      let c = i;
      for (let k = 0; k < 8; k++) {
        c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
      }
      return c >>> 0;
    });

  let crc = 0xffffffff;
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i);
    crc = table[(crc ^ char) & 0xff] ^ (crc >>> 8);
  }

  return (crc ^ 0xffffffff) >>> 0;
}

export function conveyToLocalId(uuid: string): number {
  // crc32散列
  const hash = crc32(uuid);
  // Dict持久化
  const preferenceInstance = dataPreference.getPreferences(getContext(), KEY)
  preferenceInstance.then(ins => {
    ins.put(hash.toString(), uuid)
    ins.flush()
  })
  return hash
}

export function storeLocalIdAndRdbID(localId: number, rdbId: number){
  // RdbId to LocalId
  const localIdPreference = dataPreference.getPreferences(getContext(), LOCAL_ID_AND_DB_ID)
  localIdPreference.then(ins => {
    ins.put(rdbId.toString(), localId.toString())
    ins.flush()
  })
}

// rdb.id
export function conveyToRemoteId(id: number): Promise<string> {
  // Dict持久化
  const preferenceInstance = dataPreference.getPreferences(getContext(), KEY)
  const localIdPreference = dataPreference.getPreferences(getContext(), LOCAL_ID_AND_DB_ID)
  return new Promise(async (resolve, reject) => {
    console.log('rdb_id: ', id)
    const _lpre = await localIdPreference
    // rdbId to localId
    const local_id = await _lpre.get(id.toString(), '') as string
    console.log('local_id: ', local_id)

    const _pre = await preferenceInstance
    // localId to RemoteId
    const value = await _pre.get(local_id, '') as string
    console.log('remote_id: ', value)
    if (value === ''){
      reject()
    }
    resolve(value)
  })
}