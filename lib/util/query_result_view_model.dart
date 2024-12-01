import 'package:flutter/material.dart';
import 'package:task_management_app/data/repository.dart';
import 'package:task_management_app/model/time_entry.dart';

class QueryResultViewModel extends ChangeNotifier{
  final _repository = Repository();
  String? _query;
  String? _value;
  List<TimeEntry>? _entries;

  List<TimeEntry>? get entries => _entries;
  String? get query => _query;
  String? get value => _value;

  Future<void> getEntries() async {
    _repository.getEntries(_query, _value).then((entries) {
      _entries = entries.entries;
      notifyListeners();
    });
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