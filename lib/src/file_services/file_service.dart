import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileServices {
  final List<String> _generatedFiles = [];

  Future<String> getOutputFilePath([String extension = '.mp3']) async {
    final dir = await getTemporaryDirectory();
    final outputDir = Directory('${dir.path}/audio_editor');

    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = '${outputDir.path}/$timestamp$extension';

    _generatedFiles.add(path);
    return path;
  }

  /// Deletes all generated temp files
  Future<void> dispose() async {
    for (final path in _generatedFiles) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
    _generatedFiles.clear();
  }
}
