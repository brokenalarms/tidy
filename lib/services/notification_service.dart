import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tidy/stores/chores_list_store.dart';

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

class Debounce {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debounce(this.milliseconds);

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class NotificationService implements Disposable {
  static final _notificationService = NotificationService._internal();

  factory NotificationService() => _notificationService;

  NotificationService._internal();

  NotificationAppLaunchDetails notificationAppLaunchDetails;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _canNotify = true;
  final List<List<String>> _pendingNotifications = [];
  String channelKey = 'com.brokenalarms.tidy.reminders';
  String channelID = 'tidy.reminders';
  String channelName = 'Reminders';
  String channelDescription = 'Daily reminders for overdue tasks';

  init() async {
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    // TODO: app icon here
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // Note: permissions aren't requested here just to demonstrate that can
    // be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          debugPrint(payload);
          ReceivedNotification(
              id: id, title: title, body: body, payload: payload);
        });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    });
  }

  void pushOverdueDateNotification(Jiffy date, String choreName) {
    bool isSameDay = date.isSame(Jiffy(), Units.DAY);
    // TODO: split up this array and format better
    String dateDue = isSameDay ? 'today' : date.fromNow();
    _pendingNotifications.add([choreName, dateDue]);
    Debounce(1000).run(() {
      _showGroupedNotifications();
      _pendingNotifications.clear();
    });
  }

  void _afterNotify() {
    _canNotify = false;
    Timer(Duration(seconds: 3), () => _canNotify = true);
  }

  Future<void> _showTimeoutNotification() async {
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails(channelID, channelName, channelDescription,
            //timeoutAfter: 3000,
            styleInformation: DefaultStyleInformation(true, true));
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'timeout notification',
        'Times out after 3 seconds', platformChannelSpecifics);
  }

  Future<void> _showHighPriorityNotification() async {
    var inboxStyleInformation = InboxStyleInformation(
        _pendingNotifications.map((item) => item[0]),
        htmlFormatLines: true,
        contentTitle: '<b>tidy</b>',
        htmlFormatContentTitle: true,
        summaryText: 'friendly reminder',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelID, channelName, channelDescription,
        importance: Importance.Max,
        priority: Priority.High,
        styleInformation: inboxStyleInformation);
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        1, 'inbox title', 'inbox body', platformChannelSpecifics);
  }

  Future<void> _showGroupedNotifications() async {
    var _groupKey = 'com.brokenalarms.tidy';
    var groupChannelId = 'com.brokenalarms.tidy.reminders';
    var groupChannelName = 'Chore reminders';
    var groupChannelDescription = 'Friendly reminders to do the dishes.';
    List<String> choreTitles =
        _pendingNotifications.map((item) => item[0]).toList();
    var inboxStyleInformation = InboxStyleInformation(choreTitles,
        contentTitle: 'tidy',
        summaryText: 'it is chore time, my dudes',
        htmlFormatTitle: true,
        htmlFormatSummaryText: true,
        htmlFormatContentTitle: true,
        htmlFormatContent: true,
        htmlFormatLines: true);
    _pendingNotifications.asMap().forEach((key, choreInfo) async {
      final notificationAndroidSpecifics = AndroidNotificationDetails(
          groupChannelId, groupChannelName, groupChannelDescription,
          importance: Importance.Max,
          priority: Priority.High,
          styleInformation: inboxStyleInformation,
          groupKey: _groupKey);
      var notificationPlatformSpecifics =
          NotificationDetails(notificationAndroidSpecifics, null);

      final title = '<i>${choreInfo[0]}</i>';
      final body = 'due ${choreInfo[1]}';
      await flutterLocalNotificationsPlugin.show(
          key, title, body, notificationPlatformSpecifics);
    });

    // create the summary notification to support older devices that pre-date Android 7.0 (API level 24).
    // this is required is regardless of which versions of Android your application is going to support
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        styleInformation: inboxStyleInformation,
        groupKey: _groupKey,
        setAsGroupSummary: true);
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(3, 'Attention',
        '${_pendingNotifications.length} messages', platformChannelSpecifics);
  }

  @override
  void dispose() {
    _canNotify = true;
  }
}
