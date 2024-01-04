import 'package:intl/intl.dart';

String ConvertLastSeen(int timestamp) {
  DateTime lastSeenDate =
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true)
          .toLocal();
  DateTime curDate = DateTime.now();

  if (curDate.day == lastSeenDate.day) {
    return 'at ' + DateFormat('HH:mm').format(lastSeenDate);
  } else if (curDate.day - lastSeenDate.day == 1) {
    return 'yesterday at ' + DateFormat('HH:mm').format(lastSeenDate);
  } else if (curDate.day - lastSeenDate.day < 7) {
    return DateFormat('E').format(lastSeenDate) +
        ' at ' +
        DateFormat('HH:mm').format(lastSeenDate);
  } else if (curDate.day - lastSeenDate.day >= 7 &&
      curDate.year == lastSeenDate.year) {
    return DateFormat('MMMd').format(lastSeenDate) +
        ' at ' +
        DateFormat('HH:mm').format(lastSeenDate);
  } else {
    return DateFormat('yMMMd').format(lastSeenDate);
  }
}

String ConvertMsgDate(int timestamp) {
  DateTime msgDate =
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true)
          .toLocal();

  return DateFormat('HH:mm').format(msgDate);
}
