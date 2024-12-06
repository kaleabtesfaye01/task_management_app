import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/ui/time_entry_card.dart';
import 'package:task_management_app/util/reports_view_model.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => ReportsViewModel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Reports',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Consumer<ReportsViewModel>(
            builder: (context, viewModel, _) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Date Range Picker Button
                    ElevatedButton.icon(
                      onPressed: () => viewModel.selectDateRange(context),
                      icon: const Icon(Icons.date_range),
                      label: Text(viewModel.dateRangeText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Generate Report Button
                    ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                              await viewModel.generateReport();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Generate Report'),
                    ),
                    const SizedBox(height: 16),

                    // Loading Indicator
                    if (viewModel.isLoading)
                      const Center(child: CircularProgressIndicator()),

                    // Entries List or Empty State
                    if (!viewModel.isLoading && viewModel.entries.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            'No entries found for the selected date range.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (!viewModel.isLoading && viewModel.entries.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: viewModel.entries.length,
                          itemBuilder: (context, index) {
                            final entry = viewModel.entries[index];
                            return TimeEntryCard(
                              entry: entry,
                              onEdit: () async {
                                await viewModel.generateReport();
                              },
                              onDelete: () async {
                                await viewModel.generateReport();
                              },
                            );
                          },
                        ),
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
