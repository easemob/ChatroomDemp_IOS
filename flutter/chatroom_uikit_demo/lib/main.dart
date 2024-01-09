import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:chatroom_uikit_demo/local.dart';
import 'package:chatroom_uikit_demo/model/room.dart';
import 'package:chatroom_uikit_demo/model/user.dart';
import 'package:chatroom_uikit_demo/room_view.dart';
import 'package:chatroom_uikit_demo/room_list_view.dart';
import 'package:chatroom_uikit_demo/tools/demo_tool.dart';
import 'package:chatroom_uikit_demo/tools/server_tool.dart';
import 'package:chatroom_uikit_demo/tools/user_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'notifications/theme_notification.dart';

void main() async {
  await ChatroomUIKitClient.instance.initWithAppkey(
    'easemob#chatroom-uikit',
    debugMode: true,
  );
  UserTool.instance.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
  @override
  void initState() {
    super.initState();

    Map<String, dynamic> zh = {}
      ..addAll(DemoLocal.zh)
      ..addAll(ChatroomLocal.zh);
    Map<String, dynamic> en = {}
      ..addAll(DemoLocal.en)
      ..addAll(ChatroomLocal.en);
    _localization.init(mapLocales: [
      MapLocale('zh', zh),
      MapLocale('en', en),
    ], initLanguageCode: 'zh');

    ChatRoomSettings.defaultGiftIcon = 'assets/images/sweet_heart.png';
    ChatRoomSettings.defaultGiftPriceIcon = 'assets/images/dollar.png';
    ChatRoomSettings.enableMsgListGift = true;
    ChatRoomSettings.enableMsgListIdentify = false;
    ChatRoomSettings.enableParticipantItemIdentify = false;
  }

  bool isLight = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: EasyLoading.init(
        builder: (context, child) {
          return NotificationListener(
            child: ChatUIKitTheme(
              color: isLight ? ChatUIKitColor.light() : ChatUIKitColor.dark(),
              child: child!,
            ),
            onNotification: (notification) {
              if (notification is ThemeNotification) {
                setState(() {
                  isLight = notification.isLight;
                });
              }
              return false;
            },
          );
        },
      ),
      localeResolutionCallback: (locale, supportedLocales) {
        return locale;
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            if (settings.name == 'room_list_view') {
              return const RoomListView();
            } else if (settings.name == 'room_view') {
              Locale locale = Localizations.localeOf(context);
              return RoomView(
                settings.arguments as Room,
                languageCode: locale.languageCode.toLanguageCode(),
              );
            }
            return Container();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      doLogin();
    });
  }

  Future<void> login() async {
    isLoading.value = true;
    String userId = UserTool.instance.userId;
    String nickname = UserTool.instance.nickname;
    String avatar = UserTool.instance.avatar;
    User user = User(
      userId,
      avatarURL: avatar,
      nickname: nickname,
      identify:
          'https://accktvpic.oss-cn-beijing.aliyuncs.com/pic/sample_avatar/sample_avatar_1.png',
    );
    String? token = await ServerTools.loginUser(userId, user);
    if (token != null) {
      try {
        await ChatroomUIKitClient.instance.logout();
        await ChatroomUIKitClient.instance.loginWithToken(
          userId: userId,
          token: token,
          userInfo: user,
        );
        UserTool.instance.saveToken(token);
      } catch (e) {
        throw Exception('login failed');
      }
    } else {
      throw Exception('login failed');
    }
  }

  void doLogin() {
    isLoading.value = true;
    login().then((value) {
      Navigator.of(context).pushNamed('room_list_view');
    }).catchError((e) {
      loginFailed();
    }).onError((error, stackTrace) {
      vLog(error.toString());
    }).whenComplete(() {
      isLoading.value = false;
    });
  }

  void loginFailed() {
    showDialog(
      barrierColor: Colors.black12,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ChatDialog(
          title: '登录失败',
          items: [
            ChatDialogItem.confirm(
                label: '重新登录',
                onTap: () async {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(seconds: 1)).then((value) {
                    doLogin();
                  });
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/welcome_icon.png',
                  width: 120,
                  height: 120,
                ),
                const Text(
                  "环信聊天室",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 159, 255, 1),
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 10,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 120,
              left: 10,
              right: 10,
              child: ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, value, child) {
                  return !value
                      ? const Offstage()
                      : const Center(
                          child: SizedBox(
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                              color: Colors.grey,
                            ),
                          ),
                        );
                },
              )),
          Positioned(
            bottom: 40,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  DemoTools.appInfo,
                  style:
                      const TextStyle(color: Color.fromRGBO(108, 113, 146, 1)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
