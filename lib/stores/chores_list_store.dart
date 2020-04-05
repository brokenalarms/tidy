import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import 'chore_store.dart';

part 'chores_list_store.g.dart';

class ChoresListStore = _ChoresListStore with _$ChoresListStore;

abstract class _ChoresListStore with Store {
  @observable
  ObservableList<ChoreStore> chores = ObservableList<ChoreStore>.of([
    ChoreStore.demo(DateTime.now().subtract(Duration(days: 5))),
    ChoreStore.demo(DateTime.now()),
    ChoreStore.demo(DateTime.now().add(Duration(days: 5)))
  ]);

  @action
  void insertChoreInSortedTimeOrder(ChoreStore chore) {
    // insert new chore before the next due one
    final nextLaterDueDate = chores.indexWhere((ChoreStore element) =>
        chore.nextDue.date.isSameOrBefore(element.nextDue.date));
    final insertPosition = nextLaterDueDate > 0 ? nextLaterDueDate : 0;
    chores.insert(insertPosition, chore);
  }

  @action
  void replaceChore(
      {@required ChoreStore originalChore, @required ChoreStore newChore}) {
    final oldIndex = chores.indexOf(originalChore);
    chores.remove(originalChore);
    chores.insert(oldIndex, newChore);
  }
}
