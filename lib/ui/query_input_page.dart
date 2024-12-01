import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/util/query_input_view_model.dart';

class QueryInputPage extends StatelessWidget {
  const QueryInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QueryInputViewModel(),
      builder: (context, child) =>  Scaffold(
        appBar: AppBar(
          title: const Text('Search Query'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Consumer<QueryInputViewModel>(
            builder: (context, viewModel, _) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Search By:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: viewModel.selectedQueryType,
                      items: viewModel.queryTypes
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          viewModel.updateSelectedQueryType(value!),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (viewModel.selectedQueryType == 'Date')
                      GestureDetector(
                        onTap: () => viewModel.selectDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: viewModel.dateController,
                            decoration: const InputDecoration(
                              labelText: 'Select Date',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      )
                    else
                      TextField(
                        controller: viewModel.textController,
                        decoration: InputDecoration(
                          labelText: 'Enter ${viewModel.selectedQueryType}',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final queryResult = viewModel.getQueryResult();
                              if (queryResult == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please provide valid input.'),
                                  ),
                                );
                                return;
                              }
                              Navigator.pop(context, queryResult);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Submit'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                      ],
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
