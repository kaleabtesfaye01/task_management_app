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
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => TimeEntryCardViewModel(),
      builder: (context, child) => Card(
        elevation: 2,
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
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),

              // Date and Tag
              Row(
                children: [
                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 16,
                          color: theme.colorScheme.onBackground.withOpacity(0.6)),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat.yMMMd().format(entry.date),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Tag
                  Row(
                    children: [
                      Icon(Icons.label_outline,
                          size: 16,
                          color: theme.colorScheme.onBackground.withOpacity(0.6)),
                      const SizedBox(width: 6),
                      Text(
                        entry.tag,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Time Range
              Row(
                children: [
                  Icon(Icons.access_time_outlined,
                      size: 16,
                      color: theme.colorScheme.onBackground.withOpacity(0.6)),
                  const SizedBox(width: 6),
                  Text(
                    '${DateFormat.jm().format(entry.from)} - ${DateFormat.jm().format(entry.to)}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntryInputPage(entry: entry),
                        ),
                      );
                      onEdit();
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      minimumSize: const Size(36, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await context.read<TimeEntryCardViewModel>().deleteEntry(context, entry, onDelete);
                    },
                    icon: Icon(Icons.delete_outline,
                        size: 16, color: theme.colorScheme.error),
                    label: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.colorScheme.error),
                      foregroundColor: theme.colorScheme.error,
                      minimumSize: const Size(36, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
