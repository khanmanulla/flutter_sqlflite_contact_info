import 'package:intl/intl.dart';

class FormFormatter {
  static String formatDate(String dateStr, {String format = 'dd MMM yyyy'}) {
    final DateTime date = DateTime.parse(dateStr);
    final DateFormat formatter = DateFormat(format);
    return formatter.format(date);
  }
}
