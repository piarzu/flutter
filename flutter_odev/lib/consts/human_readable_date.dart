import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String humanReadableDate(DateTime date) {
  initializeDateFormatting('tr', null).then((_) async {});
  return DateFormat.yMMMMEEEEd('tr').format(date).toString();
}
