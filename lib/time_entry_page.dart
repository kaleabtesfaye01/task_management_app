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

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Entry'),
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
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Task Details'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Task: ${_taskController.text}'),
                        const SizedBox(height: 10),
                        Text('Date: ${_selectedDate == null ? '' : DateFormat.yMd().format(_selectedDate!)}'),
                        const SizedBox(height: 10),
                        Text('From: ${_fromTime == null ? '' : _fromTime!.format(context)}'),
                        const SizedBox(height: 10),
                        Text('To: ${_toTime == null ? '' : _toTime!.format(context)}'),
                        const SizedBox(height: 10),
                        Text('Tag: ${_tagController.text}'),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
