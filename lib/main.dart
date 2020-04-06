library flutterLocalNotificationsPlugin;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:tidy/pages/chores_view.dart';
import 'package:tidy/stores/chores_list_store.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
//final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//    BehaviorSubject<ReceivedNotification>();

//final BehaviorSubject<String> selectNotificationSubject =
//    BehaviorSubject<String>();

Future<void> _showTimeoutNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'silent channel id', 'silent channel name', 'silent channel description',
      //timeoutAfter: 3000,
      styleInformation: DefaultStyleInformation(true, true));
  var iOSPlatformChannelSpecifics = IOSNotificationDetails(presentSound: false);
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, 'timeout notification',
      'Times out after 3 seconds', platformChannelSpecifics);
}

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

void main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        debugPrint(payload);
//        ReceivedNotification(
//            id: id, title: title, body: body, payload: payload);
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    //selectNotificationSubject.add(payload);
  });

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
      _showTimeoutNotification();
    } else if (state == AppLifecycleState.resumed && _wasInactive) {
      _choresListStore.restart();
      _wasInactive = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _showTimeoutNotification();
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
