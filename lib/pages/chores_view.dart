import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tidy/stores/chore_store.dart';
import 'package:tidy/stores/chores_list_store.dart';

import '../main.dart';
import 'add_edit_chore_form.dart';

final EdgeInsets screenInsets =
    const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0);

class ChoresListPage extends StatelessWidget {
  final _biggerFont = const TextStyle(fontSize: 18);
  final _biggerFontWarning = const TextStyle(fontSize: 18, color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tidy.'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () =>
                _pushAddEditChoreForm(context, ChoreStore(), isNew: true),
          )
        ],
      ),
      body: Observer(builder: _buildChoreList),
    );
  }

  void _pushAddEditChoreForm(BuildContext context, ChoreStore chore,
      {@required isNew}) async {
    (() async {
      List<String> lines = List<String>();
      lines.add('Alex Faarborg  Check this out');
      lines.add('Jeff Chang    Launch Party');
      InboxStyleInformation inboxStyleInformation = InboxStyleInformation(lines,
          contentTitle: '2 new messages', summaryText: 'janedoe@example.com');

      String groupKey = 'com.android.example.WORK_EMAIL';
      String groupChannelId = 'grouped channel id';
      String groupChannelName = 'grouped channel name';
      String groupChannelDescription = 'grouped channel description';
      AndroidNotificationDetails firstNotificationAndroidSpecifics =
          AndroidNotificationDetails(
              groupChannelId, groupChannelName, groupChannelDescription,
              importance: Importance.Max,
              priority: Priority.High,
              groupKey: groupKey);
      NotificationDetails firstNotificationPlatformSpecifics =
          NotificationDetails(firstNotificationAndroidSpecifics, null);
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'silent channel id',
          'silent channel name',
          'silent channel description',
          priority: Priority.High,
          importance: Importance.Max,
          //timeoutAfter: 3000,
          //styleInformation: DefaultStyleInformation(true, true));
          styleInformation: inboxStyleInformation);
      var iOSPlatformChannelSpecifics =
          IOSNotificationDetails(presentSound: false);
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, 'timeout notification',
          'Times out after 3 seconds', platformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(1, 'Alex Faarborg',
          'You will not believe...', firstNotificationPlatformSpecifics);
    })();

    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: Text(isNew ? 'add new chore' : 'edit chore')),
          body: Padding(
              padding: screenInsets,
              child: AddEditChoreForm(chore, isNew: isNew)));
    }));
  }

  Widget _buildRow(BuildContext context, ChoreStore chore) {
    final nextDue = chore.nextDue;
    final dueText = 'Next due on ${nextDue.dateText} at ${nextDue.timeText}';
    final overdueText = 'Overdue: due ${nextDue.date.from(DateTime.now())}';
    return Observer(
        builder: (_) => ListTile(
              dense: true,
              title: Text(chore.title,
                  style: nextDue.isDue ? _biggerFontWarning : _biggerFont),
              subtitle: Text(nextDue.isDue ? overdueText : dueText),
              onTap: () => _pushAddEditChoreForm(context, chore, isNew: false),
            ));
  }

  Widget _buildChoreList(BuildContext context) {
    final chores = Provider.of<ChoresListStore>(context).chores;
    return Observer(
      builder: (context) {
        return ListView.separated(
          itemCount: chores.length,
          padding: screenInsets,
          itemBuilder: (_, index) => _buildRow(context, chores[index]),
          separatorBuilder: (_, __) => Divider(),
        );
      },
    );
  }
}
