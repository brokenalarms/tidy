// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'root_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RootStore on _RootStore, Store {
  final _$choresStoreAtom = Atom(name: '_RootStore.choresStore');

  @override
  ChoresListStore get choresStore {
    _$choresStoreAtom.context.enforceReadPolicy(_$choresStoreAtom);
    _$choresStoreAtom.reportObserved();
    return super.choresStore;
  }

  @override
  set choresStore(ChoresListStore value) {
    _$choresStoreAtom.context.conditionallyRunInAction(() {
      super.choresStore = value;
      _$choresStoreAtom.reportChanged();
    }, _$choresStoreAtom, name: '${_$choresStoreAtom.name}_set');
  }

  @override
  String toString() {
    final string = 'choresStore: ${choresStore.toString()}';
    return '{$string}';
  }
}
