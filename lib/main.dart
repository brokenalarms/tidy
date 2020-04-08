library flutterLocalNotificationsPlugin;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tidy/pages/chores_view.dart';
import 'package:tidy/services/notification_service.dart';
import 'package:tidy/stores/chores_list_store.dart';

void main() async {
  // init lifecycle observers
  WidgetsFlutterBinding.ensureInitialized();
  // init static notification service
  await NotificationService()
    ..init();
  runApp(TidyApp());
}

class TidyApp extends StatefulWidget {
  @override
  _TidyAppState createState() => _TidyAppState();
}

class _TidyAppState extends State<TidyApp> with WidgetsBindingObserver {
  final _choresListStore = ChoresListStore();
  bool _wasInactive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      _wasInactive = true;
      _choresListStore.dispose();
    } else if (state == AppLifecycleState.resumed && _wasInactive) {
      _choresListStore.restart();
      _wasInactive = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ChoresListStore>(create: (context) => _choresListStore),
      ],
      child: Consumer<ChoresListStore>(
        builder: (context, value, child) {
          return MaterialApp(
              title: 'tidy.', theme: ThemeData.dark(), home: ChoresListPage());
        },
      ),
    );
  }
}
