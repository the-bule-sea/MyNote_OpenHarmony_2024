// RDB设计部分参考开源项目[基于ArkTS的笔记Demo练习应用](https://gitee.com/J-Design/easy-memo)
// generateBucket()函数为原创

import relationalStore from '@ohos.data.relationalStore';
import Note from '../model/Note'
import CommonConstants from '../constants/CommonConstants';
import Rdb from './Rdb';

// 笔记的数据库类，基于Rdb类，有业务属性
export default class NoteTable {
  // 通过Rdb类实例化noteTable对象，使用常量文件“CommonConstants”中配置的参数
  private noteTable = new Rdb(CommonConstants.NOTE_TABLE.tableName, CommonConstants.NOTE_TABLE.sqlCreate,
    CommonConstants.NOTE_TABLE.columns);

  // 构造函数，执行getRdbStore方法
  constructor(callback: Function = () => {
  }) {
    this.noteTable.getRdbStore(callback);
  }
  // 通过noteTable对象，执行原Rdb类中的getRdbStore方法，为noteTable对象获取rdbStore操作对象
  getRdbStore(callback: Function = () => {
  }) {
    // 透传回调函数
    this.noteTable.getRdbStore(callback);
  }

  // 插入数据的方法，接收单条note笔记对象，和回调函数
  insertData(note: Note, callback: Function) {
    // 通过工具函数，将单条note笔记，转化为存储健值对
    const valueBucket: relationalStore.ValuesBucket = generateBucket(note);
    // 执行noteTable的插入数据方法，透传回调函数
    this.noteTable.insertData(valueBucket, callback);
  }

  // 删除数据的方法，接收单条note笔记对象，和回调函数
  deleteData(note: Note, callback: Function) {
    // 初始化操作数据库的谓词对象
    let predicates = new relationalStore.RdbPredicates(CommonConstants.NOTE_TABLE.tableName);
    // 配置谓词以匹配数据表的id列中值的字段，为笔记对象的id
    predicates.equalTo('id', note.id);
    // 使用谓词执行noteTable的删除方法，透传回调函数
    this.noteTable.deleteData(predicates, callback);
  }

  // 删除数据的方法，接收单条note笔记对象，和回调函数
  deleteAll(callback: Function) {
    // 初始化操作数据库的谓词对象
    let predicates = new relationalStore.RdbPredicates(CommonConstants.NOTE_TABLE.tableName);
    // 配置谓词以匹配数据表的id列中值的字段，为笔记对象的id
    predicates.notEqualTo('id', '0');
    // 使用谓词执行noteTable的删除方法，透传回调函数
    this.noteTable.deleteData(predicates, callback);
  }

  // 更新数据的方法，接收单条note笔记对象，和回调函数
  updateData(note: Note, callback: Function) {
    // 通过工具函数，将单条note笔记，转化为存储健值对
    const valueBucket: relationalStore.ValuesBucket = generateBucket(note);
    // 初始化操作数据库的谓词对象
    let predicates = new relationalStore.RdbPredicates(CommonConstants.NOTE_TABLE.tableName);
    // 配置谓词以匹配数据表的id列中值的字段，为笔记对象的id
    predicates.equalTo('id', note.id);
    // 使用谓词执行noteTable的更新方法，透传回调函数
    this.noteTable.updateData(predicates, valueBucket, callback);
  }

  // 查询全部笔记的方法
  query(callback: Function) {
    // 初始化操作数据库的谓词对象
    let predicates = new relationalStore.RdbPredicates(CommonConstants.NOTE_TABLE.tableName);
    // 使用谓词执行noteTable的查询方法，此时谓词匹配未指定（equalTo），所以将查询全部
    this.noteTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      // 创建局部变量，存储结果的行数
      let count: number = resultSet.rowCount;
      // 如果查询的结果为0，执行回调函数，传入空数组
      if (count === 0 || typeof count === 'string') {
        console.log(`${CommonConstants.TABLE_TAG}` + 'Query no results!');
        callback([]);
      } else {
        // 如果有结果，将结果集指向第一行
        resultSet.goToFirstRow();
        // 创建局部变量，存储最后将返回的结果数组
        const result: Note[] = [];
        // 使用循环为结果添加内容
        for (let i = 0; i < count; i++) {
          let tmp: Note = {
            id: 0, updateTime: 0, content: '', title: ''
          };
          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.updateTime = resultSet.getDouble(resultSet.getColumnIndex('updateTime'));
          tmp.content = resultSet.getString(resultSet.getColumnIndex('content'));
          tmp.title = resultSet.getString(resultSet.getColumnIndex('title'))
          result[i] = tmp;
          // 转至下一行
          resultSet.goToNextRow();
        }
        // 执行回调函数，把所有的查询结果传入
        callback(result);
      }
    });
  }
}

// 工具函数，将note笔记的数据结构，转化为存储键值对
function generateBucket(note: Note): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};
  obj.updateTime = note.updateTime
  obj.content = note.content
  obj.title = note.title
  return obj;
}