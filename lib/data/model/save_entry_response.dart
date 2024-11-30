class SaveEntryResponse<TimeEntry> {
  final bool? success;
  final String? error;

  SaveEntryResponse.success() : error = null, success = true;
  SaveEntryResponse.error(this.error) : success = false;
}