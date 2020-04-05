import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:tidy/utils/date_and_time.dart';

part 'chore_store.g.dart';

class Flatmate {
  Flatmate({this.name});

  String name;
  List<ChoreStore> choresAssigned;
  List<ChoreStore> choreHistory;
}

class ChoreStore = _ChoreStore with _$ChoreStore;

abstract class _ChoreStore with Store {
  @observable
  String title;

  @observable
  DateAndTime nextDue;

  @observable
  String notes;

  @observable
  bool resetTimerAfterChoreCompleted = false;

  _ChoreStore(
      {this.resetTimerAfterChoreCompleted = false, nextDueDate, nextDueTime})
      : this.nextDue = DateAndTime(nextDueDate);

  _ChoreStore.demo([DateTime nextDueDate]) {
    title = WordPair.random().asCamelCase;
    this.nextDue = DateAndTime(nextDueDate);
  }

  _ChoreStore.copy(ChoreStore original) {
    this.title = original.title;
    this.nextDue = DateAndTime(original.nextDue.dateTime);
    this.notes = original.notes;
    this.resetTimerAfterChoreCompleted = original.resetTimerAfterChoreCompleted;
  }

  @action
  void setTitle(title) {
    this.title = title;
  }

  @action
  void setNextDueDate(DateTime date) {
    // TODO: may not be observable
    nextDue.dateWithoutTime = date;
  }

  @action
  void setNextDueTime(TimeOfDay time) {
    this.nextDue.timeWithoutDate = time;
  }

  DateAndTime get nextDueDate {
    return this.nextDue;
  }
}
