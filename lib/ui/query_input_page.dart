import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/util/query_input_view_model.dart';

class QueryInputPage extends StatelessWidget {
  const QueryInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QueryInputViewModel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(title: const Text('Query Input Page')),
        body: SafeArea(
          child: Consumer<QueryInputViewModel>(
            builder: (context, viewModel, _) {
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const SizedBox(width: 10),
                      const Text('Query By:'),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: viewModel.selectedQuery,
                        items: viewModel.queryItems.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          viewModel.updateQuery(value!);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      const SizedBox(width: 10),
                      Text('${viewModel.selectedQuery}:'),
                      const SizedBox(width: 10),
                      if (viewModel.selectedQuery == 'Date')
                        Expanded(
                          child: GestureDetector(
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
                        )
                      else
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: viewModel.selectedQuery,
                              border: const OutlineInputBorder(),
                            ),
                            controller: viewModel.textController,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final result = {
                        'query': viewModel.selectedQuery.toLowerCase(),
                        'value': viewModel.selectedQuery == 'Date'
                            ? viewModel.dateController.text
                            : viewModel.textController.text,
                      };
                      Navigator.pop(context, result);
                    },
                    child: const Text('Query'),
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
