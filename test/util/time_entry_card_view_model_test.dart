import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_management_app/data/model/delete_entry_response.dart';
import 'package:task_management_app/util/time_entry_card_view_model.dart';
import 'package:task_management_app/model/time_entry.dart';
import '../mocks.mocks.dart';

void main() {
  late TimeEntryCardViewModel viewModel;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    viewModel = TimeEntryCardViewModel(repository: mockRepository);
  });

  group('TimeEntryCardViewModel Tests', () {
    testWidgets('Delete entry - successful', (WidgetTester tester) async {
      // Create a mock TimeEntry
      final mockTimeEntry = TimeEntry(
        id: '1',
        task: 'Task',
        tag: 'Tag',
        date: DateTime.now(),
        from: DateTime.now(),
        to: DateTime.now().add(const Duration(hours: 1)),
      );

      // Mock the repository's deleteEntry method to return a successful response
      when(mockRepository.deleteEntry(mockTimeEntry.id))
          .thenAnswer((_) async => DeleteEntryResponse.success());

      // Define a callback to track invocation
      bool callbackInvoked = false;
      void callback() {
        callbackInvoked = true;
      }

      // Build a widget to provide a BuildContext
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            // Call the deleteEntry method in the ViewModel
            viewModel.deleteEntry(context, mockTimeEntry.id, callback);
            return const SizedBox(); // Placeholder widget
          },
        ),
      ));

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Verify that the repository's deleteEntry method was called with the correct argument
      verify(mockRepository.deleteEntry('1')).called(1);

      // Ensure the callback was invoked
      expect(callbackInvoked, isTrue);
    });
  });
}
