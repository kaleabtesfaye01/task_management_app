import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/ui/entry_input_page.dart';
import 'package:task_management_app/ui/query_input_page.dart';
import 'package:task_management_app/ui/time_entry_card.dart';
import 'package:task_management_app/util/query_result_view_model.dart';

class QueryResultPage extends StatelessWidget {
  const QueryResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => QueryResultViewModel()..getEntries(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Query Results',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          centerTitle: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: theme.colorScheme.primary),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QueryInputPage(),
                  ),
                );
                if (result != null && context.mounted) {
                  final viewModel = context.read<QueryResultViewModel>();
                  viewModel.updateQuery(result['query'], result['value']);
                  await viewModel.getEntries();
                }
              },
            ),
            Consumer<QueryResultViewModel>(
              builder: (context, viewModel, _) => Visibility(
                visible: viewModel.query != null || viewModel.value != null,
                child: IconButton(
                  icon: Icon(Icons.clear, color: theme.colorScheme.error),
                  onPressed: () async {
                    final viewModel = context.read<QueryResultViewModel>();
                    viewModel.clearQuery();
                    await viewModel.getEntries();
                  },
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Consumer<QueryResultViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                );
              }

              final entries = viewModel.entries;

              if (entries == null || entries.isEmpty) {
                return Center(
                  child: Text(
                    'No Results Found',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return TimeEntryCard(
                    entry: entries[index],
                    onDelete: () async {
                      await viewModel.getEntries();
                    },
                    onEdit: () async {
                      await viewModel.getEntries();
                    },
                  );
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EntryInputPage(),
              ),
            );
            if (context.mounted) {
              final viewModel = context.read<QueryResultViewModel>();
              await viewModel.getEntries();
            }
          },
          backgroundColor: theme.colorScheme.primary,
          label: Text(
            'Add Entry',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          icon: Icon(Icons.add, color: theme.colorScheme.onPrimary),
        ),
      ),
    );
  }
}
