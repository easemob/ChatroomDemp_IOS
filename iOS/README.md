# iOS 聊天室Demo

## 1.前置环境以及要求
- iOS13.0及其以上
- Xcode版本14及其以上
- [聊天室Demo中应用的服务端Api](https://github.com/easemob/livestream-demo-app-server/tree/live-room )部署到您的服务器

## 2.快速跑通demo

### 2.1 找到ChatroomDemo文件夹下podfile文件
在podfile中添加如下依赖

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'

target 'YourTarget' do
  use_frameworks!

  pod 'ChatroomUIKit'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
```

然后cd到终端下podfile所在文件夹目录执行

```
    pod install
```

>⚠️Xcode15编译报错 ```Sandbox: rsync.samba(47334) deny(1) file-write-create...```

> 解决方法: Build Setting里搜索 ```ENABLE_USER_SCRIPT_SANDBOXING```把```User Script Sandboxing```改为```NO```

### 2.2 找到AppDelegate.swift
填写您在[环信Console中创建应用的appkey](https://docs-im-beta.easemob.com/product/enable_and_configure_IM.html)

### 2.3 找到项目中Utils文件夹下的ChatroomRequest.swift文件

在您使用服务端源码部署到您的服务器地址后，替换其中host 即您的服务器主机地址，然后编译成功即可运行。

