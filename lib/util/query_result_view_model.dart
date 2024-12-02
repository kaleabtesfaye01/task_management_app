import 'package:flutter/material.dart';
import 'package:task_management_app/data/repository.dart';
import 'package:task_management_app/model/time_entry.dart';

class QueryResultViewModel extends ChangeNotifier {
  final Repository _repository;

  QueryResultViewModel({Repository? repository}) : _repository = repository ?? Repository();

  String? _query;
  String? _value;
  List<TimeEntry>? _entries;
  bool _isLoading = false;

  List<TimeEntry>? get entries => _entries;
  String? get query => _query;
  String? get value => _value;
  bool get isLoading => _isLoading;

  Future<void> getEntries() async {
    _isLoading = true;
    notifyListeners();

    final result = await _repository.getEntries(_query, _value);
    _entries = result.entries;
    
    _isLoading = false;
    notifyListeners();
  }

  void updateQuery(String? query, String? value) {
    _query = query;
    _value = value;
    notifyListeners();
  }

  void clearQuery() {
    _query = null;
    _value = null;
    notifyListeners();
  }
}
