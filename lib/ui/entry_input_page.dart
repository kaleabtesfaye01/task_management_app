import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/model/time_entry.dart';
import 'package:task_management_app/util/entry_input_view_model.dart';

class EntryInputPage extends StatelessWidget {
  const EntryInputPage({super.key, this.entry});

  final TimeEntry? entry;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EntryInputViewModel()..initialize(entry, context),
      builder: (context, child) =>  Scaffold(
        appBar: AppBar(
          title: const Text('New Time Entry'),
          actions: [
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Cancel',
            ),
          ],
        ),
        body: SafeArea(
          child: Consumer<EntryInputViewModel>(
            builder: (context, viewModel, _) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    TextField(
                      controller: viewModel.taskController,
                      decoration: const InputDecoration(
                        labelText: 'Task Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => viewModel.selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: viewModel.dateController,
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.selectFromTime(context),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: viewModel.fromTimeController,
                                decoration: const InputDecoration(
                                  labelText: 'From Time',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.access_time),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => viewModel.selectToTime(context),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: viewModel.toTimeController,
                                decoration: const InputDecoration(
                                  labelText: 'To Time',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.access_time),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: viewModel.tagController,
                      decoration: const InputDecoration(
                        labelText: 'Tag',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => viewModel.saveEntry(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Save Entry'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
