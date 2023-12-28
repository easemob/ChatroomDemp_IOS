class Room {
  Room.fromJson(
    Map<String, dynamic> json, {
    required this.roomIcon,
  }) {
    id = json['id']!;
    name = json['name']!;
    ownerAvatar = json['iconKey']!;
    desc = json['description']!;
    ownerNickname = json['nickname']!;
    ownerId = json['owner']!;
  }

  late final String id;
  late final String name;
  late final String ownerAvatar;
  late final String desc;
  late final String ownerNickname;
  late final String ownerId;
  late final String roomIcon;
}
