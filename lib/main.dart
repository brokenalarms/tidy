import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tidy/pages/chores_view.dart';
import 'package:tidy/stores/chores_list_store.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ChoresListStore>(
            create: (BuildContext context) => ChoresListStore())
      ],
      child: Consumer<ChoresListStore>(
        builder: (BuildContext context, ChoresListStore value, Widget child) {
          return MaterialApp(
              title: 'tidy.', theme: ThemeData.dark(), home: ChoresListPage());
        },
      ),
    );
  }
}
