import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task {
  int createdAt;
  String name;
  String description;
  DateTime date;
  TimeOfDay timeFrom;
  TimeOfDay timeTo;
  bool isCompleted;

  Task({
    required this.createdAt,
    required this.name,
    required this.description,
    required this.date,
    required this.timeFrom,
    required this.timeTo,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> data) => Task(
      createdAt: data['created_at'],
      name: data['name'],
      description: data['description'],
      date: DateTime.parse(data['date']),
      timeFrom: _stringToTime(data['timeFrom']),
      timeTo: _stringToTime(data['timeTo']),
      isCompleted: data['isCompleted']);

  Map<String, dynamic> toJson() => {
        'created_at': createdAt,
        'name': name,
        'description': description,
        'date': date.toIso8601String(),
        'timeFrom': _timeToString(timeFrom),
        'timeTo': _timeToString(timeTo),
        'isCompleted': isCompleted
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
