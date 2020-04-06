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

  @override
  String toString() {
    final string =
        'title: ${title.toString()},nextDue: ${nextDue.toString()},notes: ${notes.toString()}';
    return '{$string}';
  }
}
