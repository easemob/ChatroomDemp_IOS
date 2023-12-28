# 聊天室 Demo

此 demo 演示了如何快速通过环信的`easemob-chat-uikit`搭建一个泛娱乐场景下的具有 IM 能力的场景 demo。

| 角色     | 描述                 |
| -------- | -------------------- |
| 房主     | 聊天室创建者         |
| 普通用户 | 进入聊天室的其他用户 |

聊天室 Demo 提供以下核心功能：

- **房间管理**：创建、销毁房间，房间列表等。
- **用户管理**：房主可以踢人出房间或者禁言其他成员
- **消息管理**：撤回、举报、翻译等功能
- **聊天管理**：发送/接收聊天信息等
- **礼物管理**：发送/接收礼物消息等

## [聊天室 Demo 中应用的服务端 Api](https://github.com/easemob/livestream-demo-app-server/tree/live-room)

- 房间管理，包含房间的创建以及定时清理，常驻房间的处理。
- 房间中全局广播的消息的发送
- 房间中管理员通知消息的发送（例：房间 1min 后即将销毁的通知）

## Demo 体验

| iOS                                        | Android                                                                           | Web                                                           | Flutter                                                                            | RN                                                                    |
| ------------------------------------------ | --------------------------------------------------------------------------------- | ------------------------------------------------------------- | ---------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| https://testflight.apple.com/join/kc0vtbgH | https://downloadsdk.easemob.com/downloads/chatroom/chatroomdemo_android-1.0.0.apk | https://livestream-hsb.oss-cn-beijing.aliyuncs.com/index.html | iOS https://testflight.apple.com/join/NzmtvJ6n Android http://www.pgyer.com/YZUCrW | iOS https://www.pgyer.com/ZaEbya Android https://www.pgyer.com/miATnL |

## 快速开始

### 前提条件

1. 将 demo 中 App.ts 文件里的 appKey 换成自己的 appKey。
2. 参考“聊天室 Demo 中应用的服务端 Api”中的文档实现：生成 token、 创建聊天室、获取聊天室列表、销毁聊天室、自动向聊天室发送消息功能并部署后，替换 demo 中 apis/index.ts 中的 host 地址。

### 运行项目

1. 安装依赖

```bash
npm install
```

2. 启动项目

```bash
npm start
```

## 反馈

遇到问题可以提 issue

---

## FAQ

### 如何在环信官网创建应用

> 环信应用创建：[https://docs-im-beta.easemob.com/product/enable_and_configure_IM.html](https://docs-im-beta.easemob.com/product/enable_and_configure_IM.html)
