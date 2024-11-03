import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/time_entry.dart';

class EntryInputPage extends StatefulWidget {
  const EntryInputPage({super.key, this.entry});

  final TimeEntry? entry;

  @override
  State<EntryInputPage> createState() => _EntryInputPageState();
}

class _EntryInputPageState extends State<EntryInputPage> {
  // variables
  final _taskController = TextEditingController();
  final _tagController = TextEditingController();
  final _dateController = TextEditingController();
  final _fromTimeController = TextEditingController();
  final _toTimeController = TextEditingController();

  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  DateTime? _date;

  FirebaseFirestore? _db;

  // modules
  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _date = widget.entry!.date;
      _fromTime = TimeOfDay.fromDateTime(widget.entry!.from);
      _toTime = TimeOfDay.fromDateTime(widget.entry!.to);

      _taskController.text = widget.entry!.task;
      _tagController.text = widget.entry!.tag;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.entry != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(_date!);
      _fromTimeController.text = _fromTime!.format(context);
      _toTimeController.text = _toTime!.format(context);
    }
  }

  // lifecycle
  @override
  void dispose() {
    _taskController.dispose();
    _tagController.dispose();
    _dateController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        _date = picked;
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
        _fromTimeController.text = picked.format(context);
        _fromTime = picked;
      });
    }
  }

  Future<void> _selectToTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _toTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _toTimeController.text = picked.format(context);
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

    if (task.isEmpty ||
        tag.isEmpty ||
        _date == null ||
        _fromTime == null ||
        _toTime == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill all fields'),
        ));
      }
      return;
    }

    final fromDateTime = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _fromTime!.hour,
      _fromTime!.minute,
    );

    final toDateTime = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _toTime!.hour,
      _toTime!.minute,
    );

    TimeEntry entry = TimeEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      task: task,
      tag: tag,
      date: _date!,
      from: fromDateTime,
      to: toDateTime,
    );

    await _db!
        .collection('entries')
        .withConverter(
          fromFirestore: TimeEntry.fromFirestore,
          toFirestore: (TimeEntry entry, options) => entry.toFirestore(),
        )
        .doc(widget.entry == null ? entry.id : widget.entry!.id)
        .set(entry)
        .then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Entry saved successfully'),
        ));
        Navigator.pop(context);
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
                  controller: _dateController,
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
                        controller: _fromTimeController,
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
                        controller: _toTimeController,
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
