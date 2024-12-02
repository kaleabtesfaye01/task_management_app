import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_management_app/data/model/get_entry_response.dart';
import 'package:task_management_app/data/model/save_entry_response.dart';
import 'package:task_management_app/model/time_entry.dart';
import 'package:task_management_app/util/entry_input_view_model.dart';
import '../mocks.mocks.dart';

void main() {
  late EntryInputViewModel viewModel;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    viewModel = EntryInputViewModel(repository: mockRepository);
  });

  group('EntryInputViewModel Tests', () {
    test('Validate input - all fields empty', () {
      expect(viewModel.validateInput(), 'Please fill in all fields.');
    });

    testWidgets('Validate input - valid data', (WidgetTester tester) async {
      final mockTimeEntry = TimeEntry(
        id: 'test-id',
        task: 'Task',
        tag: 'Tag',
        date: DateTime(2024, 1, 1),
        from: DateTime(2024, 1, 1, 10, 0),
        to: DateTime(2024, 1, 1, 11, 0),
      );

      await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          // Initialize the viewModel with the mock entry
          viewModel.initialize(mockTimeEntry, context);

          // Validate the input
          final result = viewModel.validateInput();

          // Verify the result is null (no validation errors)
          expect(result, null);

          // Verify that controllers were populated with correct data
          expect(viewModel.taskController.text, 'Task');
          expect(viewModel.tagController.text, 'Tag');
          expect(viewModel.dateController.text, '2024-01-01');
          expect(viewModel.fromTimeController.text, '10:00 AM'); // Adjust based on locale/time format
          expect(viewModel.toTimeController.text, '11:00 AM');   // Adjust based on locale/time format

          return const SizedBox(); // A placeholder widget
        },
      ),
      ));
    });

    testWidgets('Check for overlapping entries - no overlap', (WidgetTester tester) async {
      final mockTimeEntry = TimeEntry(
        id: 'test-id',
        task: 'Task',
        tag: 'Tag',
        date: DateTime(2024, 1, 1),
        from: DateTime(2024, 1, 1, 10, 0),
        to: DateTime(2024, 1, 1, 11, 0),
      );

      when(mockRepository.getEntries(null, null)).thenAnswer((_) async => GetEntryResponse.success([mockTimeEntry]));

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return FutureBuilder<bool>(
              future: () async {
                // Initialize the viewModel with the mock entry
                viewModel.initialize(mockTimeEntry, context);

                final result = await viewModel.checkForOverlap();

                verify(mockRepository.getEntries(null, null)).called(1);
                expect(result, false);

                return true;
              }(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const SizedBox(); // A placeholder widget
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          },
        ),
      ));
    });

    testWidgets('Save entry - successful', (WidgetTester tester) async {
      final mockTimeEntry = TimeEntry(
        id: 'test-id',
        task: 'Task',
        tag: 'Tag',
        date: DateTime(2024, 1, 1),
        from: DateTime(2024, 1, 1, 10, 0),
        to: DateTime(2024, 1, 1, 11, 0),
      );

      when(mockRepository.saveEntry(mockTimeEntry, any)).thenAnswer((_) async => SaveEntryResponse.success());

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return FutureBuilder<void>(
              future: () async {
                // Initialize the viewModel with the mock entry
                viewModel.initialize(mockTimeEntry, context);

                await viewModel.saveEntry(context);

                verify(mockRepository.saveEntry(mockTimeEntry, any)).called(1);

                return;
              }(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const SizedBox(); // A placeholder widget
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          },
        ),
      ));
    });
  });
}
