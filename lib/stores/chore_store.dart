import 'package:english_words/english_words.dart';
import 'package:mobx/mobx.dart';
import 'package:tidy/stores/chores_list_store.dart';

import 'date_and_time.dart';

part 'chore_store.g.dart';

class ChoreStore = _ChoreStore with _$ChoreStore;

class Schedule {
  int notifiedCount = 0;
}

abstract class _ChoreStore with Store implements Disposable, Restartable {
  @observable
  String title;

  @observable
  DateAndTime nextDue;

  @observable
  String notes;

  _ChoreStore({nextDueDate}) : nextDue = DateAndTime(nextDueDate);

  _ChoreStore.demo([DateTime nextDueDate]) {
    title = WordPair.random().asCamelCase;
    nextDue = DateAndTime(nextDueDate);
  }

  _ChoreStore.copy(ChoreStore original) {
    title = original.title;
    nextDue = DateAndTime(original.nextDue.dateTime);
    notes = original.notes;
  }

  @override
  void dispose() {
    nextDue.dispose();
  }

  @override
  void restart() {
    nextDue.restart();
  }
}
