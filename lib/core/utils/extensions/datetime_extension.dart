import 'package:intl/intl.dart';

extension DateTimeToString on DateTime {
  String toStringFormatted(String format) {
    final formatter = DateFormat(format);
    return formatter.format(this);
  }
}
