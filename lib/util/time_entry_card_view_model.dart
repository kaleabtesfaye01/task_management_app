import 'package:flutter/material.dart';
import 'package:task_management_app/data/repository.dart';

class TimeEntryCardViewModel extends ChangeNotifier {
  final Repository _repository;

  TimeEntryCardViewModel({Repository? repository}) : _repository = repository ?? Repository();

  Future<void> deleteEntry(
      BuildContext context, String id, VoidCallback onDelete) async {
    final response = await _repository.deleteEntry(id);
    if (context.mounted) {
      if (response.success) {
        onDelete();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error deleting entry')),
        );
      }
    }
  }
}
