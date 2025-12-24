class AudioEditingException implements Exception {
  final String message;
  AudioEditingException(this.message);
  @override
  String toString() => message;
}
