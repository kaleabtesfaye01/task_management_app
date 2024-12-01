import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QueryInputViewModel extends ChangeNotifier {
  final List<String> queryItems = <String>['Date', 'Task', 'Tag'];
  String selectedQuery = 'Date';
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  TextEditingController get textController => _textController;
  TextEditingController get dateController => _dateController;

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void updateQuery(String query) {
    selectedQuery = query;
    notifyListeners();
  }
}
