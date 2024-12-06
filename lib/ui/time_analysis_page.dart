import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/util/time_analysis_view_model.dart';
import 'package:fl_chart/fl_chart.dart';

class TimeAnalysisPage extends StatelessWidget {
  const TimeAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => TimeAnalysisViewModel()..analyzeTimeSpent(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Time Analysis',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Consumer<TimeAnalysisViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Dropdown for Analysis Type
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: DropdownButton<String>(
                        value: viewModel.analysisType,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: 'By Task',
                            child: Text('Analyze by Task'),
                          ),
                          DropdownMenuItem(
                            value: 'By Tag',
                            child: Text('Analyze by Tag'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            viewModel.updateAnalysisType(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Ranked List
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Top Activities',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: viewModel.analysisResults.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (context, index) {
                                final entry = viewModel.analysisResults[index];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              theme.colorScheme.primary,
                                          child: Text(
                                            (index + 1).toString(),
                                            style: theme.textTheme.bodyLarge
                                                ?.copyWith(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          entry['name'],
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${entry['total'].round()} hrs',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Pie Chart with Scrollable Legend
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time Allocation',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Pie Chart
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 200,// Fixed height for Pie Chart
                                    child: PieChart(
                                      PieChartData(
                                        sections: viewModel.pieChartData,
                                        sectionsSpace: 2,
                                        centerSpaceRadius: 40,
                                        borderData: FlBorderData(show: false),
                                        pieTouchData: PieTouchData(enabled: true),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Scrollable Legend
                                Expanded(
                                  flex: 1,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        viewModel.analysisResults.length,
                                        (index) {
                                          final entry =
                                              viewModel.analysisResults[index];
                                          final color = viewModel
                                              .pieChartData[index].color;
                                          return Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                    color: color,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    '${entry['name']}',
                                                    style: theme.textTheme
                                                        .bodySmall,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
