// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChoreStore on _ChoreStore, Store {
  final _$titleAtom = Atom(name: '_ChoreStore.title');

  @override
  String get title {
    _$titleAtom.context.enforceReadPolicy(_$titleAtom);
    _$titleAtom.reportObserved();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.context.conditionallyRunInAction(() {
      super.title = value;
      _$titleAtom.reportChanged();
    }, _$titleAtom, name: '${_$titleAtom.name}_set');
  }

  final _$nextDueAtom = Atom(name: '_ChoreStore.nextDue');

  @override
  DateAndTime get nextDue {
    _$nextDueAtom.context.enforceReadPolicy(_$nextDueAtom);
    _$nextDueAtom.reportObserved();
    return super.nextDue;
  }

  @override
  set nextDue(DateAndTime value) {
    _$nextDueAtom.context.conditionallyRunInAction(() {
      super.nextDue = value;
      _$nextDueAtom.reportChanged();
    }, _$nextDueAtom, name: '${_$nextDueAtom.name}_set');
  }

  final _$notesAtom = Atom(name: '_ChoreStore.notes');

  @override
  String get notes {
    _$notesAtom.context.enforceReadPolicy(_$notesAtom);
    _$notesAtom.reportObserved();
    return super.notes;
  }

  @override
  set notes(String value) {
    _$notesAtom.context.conditionallyRunInAction(() {
      super.notes = value;
      _$notesAtom.reportChanged();
    }, _$notesAtom, name: '${_$notesAtom.name}_set');
  }

  final _$resetTimerAfterChoreCompletedAtom =
      Atom(name: '_ChoreStore.resetTimerAfterChoreCompleted');

  @override
  bool get resetTimerAfterChoreCompleted {
    _$resetTimerAfterChoreCompletedAtom.context
        .enforceReadPolicy(_$resetTimerAfterChoreCompletedAtom);
    _$resetTimerAfterChoreCompletedAtom.reportObserved();
    return super.resetTimerAfterChoreCompleted;
  }

  @override
  set resetTimerAfterChoreCompleted(bool value) {
    _$resetTimerAfterChoreCompletedAtom.context.conditionallyRunInAction(() {
      super.resetTimerAfterChoreCompleted = value;
      _$resetTimerAfterChoreCompletedAtom.reportChanged();
    }, _$resetTimerAfterChoreCompletedAtom,
        name: '${_$resetTimerAfterChoreCompletedAtom.name}_set');
  }

  final _$_ChoreStoreActionController = ActionController(name: '_ChoreStore');

  @override
  void setTitle(dynamic title) {
    final _$actionInfo = _$_ChoreStoreActionController.startAction();
    try {
      return super.setTitle(title);
    } finally {
      _$_ChoreStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNextDueDate(DateTime date) {
    final _$actionInfo = _$_ChoreStoreActionController.startAction();
    try {
      return super.setNextDueDate(date);
    } finally {
      _$_ChoreStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNextDueTime(TimeOfDay time) {
    final _$actionInfo = _$_ChoreStoreActionController.startAction();
    try {
      return super.setNextDueTime(time);
    } finally {
      _$_ChoreStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'title: ${title.toString()},nextDue: ${nextDue.toString()},notes: ${notes.toString()},resetTimerAfterChoreCompleted: ${resetTimerAfterChoreCompleted.toString()}';
    return '{$string}';
  }
}
