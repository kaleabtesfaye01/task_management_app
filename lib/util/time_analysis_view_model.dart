import 'package:flutter/material.dart';
import 'package:task_management_app/data/repository.dart';
import 'package:fl_chart/fl_chart.dart';

class TimeAnalysisViewModel extends ChangeNotifier {
  final Repository _repository;

  TimeAnalysisViewModel({Repository? repository})
      : _repository = repository ?? Repository();

  bool _isLoading = false;
  String _analysisType = 'By Task'; // Default analysis type
  List<Map<String, dynamic>> _analysisResults = [];
  List<PieChartSectionData> _pieChartData = [];

  bool get isLoading => _isLoading;
  String get analysisType => _analysisType;
  List<Map<String, dynamic>> get analysisResults => _analysisResults;
  List<PieChartSectionData> get pieChartData => _pieChartData;

  void updateAnalysisType(String type) {
    _analysisType = type;
    analyzeTimeSpent();
  }

  Future<void> analyzeTimeSpent() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch all entries
      final response = await _repository.getEntries(null, null);
      final entries = response.entries ?? [];

      // Aggregate time by task or tag
      final Map<String, double> timeSpent = {};
      for (var entry in entries) {
        final key = _analysisType == 'By Task' ? entry.task : entry.tag;
        final duration = entry.to.difference(entry.from).inMinutes / 60.0;
        timeSpent[key] = (timeSpent[key] ?? 0) + duration;
      }

      // Prepare ranked list
      _analysisResults = timeSpent.entries
          .map((e) => {'name': e.key, 'total': e.value})
          .toList()
        ..sort((a, b) =>
            (b['total'] as double? ?? 0).compareTo(a['total'] as double? ?? 0));

      // Prepare pie chart data
      _pieChartData = _analysisResults
          .map(
            (e) => PieChartSectionData(
              title: '',
              value: e['total'].round(),
              color: _generateColor(e['name'])
            ),
          )
          .toList();
    } catch (error) {
      _analysisResults = [];
      _pieChartData = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Color _generateColor(String key) {
    // Generate consistent colors for each key (task or tag)
    return Color(key.hashCode & 0xFFFFFFFF).withOpacity(0.7);
  }
}
