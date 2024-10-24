import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task {
  int createdAt;
  String name;
  DateTime date;
  TimeOfDay timeFrom;
  TimeOfDay timeTo;

  Task({
    required this.createdAt,
    required this.name,
    required this.date,
    required this.timeFrom,
    required this.timeTo
  });

  factory Task.fromJson(Map<String, dynamic> data) => Task(
      createdAt: data['created_at'],
      name: data['name'],
      date: DateTime.parse(data['date']),
      timeFrom: _stringToTime(data['timeFrom']),
      timeTo: _stringToTime(data['timeTo']));

  Map<String, dynamic> toJson() => {
        'created_at': createdAt,
        'name': name,
        'date': date.toIso8601String(),
        'timeFrom': _timeToString(timeFrom),
        'timeTo': _timeToString(timeTo)
      };
}

TimeOfDay _stringToTime(String time) {
  final format = DateFormat.jm();
  return TimeOfDay.fromDateTime(format.parse(time));
}

String _timeToString(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  final format = DateFormat.jm();
  return format.format(dt);
}
