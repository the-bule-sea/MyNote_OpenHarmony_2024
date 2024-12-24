// 此页代码原创

import axios, { AxiosInstance, AxiosResponse } from '@ohos/axios'
import { NoteDTO } from './Model'

export class Server{
  // 远程服务器URL
  static REMOTE_SERVER_BASE_IP = 'http://192.168.43.78:3001'
  static BASE_URL = '/api/v1'
  static TIME_OUT = 10000
  // 用户Token
  static userToken: string

  base_client: AxiosInstance

  constructor() {
    if(Server.userToken === undefined){
      this.base_client = axios.create({
        baseURL: Server.REMOTE_SERVER_BASE_IP + Server.BASE_URL,
        timeout: Server.TIME_OUT,
        headers: {
          "Access-Control-Allow-Origin": Server.REMOTE_SERVER_BASE_IP
        }
      })
    }
  }

  // 设置token
  set_authorization_token(token: string){
    this.base_client = axios.create({
      baseURL: Server.REMOTE_SERVER_BASE_IP + Server.BASE_URL,
      timeout: Server.TIME_OUT,
      headers: {
        "Access-Control-Allow-Origin": Server.REMOTE_SERVER_BASE_IP,
        "www-authorization": token
      }
    })
  }

  // 登录接口
  // token存储在请求头www-authorized
  login(username: string, password: string): Promise<AxiosResponse<string>>{
    return this.base_client.post<string>(
      `/users/${username}/login?password=${password}`
    )
  }

  // 获取所有笔记
  // 必需设置token
  getAllNotes(): Promise<AxiosResponse<Array<NoteDTO>>>{
    return this.base_client.get<Array<NoteDTO>>(
      'notes'
    )
  }

  // 创建笔记, 返回笔记id
  // 必需设置token
  createNotes(title: string, content: string): Promise<AxiosResponse<string>>{
    return this.base_client.post<string>(`notes`,{
      "title": title,
      "content": content
    })
  }

  // 通过id获取笔记
  // 必需设置token
  getNoteById(noteId: string): Promise<AxiosResponse<NoteDTO>> {
    return this.base_client.get<NoteDTO>(`/notes/${noteId.split('-').join('')}`)
  }

  // 更新笔记, title不更新也要传入
  // 必需设置token
  updateNoteById(noteId: string, title: string, content: string): Promise<AxiosResponse<string>> {
    // console.log(`/notes/${noteId.split('-').join('')}`)
    return this.base_client.put<string>(`/notes/${noteId.split('-').join('')}`, {
      'title': title,
      'content': content
    })
  }

  // 删除笔记
  // 必需设置token
  deleteNoteById(noteId: string): Promise<AxiosResponse<string>> {
    return this.base_client.delete<string>(`/notes/${noteId.split('-').join('')}`)
  }

  //工具函数，获取token
  static getTokenFromAxiosResponse(response: AxiosResponse){
    return response.headers['www-authorized']
  }
}