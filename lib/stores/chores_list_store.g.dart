// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chores_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChoresListStore on _ChoresListStore, Store {
  final _$choresAtom = Atom(name: '_ChoresListStore.chores');

  @override
  ObservableList<ChoreStore> get chores {
    _$choresAtom.context.enforceReadPolicy(_$choresAtom);
    _$choresAtom.reportObserved();
    return super.chores;
  }

  @override
  set chores(ObservableList<ChoreStore> value) {
    _$choresAtom.context.conditionallyRunInAction(() {
      super.chores = value;
      _$choresAtom.reportChanged();
    }, _$choresAtom, name: '${_$choresAtom.name}_set');
  }

  final _$_ChoresListStoreActionController =
      ActionController(name: '_ChoresListStore');

  @override
  void insertChoreInSortedTimeOrder(ChoreStore chore) {
    final _$actionInfo = _$_ChoresListStoreActionController.startAction();
    try {
      return super.insertChoreInSortedTimeOrder(chore);
    } finally {
      _$_ChoresListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void replaceChoreInSortedTimeOrder(
      {@required ChoreStore originalChore, @required ChoreStore newChore}) {
    final _$actionInfo = _$_ChoresListStoreActionController.startAction();
    try {
      return super.replaceChoreInSortedTimeOrder(
          originalChore: originalChore, newChore: newChore);
    } finally {
      _$_ChoresListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = 'chores: ${chores.toString()}';
    return '{$string}';
  }
}
