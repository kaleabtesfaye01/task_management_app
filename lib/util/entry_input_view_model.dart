import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/data/repository.dart';
import 'package:task_management_app/model/time_entry.dart';

class EntryInputViewModel extends ChangeNotifier {
  final _repository = Repository();

  final _taskController = TextEditingController();
  final _tagController = TextEditingController();
  final _dateController = TextEditingController();
  final _fromTimeController = TextEditingController();
  final _toTimeController = TextEditingController();

  TextEditingController get taskController => _taskController;
  TextEditingController get tagController => _tagController;
  TextEditingController get dateController => _dateController;
  TextEditingController get fromTimeController => _fromTimeController;
  TextEditingController get toTimeController => _toTimeController;

  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  DateTime? _date;

  void initialize(TimeEntry? entry, BuildContext context) {
    if (entry != null) {
      _date = entry.date;
      _fromTime = TimeOfDay.fromDateTime(entry.from);
      _toTime = TimeOfDay.fromDateTime(entry.to);

      _taskController.text = entry.task;
      _tagController.text = entry.tag;
      _dateController.text = DateFormat('yyyy-MM-dd').format(_date!);
      _fromTimeController.text = _fromTime!.format(context);
      _toTimeController.text = _toTime!.format(context);
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _date = picked;
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  Future<void> selectFromTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _fromTime ?? TimeOfDay.now(),
    );
    if (picked != null && context.mounted) {
      _fromTime = picked;
      _fromTimeController.text = picked.format(context);
      notifyListeners();
    }
  }

  Future<void> selectToTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _toTime ?? TimeOfDay.now(),
    );
    if (picked != null && context.mounted) {
      _toTime = picked;
      _toTimeController.text = picked.format(context);
      notifyListeners();
    }
  }

  Future<void> saveEntry(BuildContext context, TimeEntry? existingEntry) async {
    if (_taskController.text.isEmpty ||
        _tagController.text.isEmpty ||
        _date == null ||
        _fromTime == null ||
        _toTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
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

    final entry = TimeEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      task: _taskController.text,
      tag: _tagController.text,
      date: _date!,
      from: fromDateTime,
      to: toDateTime,
    );

    final response = await _repository.saveEntry(entry, existingEntry);
    if (context.mounted) {
      if (response.success!) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entry saved successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save entry!')),
        );
      }
    }

    void dispose() {
      _taskController.dispose();
      _tagController.dispose();
      _dateController.dispose();
      _fromTimeController.dispose();
      _toTimeController.dispose();
      super.dispose();
    }
  }
}
