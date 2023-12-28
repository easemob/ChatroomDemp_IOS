import 'package:chatroom_uikit/chatroom_uikit.dart';

class User extends UserEntity {
  User(
    super.userId, {
    super.avatarURL,
    super.gender = 1,
    super.identify,
    super.nickname,
  });
}
