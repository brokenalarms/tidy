import 'package:english_words/english_words.dart';
import 'package:mobx/mobx.dart';

import 'date_and_time.dart';

part 'chore_store.g.dart';

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
      : nextDue = DateAndTime(nextDueDate);

  _ChoreStore.demo([DateTime nextDueDate]) {
    title = WordPair.random().asCamelCase;
    nextDue = DateAndTime(nextDueDate);
  }

  _ChoreStore.copy(ChoreStore original) {
    title = original.title;
    nextDue = DateAndTime(original.nextDue.dateTime);
    notes = original.notes;
    resetTimerAfterChoreCompleted = original.resetTimerAfterChoreCompleted;
  }
}
