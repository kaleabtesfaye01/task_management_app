import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_management_app/data/model/get_entry_response.dart';
import 'package:task_management_app/util/query_result_view_model.dart';
import 'package:task_management_app/model/time_entry.dart';
import '../mocks.mocks.dart';

void main() {
  late QueryResultViewModel viewModel;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    viewModel = QueryResultViewModel(repository: mockRepository);
  });

  group('QueryResultViewModel Tests', () {
    test('Fetch entries - successful', () async {
      final mockEntries = [
        TimeEntry(
          id: '1',
          task: 'Test Task 1',
          tag: 'Work',
          date: DateTime(2024, 12, 1),
          from: DateTime(2024, 12, 1, 9, 0),
          to: DateTime(2024, 12, 1, 10, 0),
        ),
      ];

      when(mockRepository.getEntries(any, any)).thenAnswer((_) async => GetEntryResponse.success(mockEntries));

      await viewModel.getEntries();

      expect(viewModel.entries, mockEntries);
      verify(mockRepository.getEntries(any, any)).called(1);
    });
  });
}
