import 'package:shamsi_date/shamsi_date.dart';

enum DateTimeType {
  date,
  time,
  dateTime,
}

dateTimeToJalali(DateTime dateTime, {DateTimeType type = DateTimeType.dateTime}) {
  final jalali = dateTime.toLocal().toJalali();

  switch (type) {
    case DateTimeType.date:
      return '${jalali.year}/${jalali.month}/${jalali.day}';
    case DateTimeType.time:
      return '${dateTime.hour}:${dateTime.minute}';
    case DateTimeType.dateTime:
      return '${dateTime.hour}:${dateTime.minute} ${jalali.year}/${jalali.month}/${jalali.day}';
  }
}
