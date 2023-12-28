import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:chatroom_uikit_demo/model/room.dart';
import 'package:chatroom_uikit_demo/model/user.dart';
import 'package:chatroom_uikit_demo/tools/demo_tool.dart';
import 'package:chatroom_uikit_demo/tools/user_tool.dart';
import 'package:dio/dio.dart';

class ServerTools {
  static String registerUserApi =
      'https://a1.easemob.com/internal/appserver/liverooms/user/login';

  static String createRoomApi =
      'https://a1.easemob.com/internal/appserver/liverooms/';

  static String getRoomListApi =
      'https://a1.easemob.com/internal/appserver/liverooms';

  static String destroyRoomApi =
      'https://a1.easemob.com/internal/appserver/liverooms/';

  static Future<String?> loginUser(
    String userId,
    User user,
  ) async {
    Response response = await Dio().post(registerUserApi, data: {
      'username': userId,
      'nickname': user.nickname,
      'icon_key': user.avatarURL,
    });

    if (response.statusCode == 200) {
      Map data = response.data;
      if (data.containsKey('access_token')) {
        String token = data['access_token'];
        return token;
      }
    }
    return null;
  }

  static Future<Room?> createRoom(String roomName, String owner) async {
    Options options = Options();
    options.headers = {
      "Authorization": 'Bearer ${UserTool.instance.token}',
    };
    Response response =
        await Dio().post(createRoomApi, options: options, data: {
      'name': roomName,
      'owner': owner,
    });

    Room? room;
    vLog(response.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      room = Room.fromJson(data, roomIcon: DemoTools.roomIcon(data["id"]));
    }
    return room;
  }

  static Future<List<Room>?> getRoomList() async {
    Options options = Options();
    options.headers = {
      "Authorization": 'Bearer ${UserTool.instance.token}',
    };
    Response response = await Dio().get(getRoomListApi, options: options);

    vLog(response.toString());
    if (response.statusCode == 200) {
      Map data = response.data;
      if (data.containsKey('entities')) {
        List rooms = data['entities'];
        return rooms.map((e) {
          return Room.fromJson(
            e,
            roomIcon: e == rooms.first
                ? DemoTools.easemobIcon
                : DemoTools.roomIcon(e["id"]),
          );
        }).toList();
      }
    }
    return null;
  }

  static Future<void> destroyRoom(Room room) async {
    Options options = Options();
    options.headers = {
      "Authorization": 'Bearer ${UserTool.instance.token}',
    };
    String api = destroyRoomApi + room.id;
    await Dio().delete(api, options: options);
  }
}
