import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tidy/stores/chore_store.dart';
import 'package:tidy/utils/time.dart';

import '../stores/chores_list_store.dart';

class NewChoreForm extends StatefulWidget {
  @override
  _NewChoreFormState createState() => _NewChoreFormState();
}

class _NewChoreFormState extends State<NewChoreForm> {
  final Chore _newChore = Chore(nextDueDate: DateTime.now());
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final ChoresListStore choreStore = Provider.of<ChoresListStore>(context);
    TextFormField choreTitle = _buildTitleTextFormField(
        labelText: 'Chore name',
        hintText: 'Wash the damn dishes',
        validator: (value) {
          if (value.isEmpty) {
            return 'name is required';
          }
          return null;
        },
        onChanged: (title) => _newChore.title = title);

    SwitchListTile resetTimerAfterCompletionSwitch = SwitchListTile.adaptive(
      title: Text(
        'Reschedule from day chore is completed',
      ),
      secondary: Icon(Icons.restore),
      value: _newChore.resetTimerAfterChoreCompleted,
      onChanged: (bool value) {
        setState(() {
          _newChore.resetTimerAfterChoreCompleted = value;
        });
      },
    );

    final initialDateTime = _newChore.nextDue;

    final dateDropdown = _buildDateTimeDropdown(
      labelText: initialDateTime.dateText,
      selectFn: () => selectDate(context, initialDate: initialDateTime.dateTime)
          .then((date) {
        setState(() {
          initialDateTime.dateWithoutTime = date;
        });
      }),
    );

    final timeDropdown = _buildDateTimeDropdown(
        labelText: initialDateTime.timeText,
        selectFn: () => selectTime(context, initialTime: initialDateTime.time)
                .then((TimeOfDay time) {
              setState(() {
                initialDateTime.time = time;
              });
            }));

    TextFormField notes = _buildTitleTextFormField(
      labelText: 'Notes',
      hintText: 'I just want everything to be pure',
      onChanged: (notes) => _newChore.notes = notes,
    );

    final saveChoreButton = FlatButton(
      onPressed: () {
        if (!_formKey.currentState.validate()) {
          setState(() {
            _autoValidate = true;
          });
        } else {
          choreStore.addChore(_newChore);
          _formKey.currentState.save();
          Navigator.of(context).pop();
        }
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Text('add'),
      ),
    );

    Form newChoreForm = Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            choreTitle,
            dateDropdown,
            timeDropdown,
            resetTimerAfterCompletionSwitch,
            notes,
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[saveChoreButton]),
          ]),
    );

    return newChoreForm;
  }
}

TextFormField _buildTitleTextFormField(
    {@required hintText, @required labelText, @required onChanged, validator}) {
  return TextFormField(
    decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: hintText,
        labelText: labelText),
    // ignore: missing_return
    validator: validator,
    enableSuggestions: true,
    onChanged: onChanged,
  );
}

InkWell _buildDateTimeDropdown({@required selectFn, @required labelText}) =>
    InkWell(
      onTap: selectFn,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: 'Start date',
        ),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(labelText),
            new Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
