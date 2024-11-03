import 'package:cloud_firestore/cloud_firestore.dart';

class TimeEntry {
  final String id;
  final String task;
  final DateTime date;
  final DateTime from;
  final DateTime to;
  final String tag;

  TimeEntry({
    required this.id,
    required this.task,
    required this.date,
    required this.from,
    required this.to,
    required this.tag,
  });

  factory TimeEntry.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return TimeEntry(
      id: snapshot.id,
      task: data['task'],
      date: data['date'].toDate(),
      from: data['from'].toDate(),
      to: data['to'].toDate(),
      tag: data['tag'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'task': task,
      'date': Timestamp.fromDate(date),
      'from': Timestamp.fromDate(from),
      'to': Timestamp.fromDate(to),
      'tag': tag,
    };
  }
}
