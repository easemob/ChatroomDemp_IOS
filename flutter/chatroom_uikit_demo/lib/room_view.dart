import 'dart:convert';

import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:chatroom_uikit_demo/local.dart';
import 'package:chatroom_uikit_demo/model/room.dart';
import 'package:chatroom_uikit_demo/tools/server_tool.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:video_player/video_player.dart';

class RoomView extends StatefulWidget {
  const RoomView(this.room, {this.languageCode, super.key});
  final Room room;
  final LanguageCode? languageCode;

  @override
  State<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView>
    with ChatroomResponse, ChatroomEventResponse {
  bool canShowDialog = true;

  late final ChatroomController controller;
  late VideoPlayerController _videoPlayerController;
  DefaultReportController? reportController;
  @override
  void initState() {
    super.initState();

    ChatroomUIKitClient.instance.roomService.bindResponse(this);
    ChatroomUIKitClient.instance.bindRoomEventResponse(this);
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/video1.mp4');

    controller = ChatroomController(
      roomId: widget.room.id,
      ownerId: widget.room.ownerId,
      giftControllers: () async {
        List<DefaultGiftPageController> service = [];

        String loadString = widget.languageCode == LanguageCode.zh
            ? 'assets/data/Gifts_cn.json'
            : 'assets/data/Gifts_en.json';
        final value = await rootBundle.loadString(loadString);
        Map<String, dynamic> map = json.decode(value);
        for (var element in map.keys.toList()) {
          service.add(
            DefaultGiftPageController(
              title: element,
              gifts: () {
                List<GiftEntityProtocol> list = [];
                map[element].forEach((element) {
                  GiftEntityProtocol? gift = ChatroomUIKitClient
                      .instance.giftService
                      .giftFromJson(element);
                  if (gift != null) {
                    list.add(gift);
                  }
                });
                return list;
              }(),
            ),
          );
        }
        return service;
      }(),
    );
  }

  Future<bool> started() async {
    if (_videoPlayerController.value.isPlaying) {
      return true;
    }

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ChatRoomUIKit(
      controller: controller,
      child: (context) {
        return Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).viewInsets.top + 10,
              height: 20,
              left: 20,
              right: 20,
              child: ChatroomGlobalBroadcastView(
                icon: Image.asset('assets/images/speaker.png'),
              ),
            ),
            const Positioned(
              left: 16,
              right: 100,
              height: 84,
              bottom: 300,
              child: ChatroomGiftMessageListView(),
            ),
            const Positioned(
              left: 16,
              right: 78,
              height: 204,
              bottom: 90,
              child: ChatroomMessageListView(),
            )
          ],
        );
      },
      inputBar: ChatInputBar(
        actions: [
          InkWell(
            onTap: () => controller.showGiftSelectPages(),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Image.asset('assets/images/send_gift.png'),
            ),
          ),
        ],
      ),
    );

    bool isDark = ChatUIKitTheme.of(context).color.isDark;

    content = Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.maybePop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 15,
                color: isDark
                    ? ChatUIKitTheme.of(context).color.neutralColor100
                    : ChatUIKitTheme.of(context).color.neutralColor98,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 0,
              child: Container(
                height: 38,
                padding: const EdgeInsets.fromLTRB(2, 2, 16, 2),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromRGBO(0, 0, 0, 0.2)
                      : const Color.fromRGBO(255, 255, 255, 0.1),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18)),
                      child: ChatImageLoader.networkImage(
                        image: widget.room.ownerAvatar,
                        placeholderWidget: ChatImageLoader.defaultAvatar(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: Text(
                                    widget.room.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: Text(
                                    widget.room.ownerNickname,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.8)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
            InkWell(
              onTap: () {
                controller.showParticipantPages();
              },
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark
                      ? const Color.fromRGBO(0, 0, 0, 0.2)
                      : const Color.fromRGBO(255, 255, 255, 0.1),
                ),
                width: 32,
                height: 32,
                padding: const EdgeInsets.all(8),
                child: Image.asset('assets/images/person.png'),
              ),
            ),
          ],
        ),
      ),
      body: content,
    );

    content = WillPopScope(
      child: content,
      onWillPop: () async {
        controller.hiddenInputBar();
        final ret = await leaveRoom();
        canShowDialog = !ret;
        return ret;
      },
    );

    content = Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(() {
                return isDark
                    ? 'assets/images/dark_bg.png'
                    : 'assets/images/light_bg.png';
              }()),
              fit: BoxFit.fill,
            ),
          ),
          child: FutureBuilder<bool>(
            future: started(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data ?? false) {
                return SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: SizedBox(
                      width: _videoPlayerController.value.size.width,
                      height: _videoPlayerController.value.size.height,
                      child: VideoPlayer(
                        _videoPlayerController,
                        key: UniqueKey(),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
        content,
      ],
    );

    content = GestureDetector(
      onTap: () {
        controller.hiddenInputBar();
      },
      child: content,
    );

    return content;
  }

  Future<bool> leaveRoom() async {
    bool ret = await showChatDialog(
          context,
          title: DemoLocal.leaveRoom.getString(context),
          items: [
            ChatDialogItem.cancel(onTap: () async {
              Navigator.of(context).pop(false);
            }),
            ChatDialogItem.confirm(onTap: () async {
              Navigator.of(context).pop(true);
            })
          ],
        ) ??
        false;
    if (!ret) return ret;
    try {
      if (controller.isOwner()) {
        await ServerTools.destroyRoom(widget.room);
        // await ChatroomUIKitClient.instance.chatroomOperating(
        //   roomId: widget.room.id,
        //   type: ChatroomOperationType.destroyed,
        // );
      } else {
        await ChatroomUIKitClient.instance.chatroomOperating(
          roomId: widget.room.id,
          type: ChatroomOperationType.leave,
        );
      }
      await _videoPlayerController.pause();

      return true;
    } catch (e) {
      // ignore: use_build_context_synchronously
      vLog(e.toString());
      // EasyLoading.showError(DemoLocal.leaveFailed.getString(context));
      return true;
    }
  }

  @override
  void onUserMuted(String roomId, List<String> userIds) {
    if (roomId == widget.room.id &&
        userIds.contains(Client.getInstance.currentUserId)) {
      EasyLoading.showInfo(DemoLocal.beMuted.getString(context));
    }
  }

  @override
  void onUserUnmuted(String roomId, List<String> userIds) {
    if (roomId == widget.room.id &&
        userIds.contains(Client.getInstance.currentUserId)) {
      EasyLoading.showInfo(DemoLocal.beUnmuted.getString(context));
    }
  }

  @override
  void onUserBeKicked(String roomId, ChatroomBeKickedReason reason) async {
    if (mounted && canShowDialog) {
      showChatDialog(
        context,
        title: reason == ChatroomBeKickedReason.destroyed
            ? DemoLocal.beDestroy.getString(context)
            : DemoLocal.beRemove.getString(context),
        items: [
          ChatDialogItem.confirm(
            onTap: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      ).then((value) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void onEventResultChanged(
      String roomId, RoomEventsType type, ChatError? error) async {
    if (roomId == widget.room.id) {
      if (type == RoomEventsType.sendMessage) {
        if (error != null) {
          if (error.code == 215) {
            EasyLoading.showError(DemoLocal.sendErrWhenMute.getString(context));
          } else {
            EasyLoading.showError(error.description);
          }
        }
      }

      if (type == RoomEventsType.mute) {
        if (error == null) {
          EasyLoading.showSuccess(DemoLocal.muteSuccess.getString(context));
        } else {
          EasyLoading.showError(DemoLocal.muteFailed.getString(context));
        }
      }
      if (type == RoomEventsType.unmute) {
        if (error == null) {
          EasyLoading.showSuccess(DemoLocal.unmuteSuccess.getString(context));
        } else {
          EasyLoading.showError(DemoLocal.unmuteFailed.getString(context));
        }
      }
      if (type == RoomEventsType.kick) {
        if (error == null) {
          EasyLoading.showSuccess(DemoLocal.kickSuccess.getString(context));
        } else {
          EasyLoading.showError(DemoLocal.kickFailed.getString(context));
        }
      }

      if (type == RoomEventsType.recall && error != null) {
        EasyLoading.showError(DemoLocal.recallFailed.getString(context));
      }

      if (type == RoomEventsType.report) {
        if (error == null) {
          EasyLoading.showSuccess(DemoLocal.reportSuccess.getString(context));
        } else {
          EasyLoading.showError(DemoLocal.reportFailed.getString(context));
        }
      }

      if (type == RoomEventsType.join && error != null) {
        Future.delayed(const Duration(seconds: 1), () {
          showChatDialog(
            context,
            title: DemoLocal.joinFailed.getString(context),
            subTitle: error.description,
            items: [
              ChatDialogItem.confirm(
                onTap: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ).then((value) {
            Navigator.of(context).pop();
          });
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _videoPlayerController.dispose();
    ChatroomUIKitClient.instance.roomService.unbindResponse(this);
    ChatroomUIKitClient.instance.unbindRoomEventResponse(this);
    super.dispose();
  }
}
