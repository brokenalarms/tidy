import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../stores/chore_store.dart';
import '../stores/chores_list_store.dart';
import '../stores/date_and_time.dart';

class AddEditChoreForm extends StatefulWidget {
  final ChoreStore _chore;
  final bool _isNewChore;
  final ChoreStore _originalChore;

  AddEditChoreForm(chore, {@required bool isNew})
      : _isNewChore = isNew,
        _chore = isNew ? chore : ChoreStore.copy(chore),
        _originalChore = isNew ? null : chore;

  @override
  _AddEditChoreFormState createState() => _AddEditChoreFormState();
}

class _AddEditChoreFormState extends State<AddEditChoreForm> {
  final _formKey = GlobalKey<FormState>();
  bool _hasValidated = false;

  @override
  Widget build(BuildContext context) {
    final _chore = widget._chore;

    final choreTitle = Observer(
        builder: (_) => TextFormField(
            decoration: _buildTextFormFieldInputDecoration(
              labelText: 'Chore name',
              hintText: 'Wash the damn dishes',
            ),
            initialValue: _chore.title,
            validator: (value) {
              if (value.isEmpty) {
                return 'name is required';
              }
              return null;
            },
            onChanged: (title) => _chore.title = title));

    final dateDropdown = Observer(
        builder: (context) => _buildDateTimeDropdownInkwell(
            labelText: 'Start date',
            dateOrTime: _chore.nextDue.dateText,
            selectFn: () =>
                selectDate(context, initialDate: _chore.nextDue.dateTime)
                    .then(_chore.nextDue.setDatePreservingTime)));

    final timeDropdown = Observer(
        builder: (_) => _buildDateTimeDropdownInkwell(
            labelText: 'Start time',
            dateOrTime: _chore.nextDue.timeText,
            selectFn: () => {
                  selectTime(context, initialTime: _chore.nextDue.time)
                      .then(_chore.nextDue.setTimePreservingDate)
                }));

    final notes = Observer(
        builder: (_) => TextFormField(
              initialValue: _chore.notes,
              decoration: _buildTextFormFieldInputDecoration(
                labelText: 'Notes',
                hintText: 'I just want everything to be pure',
              ),
              onChanged: (notes) => _chore.notes = notes,
            ));

    final saveChoreButton = FlatButton(
      onPressed: () {
        _validateAndSave(context, _chore, widget._originalChore);
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Text(widget._isNewChore ? 'add' : 'update'),
      ),
    );

    final newChoreForm = Form(
      key: _formKey,
      autovalidate: _hasValidated,
      child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            choreTitle,
            dateDropdown,
            timeDropdown,
            notes,
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[saveChoreButton]),
          ]),
    );
    return newChoreForm;
  }

  InputDecoration _buildTextFormFieldInputDecoration({hintText, labelText}) =>
      InputDecoration(
          border: UnderlineInputBorder(),
          hintText: hintText,
          labelText: labelText);

  InkWell _buildDateTimeDropdownInkwell(
          {@required selectFn, @required labelText, @required dateOrTime}) =>
      InkWell(
        onTap: selectFn,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(dateOrTime),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      );

  void _validateAndSave(context, chore, originalChore) {
    if (!_formKey.currentState.validate()) {
      _hasValidated = true;
      return;
    }

    final choreStore = Provider.of<ChoresListStore>(context, listen: false);
    if (widget._isNewChore) {
      choreStore.insertChoreInSortedTimeOrder(chore);
    } else {
      choreStore.replaceChoreInSortedTimeOrder(
          originalChore: originalChore, newChore: chore);
    }
    _formKey.currentState.save();
    Navigator.of(context).pop();
  }
}
