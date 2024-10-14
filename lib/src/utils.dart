import 'package:flutter/foundation.dart';

class JMDictLogUtils {
  JMDictLogUtils._();

  static const _PREFIX = "[JMDict]:";

  static void log(
    String? message,
  ) {
    print(
      "$_PREFIX $message",
    );
  }

  static void debugLog(
    String? message,
  ) {
    debugPrint(
      "$_PREFIX $message",
    );
  }
}
