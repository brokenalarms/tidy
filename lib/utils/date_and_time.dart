import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

Future<TimeOfDay> selectTime(BuildContext context,
    {TimeOfDay initialTime}) async {
  TimeOfDay selectedTime =
      await showTimePicker(context: context, initialTime: initialTime);

  return selectedTime ?? initialTime;
}

Future<DateTime> selectDate(BuildContext context,
    {DateTime initialDate}) async {
  final DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: Jiffy().subtract(years: 1),
      lastDate: Jiffy().add(years: 10));
  return selectedDate ?? initialDate;
}

DateTime _createDate({year, month, day, hour, minute}) =>
    DateTime(year, month, day, hour, minute);

/// Gets date with time added from midnight
/// returns date with time reset to midnight if time not provided.
DateTime _getDateWithTime(DateTime date, TimeOfDay time) =>
    DateTime(date.year, date.month, date.day, time.hour, time.minute);

TimeOfDay _getTimeFromDate(DateTime date) =>
    TimeOfDay(hour: date.hour, minute: date.minute);

class DateAndTime {
  Jiffy _date;

  /// Defaults to [DateTime.now] if date not provided
  DateAndTime(DateTime date) : this._date = Jiffy(date);

  Jiffy get date {
    return _date;
  }

  DateTime get dateTime {
    return _date.dateTime;
  }

  /// Set date, preserving time info if not specified
  set dateWithoutTime(DateTime newDate) {
    final TimeOfDay time = TimeOfDay.fromDateTime(_date.dateTime);
    final date = DateTime(
        newDate.year, newDate.month, newDate.day, time.hour, time.minute);
    _date = Jiffy(date);
  }

  set timeWithoutDate(TimeOfDay newTime) {
    final date = DateTime(
        _date.year, _date.month, _date.date, newTime.hour, newTime.minute);
    _date = Jiffy(date);
  }

  TimeOfDay get timeWithoutDate {
    return TimeOfDay(hour: _date.hour, minute: _date.minute);
  }

  String get dateText {
    return _date.yMMMMd;
  }

  String get timeText {
    return _date.jm;
  }
}
