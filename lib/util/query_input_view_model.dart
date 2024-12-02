import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QueryInputViewModel extends ChangeNotifier {
  final List<String> _queryTypes = ['Date', 'Task', 'Tag'];
  String _selectedQueryType = 'Date';
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<String> get queryTypes => _queryTypes;
  String get selectedQueryType => _selectedQueryType;
  TextEditingController get textController => _textController;
  TextEditingController get dateController => _dateController;

  void updateSelectedQueryType(String type) {
    _selectedQueryType = type;
    _textController.text = '';
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  String? validateInput() {
    if (selectedQueryType == 'Date' && dateController.text.isEmpty) {
      return 'Please select a date.';
    }
    if ((selectedQueryType == 'Task' || selectedQueryType == 'Tag') &&
        textController.text.isEmpty) {
      return 'Please enter a value for $selectedQueryType.';
    }
    return null;
  }

  Map<String, String>? getQueryResult() {
    final validationError = validateInput();
    if (validationError != null) {
      return null;
    }

    final value = selectedQueryType == 'Date'
        ? dateController.text
        : textController.text;
    return {'query': selectedQueryType.toLowerCase(), 'value': value};
  }

  @override
  void dispose() {
    textController.dispose();
    dateController.dispose();
    super.dispose();
  }
}