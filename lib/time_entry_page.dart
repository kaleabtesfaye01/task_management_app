import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeEntryPage extends StatefulWidget {
  const TimeEntryPage({super.key});

  @override
  State<TimeEntryPage> createState() => _TimeEntryPageState();
}

class _TimeEntryPageState extends State<TimeEntryPage> {
  // variables
  DateTime? _selectedDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;

  final _taskController = TextEditingController();
  final _tagController = TextEditingController();

  FirebaseFirestore? _db;

  // modules
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectFromTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _fromTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _fromTime) {
      setState(() {
        _fromTime = picked;
      });
    }
  }

  Future<void> _selectToTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _toTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _toTime) {
      setState(() {
        _toTime = picked;
      });
    }
  }

  Future<void> _initDB() async {
    // initialize database
    _db = FirebaseFirestore.instance;
  }

  Future<void> _saveEntry(BuildContext context) async {
    // save entry to database
    if (_db == null) {
      await _initDB();
    }

    final task = _taskController.text;
    final tag = _tagController.text;

    if (task.isEmpty || _selectedDate == null || _fromTime == null || _toTime == null) {
      return;
    }

    final fromDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _fromTime!.hour,
      _fromTime!.minute,
    );

    final toDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _toTime!.hour,
      _toTime!.minute,
    );

    final entry = <String, dynamic>{
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'task': task,
      'from': fromDateTime,
      'to': toDateTime,
      'tag': tag,
    };

    await _db!.collection('entries').add(entry).then((DocumentReference doc) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entry saved successfully'),
        ));
      }
    });
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Time Entry'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Task',
                border: OutlineInputBorder(),
              ),
              controller: _taskController,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                      text: _selectedDate == null
                          ? ''
                          : DateFormat.yMd().format(_selectedDate!)),
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectFromTime(context),
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'From',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        controller: TextEditingController(
                            text: _fromTime == null
                                ? ''
                                : _fromTime!.format(context)),
                        readOnly: true,
                      ),
                    ),
                  ),
                ),
                const Text('  -  '),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectToTime(context),
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'To',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        controller: TextEditingController(
                            text: _toTime == null
                                ? ''
                                : _toTime!.format(context)),
                        readOnly: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Tag',
                border: OutlineInputBorder(),
              ),
              controller: _tagController,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _saveEntry(context),
              child: const Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
