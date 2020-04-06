import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mobx/mobx.dart';

part 'date_and_time.g.dart';

Future<TimeOfDay> selectTime(BuildContext context,
    {TimeOfDay initialTime}) async {
  final selectedTime =
      await showTimePicker(context: context, initialTime: initialTime);

  return selectedTime ?? initialTime;
}

Future<DateTime> selectDate(BuildContext context,
    {DateTime initialDate}) async {
  final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: Jiffy().subtract(years: 1),
      lastDate: Jiffy().add(years: 10));
  return selectedDate ?? initialDate;
}

class DateAndTime = _DateAndTime with _$DateAndTime;

abstract class _DateAndTime with Store {
  @observable
  Jiffy _date;

  @observable
  bool isDue = false;

  StreamSubscription<bool> dueDateSubscription;

  /// Defaults to [DateTime.now] if date not provided
  _DateAndTime(DateTime date) {
    setDate(date);
  }

  /// Set date, preserving time info if not specified
  @action
  void setDatePreservingTime(DateTime newDate) {
    final time = TimeOfDay.fromDateTime(_date.dateTime);
    final date = DateTime(
        newDate.year, newDate.month, newDate.day, time.hour, time.minute);
    setDate(date);
  }

  setDate(DateTime date) {
    _date = Jiffy(date);
    _resetCheckForDateTimeElapsed();
  }

  void _resetCheckForDateTimeElapsed() {
    if (dueDateSubscription != null) {
      dueDateSubscription.cancel();
    }

    bool isDue() => _date.isSameOrBefore(DateTime.now());

    if (isDue()) {
      this.isDue = true;
    } else {
      final stream =
          Stream.periodic(const Duration(seconds: 3), (count) => isDue());
      dueDateSubscription = stream.listen((isOverdue) {
        if (isOverdue) {
          dueDateSubscription.cancel();
          this.isDue = true;
        }
      });
    }
  }

  @action
  void setTimePreservingDate(TimeOfDay time) {
    final date =
        DateTime(_date.year, _date.month, _date.date, time.hour, time.minute);
    setDate(date);
  }

  Jiffy get date {
    return _date;
  }

  DateTime get dateTime {
    return _date.dateTime;
  }

  TimeOfDay get time {
    return TimeOfDay(hour: _date.hour, minute: _date.minute);
  }

  String get dateText {
    return _date.yMMMMd;
  }

  String get timeText {
    return _date.jm;
  }
}
