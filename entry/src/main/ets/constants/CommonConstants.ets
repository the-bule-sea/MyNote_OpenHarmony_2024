// 持久化配置

import relationalStore from '@ohos.data.relationalStore'
import { NoteTable } from '../model/TableInterface'

export default class CommonConstants {

  // Rdb 数据库配置
  static readonly STORE_CONFIG:relationalStore.StoreConfig = {
    name:'database.db',
    securityLevel:relationalStore.SecurityLevel.S1
  }

  static readonly NOTE_TABLE:NoteTable = {
    tableName:'noteTable',
    sqlCreate:'CREATE TABLE IF NOT EXISTS noteTable(id INTEGER PRIMARY KEY AUTOINCREMENT, updateTime INTEGER, content TEXT, title TEXT)',
    columns:['id','updateTime','content','title']
  }

  static readonly RDB_TAG = '[Debug.Rdb]';
  static readonly TABLE_TAG = '[Debug.memoTable]';
  static readonly INDEX_TAG = '[Debug.Index]';

}