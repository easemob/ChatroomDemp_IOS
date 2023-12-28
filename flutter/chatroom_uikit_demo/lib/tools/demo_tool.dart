class DemoTools {
  static String appInfo = 'Powered by Easemob';
  static String roomIcon(String roomId) {
    return 'assets/images/cover${int.tryParse(roomId[roomId.length - 1])}.png';
  }

  static String easemobIcon = 'assets/images/cover_easemob.png';
}
