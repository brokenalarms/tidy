import 'dart:core';

import 'package:mobx/mobx.dart';

import 'chore_store.dart';

part 'chores_list_store.g.dart';

class ChoresListStore = _ChoresListStore with _$ChoresListStore;

abstract class _ChoresListStore with Store {
  @observable
  ObservableList<Chore> chores = ObservableList<Chore>.of([
    Chore.demo(DateTime.now().subtract(Duration(days: 5))),
    Chore.demo(DateTime.now()),
    Chore.demo(DateTime.now().add(Duration(days: 5)))
  ]);

  @action
  void addChore(Chore chore) {
    // insert new chore before the next due one
    int nextLaterDueDate = chores.indexWhere((Chore element) =>
        chore.nextDue.date.isSameOrBefore(element.nextDue.date));
    int insertPosition = nextLaterDueDate > 0 ? nextLaterDueDate : 0;
    chores.insert(insertPosition, chore);
  }
}
