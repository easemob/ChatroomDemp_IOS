

import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class UserTool {
  static String avatarBaseUrl =
      'https://a1.easemob.com/easemob/chatroom-uikit/chatfiles/';

  static UserTool? _instance;
  static UserTool get instance => _instance ??= UserTool();

  late SharedPreferences preferences;
  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  String? _token;

  void saveToken(String token) {
    _token = token;
  }

  String get token {
    return _token ?? '';
  }

  String get userId {
    String? userId = preferences.getString("userId");
    if (userId == null) {
      userId = RandomTool.randomUserId;
      preferences.setString("userId", userId);
    }
    return userId;
  }

  String get nickname {
    String? nickname = preferences.getString("nickname");
    if (nickname == null) {
      nickname = RandomTool.randomNickname;
      preferences.setString("nickname", nickname);
    }
    return nickname;
  }

  String get avatar {
    String? avatar = preferences.getString("avatar");
    if (avatar == null) {
      avatar = RandomTool.randomAvatar;
      preferences.setString("avatar", avatar);
    }
    return avatar;
  }
}

class RandomTool {
  static String get randomUserId {
    String alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';
    String left = '';
    for (int i = 0; i < 16; i++) {
      left += alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  static String get randomAvatar {
    return UserTool.avatarBaseUrl + avatars[Random().nextInt(avatars.length)];
  }

  static String get randomNickname {
    return allNicknames[Random().nextInt(allNicknames.length)];
  }
}

List<String> avatars = [
  "fc14ab00-79f7-11ee-93f4-618a64affe88",
  "7345d230-79f8-11ee-a0d1-5f74d88fa308",
  "7d239bc0-79f8-11ee-92b9-770b4e48f8fc",
  "8e208410-79f8-11ee-b8e3-232a619cf52c",
  "99296020-79f8-11ee-8475-c7a7b59db79f",
  "a27bd9a0-79f8-11ee-8f83-551faec94303",
  "ae308610-79f8-11ee-a6c9-5379b9a705a1",
  "b837f7b0-79f8-11ee-b817-23850e48ca47",
  "c0d52af0-79f8-11ee-a6ed-6fc3a8bc6581",
  "c8354a50-79f8-11ee-97b9-0d7ccd9e7127",
  "d2b176c0-79f8-11ee-a291-ed6692473990",
  "de41f960-79f8-11ee-83cd-db9df9bad9bf",
  "e7517670-79f8-11ee-a783-c1d7a432abb7",
  "ef5724a0-79f8-11ee-8290-eb9f9e9c2195",
  "f78da6d0-79f8-11ee-b3b8-3b446ebd1fbb",
  "ffb9efd0-79f8-11ee-9356-ef4cfe1f2af8",
  "07d98ea0-79f9-11ee-8047-d35f49238254",
  "0fa12260-79f9-11ee-890f-67aacef20d88",
  "16bc4980-79f9-11ee-b272-3568dd301252",
  "208dde10-79f9-11ee-b9ea-5bff48db7458",
  "298c9240-79f9-11ee-b8b6-f16f0b5f700a",
];

List<String> allNicknames = [
  '左冷禅',
  '朱聪',
  '拜月',
  '周伯通',
  '钟阿四',
  '郑长老',
  '张五侠',
  '张三丰',
  '莫大',
  '张翠山',
  '岳不群',
  '段王爷',
  '袁冠南',
  '袁承志',
  '岳灵珊',
  '余观主',
  '殷天正',
  '尹克西',
  '仪琳',
  '耶律楚材',
  '杨铁心',
  '杨过',
  '杨成协',
  '玄慈大师',
  '虚竹',
  '许仕枫',
  '三少爷',
  '谢逊',
  '逍遥子',
  '小龙女',
  '向问天',
  '张君宝',
  '香香公主',
  '穆人王',
  '夏雪宜',
  '夏冰',
  '无崖子',
  '殷梨亭',
  '文泰来',
  '韦小宝',
  '柯镇恶',
  '王处一',
  '铁心兰',
  '田归农',
  '田伯光',
  '宋青书',
  '双儿',
  '神雕',
  '少庄主',
  '无双',
  '破天',
  '扫地僧',
  '蓉儿',
  '任盈盈',
  '任我行',
  '裘千仞',
  '丘处机',
  '欧阳克',
  '欧阳峰',
  '孙剑',
  '一灯',
  '潇湘子',
  '木婉清',
  '慕容复',
  '慕容博',
  '穆念慈',
  '苗人凤',
  '卓不凡',
  '李秋水',
  '孟铮',
  '孟英霆',
  '孟星魂',
  '孟天明',
  '王语嫣',
  '孟清泉',
  '萧十一郎',
  '梦郎',
  '梦姑',
  '杨开泰',
  '逍遥王',
  '沈浪',
  '梅超风',
  '陈近南',
  '陆无双',
  '鹿清笃',
  '陆乘风',
  '龙儿',
  '龙岛主',
  '柳无眉',
  '柳绘心',
  '令狐冲',
  '林平之',
  '梁子翁',
  '练霓裳',
  '李逍遥',
  '慕容龙城',
  '李萍',
  '老毒物',
  '蓝凤凰',
  '昨夜东风',
  '金轮法王',
  '霍都',
  '黄药师',
  '黄头陀',
  '黄裳',
  '黄衫女子',
  '黄蓉',
  '黄梅',
  '黄老邪',
  '画眉',
  '胡青牛',
  '李莫愁',
  '红袖',
  '洪七公',
  '洪凌波',
  '郭破虏',
  '郭靖',
  '郭芙',
  '归辛树',
  '格老子',
  '葛光佩',
  '天山童姥',
  '风清扬',
  '风良',
  '风波恶',
  '范遥',
  '杨逍',
  '铁木真',
  '阿紫',
  '阿朱',
  '阿柯',
  '阿碧',
  '段正淳',
  '段誉',
  '段延庆',
  '小鱼儿',
  '独孤求败',
  '独孤剑',
  '东方不败',
  '狄云',
  '刀白凤',
  '江枫',
  '程英',
  '程瑶迦',
  '周芷若',
  '傅红雪',
  '白展堂',
  '郭芙蓉',
  '陈家洛',
  '花无缺',
];
