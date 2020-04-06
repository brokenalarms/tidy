import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chores_list_store.dart';

part 'root_store.g.dart';

class RootStore = _RootStore with _$RootStore;

abstract class _RootStore with Store {
  @observable
  ChoresListStore choresStore = ChoresListStore();
  final choreListKey = 'choreListKey';

  void init() async {
    final _prefs = await SharedPreferences.getInstance();
    final existingChoresList = _prefs.getString(choreListKey);
    if (existingChoresList != null) {
      choresStore = jsonDecode(existingChoresList);
    }
  }
}
