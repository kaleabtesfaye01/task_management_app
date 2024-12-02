
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/util/query_input_view_model.dart';

void main() {
  late QueryInputViewModel viewModel;

  setUp(() {
    viewModel = QueryInputViewModel();
  });

  group('QueryInputViewModel Tests', () {
    test('Validate input - empty date for Date query', () {
      viewModel.updateSelectedQueryType('Date');
      expect(viewModel.validateInput(), 'Please select a date.');
    });

    test('Validate input - valid task query', () {
      viewModel.updateSelectedQueryType('Task');
      viewModel.textController.text = 'Task';
      expect(viewModel.validateInput(), isNull);
    });

    test('Generate query result - valid date query', () {
      viewModel.updateSelectedQueryType('Date');
      viewModel.dateController.text = '2024-01-01';
      final query = viewModel.getQueryResult();
      expect(query, {'query': 'date', 'value': '2024-01-01'});
    });
  });
}
