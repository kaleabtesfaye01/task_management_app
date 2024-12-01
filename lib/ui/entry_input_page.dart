import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/model/time_entry.dart';
import 'package:task_management_app/util/entry_input_view_model.dart';

class EntryInputPage extends StatelessWidget {
  const EntryInputPage({super.key, this.entry});

  final TimeEntry? entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => EntryInputViewModel()..initialize(entry, context),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            entry == null ? 'New Time Entry' : 'Edit Time Entry',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Consumer<EntryInputViewModel>(
            builder: (context, viewModel, _) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Task Name
                    TextField(
                      controller: viewModel.taskController,
                      decoration: InputDecoration(
                        labelText: 'Task Name',
                        prefixIcon: Icon(Icons.task, color: theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date Picker
                    GestureDetector(
                      onTap: () => viewModel.selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: viewModel.dateController,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            prefixIcon: Icon(Icons.calendar_today, color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Time Range
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.selectFromTime(context),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: viewModel.fromTimeController,
                                decoration: InputDecoration(
                                  labelText: 'Start Time',
                                  prefixIcon: Icon(Icons.access_time, color: theme.colorScheme.primary),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.selectToTime(context),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: viewModel.toTimeController,
                                decoration: InputDecoration(
                                  labelText: 'End Time',
                                  prefixIcon: Icon(Icons.access_time, color: theme.colorScheme.primary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Tag Input
                    TextField(
                      controller: viewModel.tagController,
                      decoration: InputDecoration(
                        labelText: 'Tag',
                        prefixIcon: Icon(Icons.label_outline, color: theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final viewModel = context.read<EntryInputViewModel>();
            await viewModel.saveEntry(context);
          },
          label: Text(
            entry == null ? 'Save Entry' : 'Update Entry',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          icon: Icon(Icons.save, color: theme.colorScheme.onPrimary),
          backgroundColor: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
