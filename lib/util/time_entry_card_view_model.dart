import 'package:flutter/material.dart';
import 'package:task_management_app/data/repository.dart';
import 'package:task_management_app/model/time_entry.dart';

class TimeEntryCardViewModel extends ChangeNotifier {
  final Repository _repository = Repository();

  Future<void> deleteEntry(
      BuildContext context, TimeEntry entry, VoidCallback onDelete) async {
    final response = await _repository.deleteEntry(entry.id);
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
