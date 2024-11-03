import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QueryInputPage extends StatefulWidget {
  const QueryInputPage({super.key});

  @override
  State<QueryInputPage> createState() => _QueryInputPageState();
}

class _QueryInputPageState extends State<QueryInputPage> {
  // variables
  final List<String> _queryItems = <String>['Date', 'Task', 'Tag'];
  late String _selectedQuery;
  final _textController = TextEditingController();
  final _dateController = TextEditingController();

  // modules
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // lifecycle
  @override
  void initState() {
    super.initState();
    _selectedQuery = _queryItems.first;
  }

  @override
  void dispose() {
    _textController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Input Page'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const SizedBox(width: 10),
                const Text('Query By:'),
                const SizedBox(width: 10),
                DropdownMenu<String>(
                  initialSelection: _queryItems.first,
                  dropdownMenuEntries: _queryItems
                      .map<DropdownMenuEntry<String>>((String value) =>
                          DropdownMenuEntry<String>(value: value, label: value))
                      .toList(),
                  onSelected: (String? value) {
                    setState(() {
                      _selectedQuery = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                const SizedBox(width: 10),
                Text('$_selectedQuery:'),
                const SizedBox(width: 10),
                if (_selectedQuery == 'Date')
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          controller: _dateController,
                          readOnly: true,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: _selectedQuery,
                        border: const OutlineInputBorder(),
                      ),
                      controller: _textController,
                    ),
                  )
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final result = {
                  'query': _selectedQuery.toLowerCase(),
                  'value': _selectedQuery == 'Date'
                      ? _dateController.text
                      : _textController.text
                };
                Navigator.pop(context, result);
              },
              child: const Text('Query'),
            ),
          ],
        ),
      ),
    );
  }
}
