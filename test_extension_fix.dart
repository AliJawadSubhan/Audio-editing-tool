import 'package:audio_editing_tool/src/file_services/file_service.dart';

void main() async {
  final fileService = FileServices();

  // Test different file extensions
  final mp3Path = await fileService.getOutputFilePath('.mp3');
  final wavPath = await fileService.getOutputFilePath('.wav');
  final defaultPath = await fileService.getOutputFilePath();

  print('MP3 path: $mp3Path');
  print('WAV path: $wavPath');
  print('Default path: $defaultPath');

  // Verify extensions are correct
  assert(mp3Path.endsWith('.mp3'), 'MP3 path should end with .mp3');
  assert(wavPath.endsWith('.wav'), 'WAV path should end with .wav');
  assert(defaultPath.endsWith('.mp3'), 'Default path should end with .mp3');

  print('✅ All tests passed! File extensions are working correctly.');
}
