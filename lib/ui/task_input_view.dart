import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/services/firebase_service.dart';

class TaskInputView extends StatefulWidget {
  const TaskInputView({super.key});

  @override
  State<TaskInputView> createState() => _TaskInputViewState();
}

class _TaskInputViewState extends State<TaskInputView> {
  // variables
  DateTime? _date;
  TimeOfDay? _timeFrom;
  TimeOfDay? _timeTo;
  final TextEditingController _datecontroller = TextEditingController();
  final TextEditingController _timeFromcontroller = TextEditingController();
  final TextEditingController _timeTocontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();
  final TextEditingController _tagcontroller = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  // methods
  Future<void> _selectDate() async {
    _date = await showDatePicker(
        context: context,
        initialDate: _date ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (_date != null) {
      setState(() {
        _datecontroller.text = _date.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectTimeFrom() async {
    _timeFrom = await showTimePicker(
        context: context, initialTime: _timeFrom ?? TimeOfDay.now());

    if (_timeFrom != null) {
      setState(() {
        _timeFromcontroller.text = '${_timeFrom!.hour}:${_timeFrom!.minute}';
      });
    }
  }

  Future<void> _selectTimeTo() async {
    _timeTo = await showTimePicker(
        context: context, initialTime: _timeTo ?? TimeOfDay.now());

    if (_timeTo != null) {
      setState(() {
        _timeTocontroller.text = '${_timeTo!.hour}:${_timeTo!.minute}';
      });
    }
  }

  Future<void> _addTask() async {
    final task = Task(
        createdAt: DateTime.timestamp().microsecondsSinceEpoch,
        name: _namecontroller.text,
        description: _descriptioncontroller.text,
        date: _date!,
        timeFrom: _timeFrom!,
        timeTo: _timeTo!);

    await _firebaseService.addTask(task);

    _datecontroller.clear();
    _timeFromcontroller.clear();
    _timeTocontroller.clear();
    _namecontroller.clear();
    _descriptioncontroller.clear();
    _tagcontroller.clear();
    _date = null;
    _timeFrom = null;
    _timeTo = null;
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: _namecontroller,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptioncontroller,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _datecontroller,
              decoration: const InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: _selectDate,
            ),
            TextField(
              controller: _timeFromcontroller,
              decoration: const InputDecoration(
                  labelText: 'TimeFrom', prefixIcon: Icon(Icons.access_alarm)),
              readOnly: true,
              onTap: _selectTimeFrom,
            ),
            TextField(
              controller: _timeTocontroller,
              decoration: const InputDecoration(
                  labelText: 'TimeTo', prefixIcon: Icon(Icons.access_alarm)),
              readOnly: true,
              onTap: _selectTimeTo,
            ),
            TextField(
              controller: _tagcontroller,
              decoration: InputDecoration(labelText: 'Tag'),
            ),
            TextButton(
              onPressed: _addTask,
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
