class DeleteEntryResponse {
  final bool success;
  final String? message;

  DeleteEntryResponse.success() : message = null, success = true;
  DeleteEntryResponse.error(this.message) : success = false;
}