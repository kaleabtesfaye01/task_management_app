import 'package:task_management_app/model/time_entry.dart';

class GetEntryResponse {
  final List<TimeEntry>? entries;
  final String? message;

  GetEntryResponse.success(this.entries) : message = null;
  GetEntryResponse.error(this.message) : entries = null;
}