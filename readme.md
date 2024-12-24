# 基于ArkUI+ArkTs的一个MD风格OpenHarmony / HarmonyOS 原生笔记app
## 参赛信息
- 比赛方向：OS应用开发
- 所属学校：上海电力大学
- 队伍信息：
    - 队伍ID：T202410256994396
    - 队伍名称：“毕竟是高性能的”
    - 队伍成员：胡琦、蔡振中、孙胜雷
    - 指导老师：徐曼
## 项目简介
![图标](/showpic/icon_v4.png)

`HarmonyMyNote!!!`是一个基于ArkUI+ArkTs、API9，使用鸿蒙生态的应用开发语言ArkTs，可运行在OpenHarmony、HarmonyOS系统的软件。
参考md设计风格。
本地存储使用了华为官方本地关系数据库RDB，实现了笔记的本地持久化存储。
云服务器使用由kotlin编写的java应用，即兼具了Java对各大开源系统的跨平台支持，也通过Kotlin所提供的现代化语法糖进行迅捷开发。云服务器使用令牌桶算法进行限流、并且User、Note持久化对象键值使用UUID，具有很好的反爬机制，保证了服务高可用。
## 项目完成情况
- 实现了基本的笔记功能，包括创建、编辑、删除、搜索等。
- 实现了与后台服务器的同步，包括登录、拉取笔记、上传笔记等。
- 完成在HarmonyOS实机测试(Huawei P50-HarmonyOS 4.2, Huawei Nova9Pro-HarmonyOS 4.1)。
## 项目截图
演示：
![演示](/showpic/demo.gif)

首页：
![首页](/showpic/index_page.png)

我的界面(图1为原始版本，图2为后续版本)：
![我的](/showpic/mine_page.png)

弹窗：
![弹窗](/showpic/dialog.png)

图标设计：
![图标](/showpic/icon.png)

后台：
![后台](/showpic/server.png)

## 项目结构
Harmony软件项目结构如下：
```
+-- src
  +-- main
    +-- ets
      +-- component                   # 组件
        - CustomAddDialog.ets            # 自定义添加笔记组件
        - CustomEditDialog.ets           # 自定义编辑笔记组件
        - CustomSearch.ets               # 自定义搜索
        - CustomTitle.ets                # 自定义标题栏
        - LoginDialog.ets                # 登录窗口
        - NoteList.ets                   # 瀑布流笔记组件
      +-- constants                   # 持久化
        - CommonConstants.ets            # 持久化数据库配置
      +-- database                    # 数据库
        - NoteTable.ets                  # Rdb的业务函数
        - Rdb.ets                        # Rdb的方法属性定义
      +-- entryability                # 生命周期
        - EntryAbility.ts                # Harmony全局应用生命周期
      +-- model                       # 数据模型定义
        - Note.ets                       # 笔记对象
        - TableInterface.ets             # 数据库接口定义
      +-- pages                       # 页面
        - Index.ets                      # 主界面
        - Mine.ets                       # "我的"界面
      +-- server                      # 前后端链接
        - Model.ets                      # NoteDTO
        - Server.ets                     # 后台服务器连接配置
      +-- utils                       # 工具类
        - DatabaseDiffAnalysis.ets       # 数据库差量分析
        - Logger.ets                     # 日志
```

后台服务器代码结构如下：
```
- src
  - main
    - kotlin
      - xyz
        - ifilk
          +-- note_sync_server
            +-- common
              - HashUtil.kt
              - ServletUtil.kt
            +-- config
              - CacheConfig.kt
              - SwaggerConfig.kt
              - WebConfigurerAdapter.kt
            +-- controller
              - ExceptionController.kt
              - NoteController.kt
              - UserController.kt
            +-- entity
              - Note.kt
              - User.kt
            +-- exception
              - DuplicateUserNameException.kt
              - NoteNotFound.kt
              - UnAuthorized.ke
              - UserLoginVerifyException.kt
              - UserNotFound.kt
              - VerificationException.kt
            +-- interceptor
              - AccessLimiter.kt
              - AccessLimiterBucket.kt
              - AccessLimitInterceptor.kt
            +-- model
              - NoteApplyDto.kt
              - NoteDto.kt
            +-- repository
              - NoteRepository.kt
              - UserRepository.kt
            +-- service
              - NoteServiceImpl.kt
              - UserServiceImpl.kt
            - NoteSyncServerApplication.kt
  - resources
    - static
    - templates
    - application.yml
    - logback-spring.xml
```

## 项目参考
- [OpenHarmony](https://gitee.com/openharmony)
- [基于ArkTS的笔记Demo练习应用](https://gitee.com/J-Design/easy-memo):笔记新增、编辑窗口设计参考
- [鸿蒙CodeLab案例](https://gitee.com/harmonyos/codelabs/tree/master/Rdb):关系数据库RDB增删改查参考