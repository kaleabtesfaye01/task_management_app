import 'package:flutter/material.dart';
import 'package:task_management_app/data/repository.dart';
import 'package:task_management_app/model/time_entry.dart';

class EntryInputViewModel extends ChangeNotifier {
  final Repository _repository;

  EntryInputViewModel({Repository? repository}) : _repository = repository ?? Repository();

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();

  DateTime? _date;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;

  TextEditingController get taskController => _taskController;
  TextEditingController get tagController => _tagController;
  TextEditingController get dateController => _dateController;
  TextEditingController get fromTimeController => _fromTimeController;
  TextEditingController get toTimeController => _toTimeController;

  TimeEntry? _editEntry;

  void initialize(TimeEntry? entry, BuildContext context) {
    if (entry != null) {
      _date = entry.date;
      _fromTime = TimeOfDay.fromDateTime(entry.from);
      _toTime = TimeOfDay.fromDateTime(entry.to);

      _taskController.text = entry.task;
      _tagController.text = entry.tag;
      _dateController.text = entry.date.toIso8601String().split('T').first;
      _fromTimeController.text = _fromTime!.format(context);
      _toTimeController.text = _toTime!.format(context);
      _editEntry = entry;
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
      _dateController.text = _date!.toIso8601String().split('T').first;
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

  String? validateInput() {
    if (_taskController.text.isEmpty || _tagController.text.isEmpty) {
      return 'Please fill in all fields.';
    }
    if (_fromTime == null || _toTime == null || _date == null) {
      return 'Please select a valid date and time range.';
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
    if (fromDateTime.isAfter(toDateTime) ||
        fromDateTime.isAtSameMomentAs(toDateTime)) {
      return 'Start time must be earlier than end time.';
    }
    return null;
  }

  Future<bool> checkForOverlap() async {
    List<TimeEntry> entries = [];
    await _repository
        .getEntries(null, null)
        .then((response) => entries = response.entries!);
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
    for (final entry in entries) {
      if (_editEntry != null && entry.id == _editEntry!.id) {
        continue;
      }
      final entryStart = entry.from;
      final entryEnd = entry.to;
      if (fromDateTime.isBefore(entryEnd) && fromDateTime.isAfter(entryStart) ||
          toDateTime.isBefore(entryEnd) && toDateTime.isAfter(entryStart) || 
          fromDateTime.isAtSameMomentAs(entryStart) || toDateTime.isAtSameMomentAs(entryEnd)) {
        return true;
      }
    }
    return false;
  }

  Future<void> saveEntry(BuildContext context) async {
    final validationError = validateInput();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }

    if (await checkForOverlap() && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('The time overlaps with an existing entry.')),
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

    final response = await _repository.saveEntry(entry, _editEntry);
    if (context.mounted) {
      if (response.success!) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entry saved successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save entry.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    _tagController.dispose();
    _dateController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    super.dispose();
  }
}
