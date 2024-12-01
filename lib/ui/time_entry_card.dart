import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      builder: (context, child) => Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Task: ${entry.task}'),
            Text('Tag: ${entry.tag}'),
            Text('Date: ${entry.date}'),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EntryInputPage(entry: entry),
                      ),
                    );
                    onEdit();
                  },
                  child: const Text('Edit'),
                ),
                Consumer<TimeEntryCardViewModel>(
                  builder: (context, viewModel, _) => TextButton(
                    onPressed: () =>
                        viewModel.deleteEntry(context, entry, onDelete),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
