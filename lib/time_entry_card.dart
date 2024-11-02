import 'package:flutter/material.dart';

class TimeEntryCard extends StatelessWidget {
  const TimeEntryCard({super.key});

  // dummy time-entry date
  final String _date = '2021-10-10';
  final String _task = 'Task 1';
  final String _tag = 'Tag 1';
  final String _from = '10:00';
  final String _to = '12:00';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task: $_task'),
          Text('Tag: $_tag'),
          Text('Date: $_date'),
          Text('From: $_from'),
          Text('To: $_to'),
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () {},
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
