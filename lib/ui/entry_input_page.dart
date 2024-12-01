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
      builder: (context, child) => Scaffold(
        appBar: AppBar(title: const Text('Input Time Entry')),
        body: SafeArea(
          child: Consumer<EntryInputViewModel>(
            builder: (context, viewModel, _) {
              return Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Task',
                      border: OutlineInputBorder(),
                    ),
                    controller: viewModel.taskController,
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => viewModel.selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: viewModel.dateController,
                        readOnly: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () => viewModel.selectFromTime(context),
                          child: AbsorbPointer(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'From',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.access_time),
                              ),
                              controller: viewModel.fromTimeController,
                              readOnly: true,
                            ),
                          ),
                        ),
                      ),
                      const Text('  -  '),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => viewModel.selectToTime(context),
                          child: AbsorbPointer(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'To',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.access_time),
                              ),
                              controller: viewModel.toTimeController,
                              readOnly: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Tag',
                      border: OutlineInputBorder(),
                    ),
                    controller: viewModel.tagController,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => viewModel.saveEntry(context, entry),
                    child: const Text('Save Entry'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
