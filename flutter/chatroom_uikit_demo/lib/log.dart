import 'package:flutter/foundation.dart';

vLog(String str) {
  // 判断是否是debug状态，如果是，调用输入日志；
  if (!kReleaseMode) {
    debugPrint('debug: $str');
  }
}
