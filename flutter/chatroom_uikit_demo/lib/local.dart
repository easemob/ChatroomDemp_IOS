import 'package:chatroom_uikit/chatroom_uikit.dart';

mixin DemoLocal on ChatroomLocal {
  static const String channelList = 'channelList';
  static const String channelListName = "channelListName";
  static const String enter = "enter";
  static const String create = "create";
  static const String leaveRoom = "leaveRoom";
  static const String leaveFailed = "leaveFailed";
  static const String joinFailed = "joinFailed";
  static const String beMuted = "beMuted";
  static const String beUnmuted = "beUnmuted";
  static const String beRemove = "beRemove";
  static const String beDestroy = "beDestroy";
  static const String muteSuccess = "muteSuccess";
  static const String unmuteSuccess = "unmuteSuccess";
  static const String muteFailed = "muteFailed";
  static const String unmuteFailed = "unmuteFailed";
  static const String kickSuccess = "kickSuccess";
  static const String kickFailed = "kickFailed";
  static const String recallFailed = 'recallFailed';
  static const String reportSuccess = "reportSuccess";
  static const String reportFailed = "reportFailed";
  static const String loadFailed = "loadFailed";
  static const String sendErrWhenMute = 'sendErrWhenMute';

  static const Map<String, dynamic> zh = {
    channelList: '聊天室',
    channelListName: "的聊天室",
    enter: "进入",
    create: '创建',
    leaveRoom: "离开聊天室?",
    leaveFailed: "离开聊天室失败",
    joinFailed: "加入聊天室失败",
    beMuted: "您已被禁言",
    beUnmuted: "您已被解除禁言",
    beRemove: "您已被移出聊天室",
    muteSuccess: "禁言成功",
    unmuteSuccess: "解除禁言成功",
    muteFailed: "禁言失败",
    unmuteFailed: "解除禁言失败",
    kickSuccess: "移出聊天室成功",
    kickFailed: "移出聊天室失败",
    recallFailed: "删除失败",
    reportSuccess: "举报已提交",
    reportFailed: "举报失败",
    beDestroy: "聊天室已被销毁",
    loadFailed: "获取列表失败",
    sendErrWhenMute: '您已被禁言，无法发送消息',
  };
  static const Map<String, dynamic> en = {
    channelList: 'Channel List',
    channelListName: "'s Channel",
    enter: "Enter",
    create: 'Create',
    leaveRoom: "Want to end live streaming?",
    leaveFailed: "Leave channel failed",
    joinFailed: "Join channel failed",
    beMuted: "You have been muted",
    beUnmuted: "You have been unmuted",
    beRemove: "You have been removed",
    muteSuccess: "Mute success",
    unmuteSuccess: "Unmute success",
    muteFailed: "Mute failed",
    unmuteFailed: "Unmute failed",
    kickSuccess: "Kick success",
    kickFailed: "Kick failed",
    recallFailed: "Delete failed",
    reportSuccess: "Report submitted",
    reportFailed: "Report failed",
    beDestroy: "Room has been destroyed",
    loadFailed: "Load failed",
    sendErrWhenMute: 'You have been muted, and are not unable to send message',
  };
}
