import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:chatroom_uikit_demo/local.dart';
import 'package:chatroom_uikit_demo/model/room.dart';
import 'package:chatroom_uikit_demo/notifications/theme_notification.dart';
import 'package:chatroom_uikit_demo/tools/server_tool.dart';
import 'package:chatroom_uikit_demo/tools/user_tool.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RoomListView extends StatefulWidget {
  const RoomListView({super.key});

  @override
  State<RoomListView> createState() => _RoomListViewState();
}

class _RoomListViewState extends State<RoomListView> {
  @override
  void initState() {
    super.initState();
    fetchRoomList();
  }

  bool isNight = true;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final List<Room> rooms = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ChatUIKitTheme.of(context).color.isDark
            ? ChatUIKitTheme.of(context).color.neutralColor1
            : ChatUIKitTheme.of(context).color.neutralColor95,
        appBar: AppBar(
          backgroundColor: ChatUIKitTheme.of(context).color.isDark
              ? ChatUIKitTheme.of(context).color.neutralColor1
              : ChatUIKitTheme.of(context).color.neutralColor95,
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 56,
                height: 28,
                child: Switch(
                  thumbIcon: MaterialStatePropertyAll(
                    Icon(
                      !isNight ? Icons.bedtime : Icons.sunny,
                      color: Colors.white,
                    ),
                  ),
                  trackOutlineColor:
                      MaterialStateProperty.all(Colors.transparent),
                  activeTrackColor:
                      ChatUIKitTheme.of(context).color.neutralColor4,
                  inactiveThumbColor: Colors.blue,
                  activeColor: Colors.blue,
                  value: !isNight,
                  onChanged: (value) {
                    isNight = !value;
                    ThemeNotification(!value).dispatch(context);
                  },
                ),
              ),
            ),
          ],
          title: Row(
            children: [
              Text(
                DemoLocal.channelList.getString(context),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: ChatUIKitTheme.of(context).color.isDark
                        ? ChatUIKitTheme.of(context).color.neutralColor98
                        : ChatUIKitTheme.of(context).color.neutralColor1),
              ),
              ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: () {
                        if (!value) {
                          return InkWell(
                            onTap: () {
                              fetchRoomList();
                            },
                            child: Image.asset(
                              'assets/images/reload.png',
                              fit: BoxFit.fill,
                              color: ChatUIKitTheme.of(context).color.isDark
                                  ? ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor95
                                  : ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor3,
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(3),
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              color: ChatUIKitTheme.of(context).color.isDark
                                  ? ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor9
                                  : ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor3,
                            ),
                          );
                        }
                      }(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: _buildContent(),
        ));
  }

  Widget _buildContent() {
    Widget content = ListView.builder(
      itemBuilder: (context, index) {
        return RoomListItem(rooms[index], () {
          joinRoom(rooms[index]);
        });
      },
      itemCount: rooms.length,
    );

    content = Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 66),
      child: content,
    );

    content = Stack(
      children: [
        content,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 66,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: (ChatUIKitTheme.of(context).color.isDark
                      ? ChatUIKitTheme.of(context).color.neutralColor2
                      : ChatUIKitTheme.of(context).color.neutralColor9),
                ),
              ),
              color: ChatUIKitTheme.of(context).color.isDark
                  ? ChatUIKitTheme.of(context).color.neutralColor1
                  : ChatUIKitTheme.of(context).color.neutralColor95,
            ),
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(18)),
                  child: ChatImageLoader.networkImage(
                    image: UserTool.instance.avatar,
                    placeholderWidget: ChatImageLoader.defaultAvatar(),
                  ),
                ),
                const SizedBox(width: 12),
                Text(UserTool.instance.nickname,
                    style: TextStyle(
                        fontSize: ChatUIKitTheme.of(context)
                            .font
                            .titleMedium
                            .fontSize,
                        fontWeight: ChatUIKitTheme.of(context)
                            .font
                            .titleMedium
                            .fontWeight,
                        color: ChatUIKitTheme.of(context).color.isDark
                            ? ChatUIKitTheme.of(context).color.neutralColor98
                            : ChatUIKitTheme.of(context).color.neutralColor1)),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    createRoom();
                  },
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.fromLTRB(14, 10, 20, 10),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: ChatUIKitTheme.of(context).color.isDark
                            ? ChatUIKitTheme.of(context).color.primaryColor6
                            : ChatUIKitTheme.of(context).color.primaryColor5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/subtract.png',
                          width: 15,
                          height: 10.5,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          DemoLocal.create.getString(context),
                          style: TextStyle(
                              height: 1.1,
                              fontSize: ChatUIKitTheme.of(context)
                                  .font
                                  .titleMedium
                                  .fontSize,
                              fontWeight: ChatUIKitTheme.of(context)
                                  .font
                                  .titleMedium
                                  .fontWeight,
                              color: ChatUIKitTheme.of(context).color.isDark
                                  ? ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor98
                                  : ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor98),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );

    content = SafeArea(child: content);

    return content;
  }

  void fetchRoomList() async {
    isLoading.value = true;
    try {
      List<Room>? list = await ServerTools.getRoomList();
      if (list?.isNotEmpty == true) {
        rooms.clear();
        rooms.addAll(list!);
      }
    } catch (e) {
      vLog(e.toString());
      EasyLoading.showError(DemoLocal.loadFailed.getString(context));
    }
    isLoading.value = false;
    setState(() {});
  }

  void createRoom() async {
    String roomName =
        '${UserTool.instance.nickname}${DemoLocal.channelListName.getString(context)}';
    ServerTools.createRoom(
      roomName,
      UserTool.instance.userId,
    ).then((value) {
      Navigator.of(context)
          .pushNamed('room_view', arguments: value)
          .then((value) {
        fetchRoomList();
      });
    }).catchError((e) {
      EasyLoading.showError(e.toString());
    });
  }

  void joinRoom(Room room) async {
    Navigator.of(context)
        .pushNamed(
      'room_view',
      arguments: room,
    )
        .then((value) {
      fetchRoomList();
    });
  }
}

class RoomListItem extends StatelessWidget {
  const RoomListItem(this.room, this.onJoinTap, {super.key});

  final Room room;
  final VoidCallback onJoinTap;

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: ChatUIKitTheme.of(context).color.isDark
            ? ChatUIKitTheme.of(context).color.neutralColor2
            : ChatUIKitTheme.of(context).color.neutralColor98,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(70, 78, 83, 0.15),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(70, 78, 83, 0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      height: 100,
      margin: const EdgeInsets.only(bottom: 6, top: 6),
      child: Row(children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Image.asset(
            room.roomIcon,
            fit: BoxFit.fill,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 11),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                room.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight:
                      ChatUIKitTheme.of(context).font.titleMedium.fontWeight,
                  fontSize:
                      ChatUIKitTheme.of(context).font.titleMedium.fontSize,
                  color: ChatUIKitTheme.of(context).color.isDark
                      ? ChatUIKitTheme.of(context).color.neutralColor98
                      : ChatUIKitTheme.of(context).color.neutralColor1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(room.ownerAvatar),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    room.ownerNickname,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight:
                          ChatUIKitTheme.of(context).font.bodySmall.fontWeight,
                      fontSize:
                          ChatUIKitTheme.of(context).font.bodySmall.fontSize,
                      color: ChatUIKitTheme.of(context).color.isDark
                          ? ChatUIKitTheme.of(context).color.neutralColor7
                          : ChatUIKitTheme.of(context).color.neutralColor5,
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ]),
    );

    content = Stack(
      children: [
        content,
        Positioned(
          right: 12,
          bottom: 24,
          width: 55,
          height: 24,
          child: Container(
            decoration: BoxDecoration(
              color: ChatUIKitTheme.of(context).color.isDark
                  ? ChatUIKitTheme.of(context).color.neutralColor3
                  : ChatUIKitTheme.of(context).color.neutralColor9,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                DemoLocal.enter.getString(context),
                style: TextStyle(
                  fontSize: ChatUIKitTheme.of(context).font.labelSmall.fontSize,
                  fontWeight:
                      ChatUIKitTheme.of(context).font.labelSmall.fontWeight,
                  color: ChatUIKitTheme.of(context).color.isDark
                      ? ChatUIKitTheme.of(context).color.neutralColor98
                      : ChatUIKitTheme.of(context).color.neutralColor1,
                ),
              ),
            ),
          ),
        )
      ],
    );

    content = InkWell(
      onTap: () {
        onJoinTap.call();
      },
      child: content,
    );

    return content;
  }
}
