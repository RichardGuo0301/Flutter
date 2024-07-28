import 'package:logger/logger.dart';
import 'package:flutter/material.dart';

class LoggerUtils {
  static final _logger = Logger(
    printer: PrettyPrinter(),
  );

  static void print(Object? msg, {Object? tag}) {
    if (tag == null) {
      debugPrint("todo$tag:$msg");
    } else {
      debugPrint("todo$tag:$msg");
    }
  }

  static void d(dynamic msg) {
    _logger.d(msg);
  }

  static void e(dynamic msg) {
    _logger.e(msg);
  }

  static void i(dynamic msg) {
    _logger.i(msg);
  }
}
