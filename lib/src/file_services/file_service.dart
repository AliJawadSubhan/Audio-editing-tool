// Includes helper functions that makes thing easy to work with Files.
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileServices {
  Future<String> getOutputFilePath([String extension = '.mp3']) async {
    try {
      final dir = await getTemporaryDirectory();
      final outputDir = Directory('${dir.path}/audio_editor');

      if (!await outputDir.exists()) {
        await outputDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return '${outputDir.path}/$timestamp$extension';
    } catch (e) {
      rethrow;
    }
  }

  // }
}
