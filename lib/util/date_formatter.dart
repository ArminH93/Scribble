import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String dateFormatted() {
  var now = DateTime.now();
  initializeDateFormatting("de_DE", null);

  var formatter = new DateFormat.yMd("de_DE");
  String formatted = formatter.format(now);

  return formatted;
}