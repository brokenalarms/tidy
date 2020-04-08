import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mobx/mobx.dart';
import 'package:tidy/services/notification_service.dart';

import 'chores_list_store.dart';

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

abstract class _DateAndTime with Store implements Disposable, Restartable {
  @observable
  Jiffy _date;

  @observable
  bool isDue = false;

  final String _choreName;

  StreamSubscription<bool> dueDateSubscription;

  @override
  void dispose() {
    if (dueDateSubscription != null) {
      dueDateSubscription.cancel();
    }
  }

  /// Defaults to [DateTime.now] if date not provided
  _DateAndTime(DateTime date, this._choreName) {
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
    restart();
  }

  @override
  void restart() {
    if (dueDateSubscription != null) {
      dueDateSubscription.cancel();
    }

    bool isDue() => _date.isSameOrBefore(Jiffy());

    if (isDue()) {
      _setOverdueAndNotify();
    } else {
      final stream =
          Stream.periodic(const Duration(seconds: 3), (count) => isDue());
      dueDateSubscription = stream.listen((isOverdue) {
        if (isOverdue) {
          dueDateSubscription.cancel();
          _setOverdueAndNotify();
        }
      });
    }
  }

  void _setOverdueAndNotify() {
    isDue = true;
    NotificationService().pushOverdueDateNotification(date, _choreName);
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
