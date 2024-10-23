import 'package:flutter/material.dart';

class TaskInputView extends StatefulWidget {
  const TaskInputView({super.key});

  @override
  State<TaskInputView> createState() => _TaskInputViewState();
}

class _TaskInputViewState extends State<TaskInputView> {
  // variables
  DateTime? _date;
  TimeOfDay? _time;
  final TextEditingController _datecontroller = TextEditingController();
  final TextEditingController _timecontroller = TextEditingController();
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();

  // methods
  Future<void> _selectDate() async {
    _date = await showDatePicker(
        context: context,
        initialDate: _date ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)
    );

    if (_date != null) {
      setState(() {
        _datecontroller.text = _date.toString().split(" ")[0]; 
      });
    }
  }

  Future<void> _selectTime() async {
    _time = await showTimePicker(
      context: context, 
      initialTime: _time ?? TimeOfDay.now()
      );

    if (_time != null) {
      setState(() {
        _timecontroller.text = '${_time!.hour}:${_time!.minute}';
      });
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: _titlecontroller,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptioncontroller,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _datecontroller,
              decoration: const InputDecoration(
                  labelText: 'Date', 
                  prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(),
            ),
            TextField(
              controller: _timecontroller,
              decoration: const InputDecoration(
                labelText: 'Time',
                prefixIcon: Icon(Icons.access_alarm)
              ),
              readOnly: true,
              onTap: () => _selectTime(),
            ),
            TextButton(
              onPressed: () {
                print(_titlecontroller.text);
                print(_descriptioncontroller.text);
                print(_datecontroller.text);
                print(_timecontroller.text);
              }, 
              child: Text('Save')
              )
          ],
        ),
      ),
    );
  }
}
