import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_management_app/data/model/delete_entry_response.dart';
import 'package:task_management_app/data/model/get_entry_response.dart';
import 'package:task_management_app/data/model/save_entry_response.dart';
import 'package:task_management_app/model/time_entry.dart';

class Repository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<SaveEntryResponse> saveEntry(TimeEntry entry, TimeEntry? oldEntry) async {
    try {
      await _db
          .collection('entries')
          .withConverter(
            fromFirestore: TimeEntry.fromFirestore,
            toFirestore: (TimeEntry entry, options) => entry.toFirestore(),
          )
          .doc(oldEntry == null ? entry.id : oldEntry.id)
          .set(entry);
      return SaveEntryResponse.success();
    } catch (error) {
      return SaveEntryResponse.error(error.toString());
    }
  }

  Future<DeleteEntryResponse> deleteEntry(String id) async {
    try {
      await _db.collection('entries').doc(id).delete();
      return DeleteEntryResponse.success();
    } catch (error) {
      return DeleteEntryResponse.error(error.toString());
    }
  }

  Future<GetEntryResponse> getEntries(String? queryBy, String? value) async {
    Query<Map<String, dynamic>> query;
    List<TimeEntry>? entries;

    if (queryBy == null || queryBy.isEmpty) {
      query = _db.collection('entries');
    } else if (queryBy == 'date') {
      Timestamp date = Timestamp.fromDate(DateTime.parse(value!));
      query = _db.collection('entries').where(queryBy, isEqualTo: date);
    } else {
      query = _db.collection('entries').where(queryBy, isEqualTo: queryBy);
    }

    try {
      await query.get().then((querySnapshot) {
        entries = querySnapshot.docs
            .map((doc) => TimeEntry.fromFirestore(doc, null))
            .toList();
      });
      return GetEntryResponse.success(entries);
    } catch (error) {
      return GetEntryResponse.error(error.toString());
    }
  }
}
