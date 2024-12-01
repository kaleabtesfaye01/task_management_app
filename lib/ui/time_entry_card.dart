import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/model/time_entry.dart';
import 'package:task_management_app/ui/entry_input_page.dart';
import 'package:task_management_app/util/time_entry_card_view_model.dart';

class TimeEntryCard extends StatelessWidget {
  const TimeEntryCard({
    super.key,
    required this.entry,
    required this.onDelete,
    required this.onEdit,
  });

  final TimeEntry entry;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimeEntryCardViewModel(),
      builder: (context, child) =>  Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Name
              Text(
                entry.task,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Tag and Date Information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tag: ${entry.tag}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    DateFormat.yMMMd().format(entry.date),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Time Range
              Text(
                'From: ${DateFormat.jm().format(entry.from)} - To: ${DateFormat.jm().format(entry.to)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntryInputPage(entry: entry),
                        ),
                      );
                      onEdit();
                    },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    label: const Text('Edit'),
                  ),
                  const SizedBox(width: 10),
                  Consumer<TimeEntryCardViewModel>(
                    builder: (context, viewModel, _) => TextButton.icon(
                      onPressed: () async {
                        await viewModel.deleteEntry(context, entry, onDelete);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
