// Includes helper functions that makes thing easy to work with Files.
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileServices {
  Future<String> getOutputFilePath() async {
    try {
      final dir = await getTemporaryDirectory();
      final outputDir = Directory('${dir.path}/audio_editor');

      if (!await outputDir.exists()) {
        await outputDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return '${outputDir.path}/$timestamp';
    } catch (e) {
      rethrow;
    }
  }

  // }
}
