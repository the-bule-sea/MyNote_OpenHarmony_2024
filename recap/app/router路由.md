### 启动时页面不对(白屏)
参考链接：
[【ArkTS】路由传参_arkts路由传值-CSDN博客](https://blog.csdn.net/owo_ovo/article/details/135038494)

1、 检查`EntryAbility.ts`的启动项是否修改：
![](/recap/app/attachments/Pastedimage20241117223519.png)

2、检查路由表是否正确，路径` entry > src > main > resources > base > profile > main_pages.json`
![](/recap/app/attachments/Pastedimage20241117223732.png)

> [!NOTE]
> 在pages目录下创建的文件会自动添加到main_pages.json文件中，非pages目录下需要手动配置
