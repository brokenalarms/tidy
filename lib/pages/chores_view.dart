import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tidy/stores/chore_store.dart';
import 'package:tidy/utils/time.dart';

import '../stores/chores_list_store.dart';
import 'create_new_chore_form.dart';

final screenInsets = const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0);

class ChoresListPage extends StatelessWidget {
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tidy.'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () => _pushAddNewChore(context),
          )
        ],
      ),
      body: Observer(builder: (_) => _buildChoreList(context)),
    );
  }

  void _pushAddNewChore(context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
          appBar: AppBar(title: Text("add new chore")),
          body: Padding(padding: screenInsets, child: NewChoreForm()));
    }));
  }

  Widget _buildRow(Chore chore) {
    DateAndTime nextDue = chore.nextDue;
    return ListTile(
      dense: true,
      title: Text(chore.title, style: _biggerFont),
      subtitle: Text('Next due on ${nextDue.dateText} at ${nextDue.timeText}'),
      onTap: () => {},
    );
  }

  Widget _buildChoreList(BuildContext context) {
    final chores = Provider.of<ChoresListStore>(context).chores;
    return Observer(
      builder: (BuildContext context) {
        return ListView.separated(
          itemCount: chores.length,
          padding: screenInsets,
          itemBuilder: (_, index) => _buildRow(chores[index]),
          separatorBuilder: (_, __) => Divider(),
        );
      },
    );
  }
}
