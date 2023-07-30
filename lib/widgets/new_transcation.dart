import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';

class NewTranscation extends StatefulWidget {
  //const NewTranscation({Key? key}) : super(key: key);
  final Function addNew;
  NewTranscation(this.addNew);

  @override
  State<NewTranscation> createState() => _NewTranscationState();
}

class _NewTranscationState extends State<NewTranscation> {
  final _titleController = TextEditingController();
  DateTime _selectDate = DateTime(2018);
  final _amountController = TextEditingController();

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty ||
        enteredAmount <= 0 ||
        _selectDate == DateTime(2018)) {
      return;
    }
    widget.addNew(enteredTitle, enteredAmount, _selectDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((pickDate) {
      if (pickDate == null) {
        return;
      }
      setState(() {
        _selectDate = pickDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  onSubmitted: (_) =>
                      _submitData(), //_ means we get the parameter but dont care
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) =>
                      _submitData(), //_ means we get the parameter but dont care
                ),
                Container(
                  height: 100,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(_selectDate == DateTime(2018)
                            ? 'No Date Chosen'
                            : 'Picked Date: ${DateFormat.yMMMd().format(_selectDate)}'),
                      ),
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor)),
                          onPressed: _presentDatePicker,
                          child: const Text(
                            "Choose Date",
                          ))
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: _submitData,
                  child: const Text(
                    'Add Transcation',
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
