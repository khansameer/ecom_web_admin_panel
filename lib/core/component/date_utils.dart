import 'package:intl/intl.dart';

String formatDateTime(String isoString) {
  try {
    DateTime dateTime = DateTime.parse(isoString).toLocal(); // converts to local time
    return DateFormat('EEEE \'at\' hh:mm a').format(dateTime);
  } catch (e) {
    return ''; // return empty string if parsing fails
  }
}
