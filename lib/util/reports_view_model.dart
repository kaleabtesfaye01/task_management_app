import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/data/repository.dart';
import 'package:task_management_app/model/time_entry.dart';

class ReportsViewModel extends ChangeNotifier {
  final Repository _repository;

  ReportsViewModel({Repository? repository}) : _repository = repository ?? Repository();

  List<TimeEntry> _entries = [];
  bool _isLoading = false;
  DateTimeRange? _selectedRange;

  List<TimeEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String get dateRangeText {
  if (_selectedRange == null) {
    return 'Select Date Range';
  }

  final String start = DateFormat.yMMMd().format(_selectedRange!.start);
  final String end = DateFormat.yMMMd().format(_selectedRange!.end);

  return '$start - $end';
}


  /// Select a date range using `showDateRangePicker`
  Future<void> selectDateRange(BuildContext context) async {
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: _selectedRange ?? DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)),
        end: DateTime.now(),
      ),
    );

    if (pickedRange != null) {
      _selectedRange = pickedRange;
      notifyListeners();
    }
  }

  Future<void> generateReport() async {
    _isLoading = true;
  if (_selectedRange == null) {
    
    return;
  }

  _isLoading = true;
  _entries = []; // Clear previous entries before fetching
  notifyListeners();

  try {
    // Loop through each day in the range
    for (DateTime day = _selectedRange!.start;
        day.isBefore(_selectedRange!.end.add(const Duration(days: 1)));
        day = day.add(const Duration(days: 1))) {
      final response = await _repository.getEntries(
        'date',
        day.toIso8601String().split('T').first, // Format as YYYY-MM-DD
      );
      if (response.entries != null && response.entries!.isNotEmpty) {
        _entries.addAll(response.entries!);
      }
    }
  } catch (error) {
    _entries = [];
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

}
