import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/util/query_input_view_model.dart';

class QueryInputPage extends StatelessWidget {
  const QueryInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => QueryInputViewModel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Search Query',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Consumer<QueryInputViewModel>(
            builder: (context, viewModel, _) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search By Label
                    Text(
                      'Search By:',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dropdown for Query Type
                    DropdownButtonFormField<String>(
                      value: viewModel.selectedQueryType,
                      items: viewModel.queryTypes
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          viewModel.updateSelectedQueryType(value!),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date or Text Input
                    if (viewModel.selectedQueryType == 'Date')
                      GestureDetector(
                        onTap: () => viewModel.selectDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: viewModel.dateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Select Date',
                              prefixIcon: Icon(
                                Icons.calendar_today_outlined,
                                color: theme.colorScheme.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                          ),
                        ),
                      )
                    else
                      TextField(
                        controller: viewModel.textController,
                        decoration: InputDecoration(
                          labelText: 'Enter ${viewModel.selectedQueryType}',
                          prefixIcon: Icon(
                            Icons.search,
                            color: theme.colorScheme.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                        ),
                      ),
                    const Spacer(),

                    // Submit and Cancel Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final queryResult = viewModel.getQueryResult();
                              if (queryResult == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Please provide valid input.',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(color: theme.colorScheme.onPrimary),
                                    ),
                                    backgroundColor: theme.colorScheme.error,
                                  ),
                                );
                                return;
                              }
                              Navigator.pop(context, queryResult);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Submit',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: theme.colorScheme.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
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
