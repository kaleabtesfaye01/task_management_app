import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_management_app/data/model/delete_entry_response.dart';
import 'package:task_management_app/data/model/get_entry_response.dart';
import 'package:task_management_app/data/model/save_entry_response.dart';
import 'package:task_management_app/model/time_entry.dart';
import 'package:task_management_app/data/repository.dart';

import '../mocks.mocks.dart';

void main() {
  late Repository repository;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockCollectionReference<TimeEntry> mockConvertedCollection;
  late MockDocumentReference<TimeEntry> mockDocument;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>>
      mockQueryDocumentSnapshot;
  late MockQuery<Map<String, dynamic>> mockQuery;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockConvertedCollection = MockCollectionReference<TimeEntry>();
    mockDocument = MockDocumentReference<TimeEntry>();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    mockQuery = MockQuery();

    repository = Repository(db: mockFirestore);
  });

  group('saveEntry', () {
    test('should save entry successfully', () async {
      final entry = TimeEntry(
        id: '1',
        date: DateTime.now(),
        task: 'Test Entry',
        tag: 'Test Tag',
        from: DateTime.now(),
        to: DateTime.now().add(const Duration(hours: 1)),
      );

      when(mockFirestore.collection('entries')).thenReturn(mockCollection);
      when(mockCollection.withConverter<TimeEntry>(
        fromFirestore: anyNamed('fromFirestore'),
        toFirestore: anyNamed('toFirestore'),
      )).thenReturn(mockConvertedCollection);
      when(mockConvertedCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.set(entry)).thenAnswer((_) async {});

      final response = await repository.saveEntry(entry, null);

      expect(response, isA<SaveEntryResponse>());
      expect(response.success, true);
      verify(mockDocument.set(entry)).called(1);
    });

    test('should return error when save fails', () async {
      final entry = TimeEntry(
        id: '1',
        date: DateTime.now(),
        task: 'Test Entry',
        tag: 'Test Tag',
        from: DateTime.now(),
        to: DateTime.now().add(const Duration(hours: 1)),
      );

      // Stub doc and set calls
      when(mockFirestore.collection('entries')).thenReturn(mockCollection);
      when(mockCollection.withConverter<TimeEntry>(
        fromFirestore: anyNamed('fromFirestore'),
        toFirestore: anyNamed('toFirestore'),
      )).thenReturn(mockConvertedCollection);
      when(mockConvertedCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.set(entry)).thenThrow(Exception('Save failed'));

      final response = await repository.saveEntry(entry, null);

      expect(response, isA<SaveEntryResponse>());
      expect(response.success, false);
      expect(response.error, contains('Save failed'));
    });
  });

  group('deleteEntry', () {
    test('should delete entry successfully', () async {
      when(mockFirestore.collection('entries')).thenReturn(mockCollection);
      when(mockCollection.withConverter<TimeEntry>(
        fromFirestore: anyNamed('fromFirestore'),
        toFirestore: anyNamed('toFirestore'),
      )).thenReturn(mockConvertedCollection);
      when(mockConvertedCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.delete()).thenAnswer((_) async {});

      final response = await repository.deleteEntry('1');

      expect(response, isA<DeleteEntryResponse>());
      expect(response.success, true);
      verify(mockDocument.delete()).called(1);
    });

    test('should return error when delete fails', () async {
      when(mockFirestore.collection('entries')).thenReturn(mockCollection);
      when(mockCollection.withConverter<TimeEntry>(
        fromFirestore: anyNamed('fromFirestore'),
        toFirestore: anyNamed('toFirestore'),
      )).thenReturn(mockConvertedCollection);
      when(mockConvertedCollection.doc('1')).thenReturn(mockDocument);
      when(mockDocument.delete()).thenThrow(Exception('Delete failed'));

      final response = await repository.deleteEntry('1');

      expect(response, isA<DeleteEntryResponse>());
      expect(response.success, false);
      expect(response.message, contains('Delete failed'));
    });
  });

  group('getEntries', () {
    test('should fetch all entries when queryBy is null', () async {
      when(mockFirestore.collection('entries')).thenReturn(mockCollection);
      when(mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn({
        'task': 'Test Task',
        'date': Timestamp.fromDate(DateTime(2024, 12, 1)),
        'from': Timestamp.fromDate(DateTime(2024, 12, 1, 9, 0)),
        'to': Timestamp.fromDate(DateTime(2024, 12, 1, 10, 0)),
        'tag': 'Work',
      });
      when(mockQueryDocumentSnapshot.id).thenReturn('1');


      final response = await repository.getEntries(null, null);

      expect(response, isA<GetEntryResponse>());
      expect(response.entries, isNotNull);
      expect(response.entries?.length, 1);
      expect(response.entries?.first.task, 'Test Task');
      verify(mockCollection.get()).called(1);
    });

    test('should fetch entries by custom field', () async {
      when(mockFirestore.collection('entries')).thenReturn(mockCollection);
      when(mockCollection.where('tag', isEqualTo: 'Work')).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn({
        'task': 'Test Task',
        'date': Timestamp.fromDate(DateTime(2024, 12, 1)),
        'from': Timestamp.fromDate(DateTime(2024, 12, 1, 9, 0)),
        'to': Timestamp.fromDate(DateTime(2024, 12, 1, 10, 0)),
        'tag': 'Work',
      });
      when(mockQueryDocumentSnapshot.id).thenReturn('1');

      final response = await repository.getEntries('tag', 'Work');

      expect(response, isA<GetEntryResponse>());
      expect(response.entries!.length, 1);
      expect(response.entries![0].id, '1');
      expect(response.entries![0].tag, 'Work');
      verify(mockCollection.where('tag', isEqualTo: 'Work')).called(1);
    });

    test('should return error when fetch fails', () async {
      when(mockFirestore.collection('entries')).thenReturn(mockCollection);
      when(mockCollection.get()).thenThrow(Exception('Fetch failed'));

      final response = await repository.getEntries(null, null);

      expect(response, isA<GetEntryResponse>());
      expect(response.message, contains('Fetch failed'));
    });

    test('should return empty list when no entries match the query', () async {
      when(mockFirestore.collection('entries')).thenReturn(mockCollection);
      when(mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([]);

      final response = await repository.getEntries(null, null);

      expect(response, isA<GetEntryResponse>());
      expect(response.entries, isEmpty);
      verify(mockCollection.get()).called(1);
    });
  });
}
