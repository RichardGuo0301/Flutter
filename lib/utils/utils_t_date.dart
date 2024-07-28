import 'package:flutter_todo_list/utils/utils_logger.dart';
import 'package:intl/intl.dart';

class TDateUtils {
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(dateTime);
    return formatted;
  }

  static DateTime? strToDateTime(String? str) {
    if (str == null || str.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(str);
    } catch (e) {
      LoggerUtils.e(e);
    }
    return null;
  }
}
