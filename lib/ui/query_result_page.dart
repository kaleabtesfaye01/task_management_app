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
    return ChangeNotifierProvider(
      create: (_) => QueryResultViewModel()..getEntries(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Query Results',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QueryInputPage()),
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
                  icon: const Icon(Icons.clear),
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final entries = viewModel.entries;

              if (entries == null || entries.isEmpty) {
                return const Center(
                  child: Text(
                    'No Results Found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(10),
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
        floatingActionButton: FloatingActionButton(
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
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
