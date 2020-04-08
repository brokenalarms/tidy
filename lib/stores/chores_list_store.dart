import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import 'chore_store.dart';

part 'chores_list_store.g.dart';

class ChoresListStore = _ChoresListStore with _$ChoresListStore;

mixin Disposable {
  void dispose() {}
}

mixin Restartable {
  void restart() {}
}

abstract class _ChoresListStore with Store implements Disposable, Restartable {
  @observable
  ObservableList<ChoreStore> chores = ObservableList<ChoreStore>.of([
    ChoreStore.demo(DateTime.now().subtract(Duration(days: 5))),
    ChoreStore.demo(DateTime.now()),
    ChoreStore.demo(DateTime.now().add(Duration(days: 5)))
  ]);

  @action
  void insertChoreInSortedTimeOrder(ChoreStore chore) {
    // insert new chore before the next due one
    final nextLaterDueDate = chores.indexWhere(
        (element) => chore.nextDue.date.isSameOrBefore(element.nextDue.date));
    final insertPosition = nextLaterDueDate > 0 ? nextLaterDueDate : 0;
    chores.insert(insertPosition, chore);
  }

  @action
  void replaceChoreInSortedTimeOrder(
      {@required ChoreStore originalChore, @required ChoreStore newChore}) {
    final oldIndex = chores.indexOf(originalChore);
    chores.remove(originalChore);
    if (newChore.nextDue.date.isSame(originalChore.nextDue.date)) {
      chores.insert(oldIndex, newChore);
    } else {
      insertChoreInSortedTimeOrder(newChore);
    }
  }

  @override
  void dispose() {
    for (var chore in chores) {
      chore.dispose();
    }
  }

  void restart() {
    for (var chore in chores) {
      chore.restart();
    }
  }
}
