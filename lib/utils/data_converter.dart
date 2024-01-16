import 'package:intl/intl.dart';

String ConvertLastSeen(int lastSeenTS) {
  DateTime lastSeenDate = DateTime.fromMillisecondsSinceEpoch(lastSeenTS * 1000, isUtc: true).toLocal();
  int dayDifference = (DateTime.now().millisecondsSinceEpoch ~/ 1000 - lastSeenTS) ~/ 86400;

  if (dayDifference == 0) {
    return 'at ' + DateFormat('HH:mm').format(lastSeenDate);
  } 
  else if (dayDifference == 1) {
    return 'yesterday at ' + DateFormat('HH:mm').format(lastSeenDate);
  } 
  else if (dayDifference < 7) {
    return DateFormat('E').format(lastSeenDate) +
        ' at ' +
        DateFormat('HH:mm').format(lastSeenDate);
  }
  else if (dayDifference < 365) {
    return DateFormat('MMMd').format(lastSeenDate) +
        ' at ' +
        DateFormat('HH:mm').format(lastSeenDate);
  } 
  else {
    return DateFormat('yMMMd').format(lastSeenDate) +
        ' at ' +
        DateFormat('HH:mm').format(lastSeenDate);
  }
}

String ConvertMsgDate(int timestamp) {
  DateTime msgDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true).toLocal();
  return DateFormat('HH:mm').format(msgDate);
}
