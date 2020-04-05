// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_and_time.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DateAndTime on _DateAndTime, Store {
  final _$_dateAtom = Atom(name: '_DateAndTime._date');

  @override
  Jiffy get _date {
    _$_dateAtom.context.enforceReadPolicy(_$_dateAtom);
    _$_dateAtom.reportObserved();
    return super._date;
  }

  @override
  set _date(Jiffy value) {
    _$_dateAtom.context.conditionallyRunInAction(() {
      super._date = value;
      _$_dateAtom.reportChanged();
    }, _$_dateAtom, name: '${_$_dateAtom.name}_set');
  }

  final _$_DateAndTimeActionController = ActionController(name: '_DateAndTime');

  @override
  void setDatePreservingTime(DateTime newDate) {
    final _$actionInfo = _$_DateAndTimeActionController.startAction();
    try {
      return super.setDatePreservingTime(newDate);
    } finally {
      _$_DateAndTimeActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTimePreservingDate(TimeOfDay time) {
    final _$actionInfo = _$_DateAndTimeActionController.startAction();
    try {
      return super.setTimePreservingDate(time);
    } finally {
      _$_DateAndTimeActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = '';
    return '{$string}';
  }
}
