class NotEnoughParams implements Exception {
  final String? message;

  NotEnoughParams([this.message]);

  @override
  String toString() {
    final message = this.message;
    return message == null ? 'Exception' : 'Exception: $message';
  }
}
