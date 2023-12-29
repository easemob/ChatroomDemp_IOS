# 聊天室Demo


## 概述

聊天室Demo

## 场景描述

此demo演示了如何快速通过环信的`ChatroomUIKit`搭建一个泛娱乐场景下的具有IM能力的场景demo。


| 角色   | 描述                                    |
|------|---------------------------------------|
| 房主   | 聊天室创建者                     |
| 普通用户   | 进入聊天室的其他用户                              |

聊天室Demo 提供以下核心功能：
- **房间管理**：创建、销毁房间，房间列表等。由
- **用户管理**：房主可以踢人出房间或者禁言其他成员
- **消息管理**：撤回、举报、翻译等功能
- **聊天管理**：发送/接收聊天信息等
- **礼物管理**：发送/接收礼物消息等



## Demo 体验
| iOS                                                          | Android                                                      | Web | Flutter                                                                            | RN                                                                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ |-----|------------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| https://testflight.apple.com/join/kc0vtbgH | https://downloadsdk.easemob.com/downloads/chatroom/chatroomdemo_android-1.0.0.apk  | https://livestream-hsb.oss-cn-beijing.aliyuncs.com/index.html | iOS https://testflight.apple.com/join/NzmtvJ6n Android http://www.pgyer.com/YZUCrW | iOS https://testflight.apple.com/join/773FJVTt Android https://www.pgyer.com/miATnL |

## 快速开始

| iOS                                            | Android                                    | Web                                | Flutter                                    | RN                               |
|------------------------------------------------|--------------------------------------------|------------------------------------|--------------------------------------------|----------------------------------|
| [ChatroomDemo(iOS)](iOS/README.md) | [ChatroomDemo(Android)](Android/README.md) | [ChatroomDemo(Web)](WEB/README.md) | [ChatroomDemo(Flutter)](flutter/README.md) | [ChatroomDemo(RN)](RN/README.md) |

## [聊天室Demo中应用的服务端Api](https://github.com/easemob/livestream-demo-app-server/tree/live-room )

- 房间管理，包含房间的创建以及定时清理，常驻房间的处理。
- 房间中全局广播的消息的发送
- 房间中管理员通知消息的发送（例：房间1min后即将销毁的通知）

## 反馈

遇到问题可以提issue,如遇紧急问题（付费用户）可发邮件联系商务 bd@easemob.com



---

## FAQ

### 如何在环信官网创建应用

> 环信应用创建：[https://docs-im-beta.easemob.com/product/enable_and_configure_IM.html](https://docs-im-beta.easemob.com/product/enable_and_configure_IM.html)

