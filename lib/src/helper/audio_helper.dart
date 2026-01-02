import 'package:Audio_editing_tool/src/file_services/core_audio_editing_tools.dart';
import 'package:Audio_editing_tool/src/file_services/file_service.dart';

class AudioEditorHelper {
  static final _fileService = FileServices();

  static Future<void> dispose() async {
    await _fileService.dispose();
  }

  /// Trims an audio file from [start] to [end] seconds.
  /// The start and end time must be Input file's range.
  static Future<(bool success, String outputPath)> trim(
    String inputFilePath,
    double start,
    double end,
  ) async {
    final outputPath =
        await _fileService.getOutputFilePath(_getFileExtension(inputFilePath));
    // .getOutputFilePath(_getFileExtension(inputFilePath));
    return CoreAudioEditingTools.trimAudio(
      inputFilePath,
      outputPath,
      start,
      end,
    );
  }

  /// Changes volume of [inputFilePath] by [factor].
  /// e.g {2.0, 1.0, 0.5}
  static Future<(bool, String)> changeVolume(
    String inputFilePath,
    double factor,
  ) async {
    final outputPath =
        await _fileService.getOutputFilePath(_getFileExtension(inputFilePath));
    // .getOutputFilePath(_getFileExtension(inputFilePath));
    return CoreAudioEditingTools.changeVolume(
      inputFilePath,
      outputPath,
      factor,
    );
  }

  /// Changes speed of [inputFilePath] by [factor].
  static Future<(bool, String)> changeSpeed(
    String inputFilePath,
    double factor,
  ) async {
    final outputPath =
        await _fileService.getOutputFilePath(_getFileExtension(inputFilePath));
    // .getOutputFilePath(_getFileExtension(inputFilePath));
    return CoreAudioEditingTools.changeSpeed(
      inputFilePath,
      outputPath,
      factor,
    );
  }

  /// Applies fade-in effect for [durationSeconds].
  static Future<(bool, String)> fadeIn(
    String inputFilePath,
    double durationSeconds,
  ) async {
    final outputPath =
        await _fileService.getOutputFilePath(_getFileExtension(inputFilePath));
    // .getOutputFilePath(_getFileExtension(inputFilePath));
    return CoreAudioEditingTools.fadeIn(
      inputFilePath,
      outputPath,
      durationSeconds,
    );
  }

  /// Applies fade-out effect for [durationSeconds].
  static Future<(bool, String)> fadeOut(
    String inputFilePath,
    double durationSeconds,
  ) async {
    final outputPath =
        await _fileService.getOutputFilePath(_getFileExtension(inputFilePath));
    // .getOutputFilePath(_getFileExtension(inputFilePath));
    return CoreAudioEditingTools.fadeOutAuto(
      inputFilePath,
      outputPath,
      durationSeconds,
    );
  }

  /// Converts audio format to [extension] (e.g., ".mp3").
  static Future<(bool, String)> convertTo(
    String inputFilePath,
    String extension,
  ) async {
    return CoreAudioEditingTools.convertFormat(
      inputFilePath,
      extension,
    );
  }

  /// Compresses the audio file to [96k].
  static Future<(bool, String)> compress(
    String inputFilePath,
  ) async {
    final outputPath =
        await _fileService.getOutputFilePath(_getFileExtension(inputFilePath));
    // .getOutputFilePath(_getFileExtension(inputFilePath));
    return CoreAudioEditingTools.compressAudio(
      inputFilePath,
      outputPath,
    );
  }

  /// Merges [inputFilePath] with [otherFiles].
  static Future<(bool, String)> mergeAudios(
    String inputFilePath,
    List<String> otherFiles,
  ) async {
    final outputPath =
        await _fileService.getOutputFilePath(_getFileExtension(inputFilePath));
    // .getOutputFilePath(_getFileExtension(inputFilePath));
    final allInputs = [inputFilePath, ...otherFiles];
    return CoreAudioEditingTools.mergeAudios(
      allInputs,
      outputPath,
    );
  }

  /// Adds watermark to [inputFilePath] using [watermarkAudio].
  static Future<(bool, String)> addWatermark(
    String inputFilePath,
    String watermarkAudio,
    bool placeAtStart,
  ) async {
    final outputPath =
        await _fileService.getOutputFilePath(_getFileExtension(inputFilePath));
    // .getOutputFilePath(_getFileExtension(inputFilePath));
    return CoreAudioEditingTools.addWatermark(
      inputFilePath,
      outputPath,
      watermarkAudio,
      placeAtStart,
    );
  }

  /// Crossfades [inputFilePath] with [nextAudio] over [durationSeconds].
  static Future<(bool, String)> crossFade(
    String inputFilePath,
    String nextAudio,
    double durationSeconds,
  ) async {
    final outputPath =
        await _fileService.getOutputFilePath(_getFileExtension(inputFilePath));
    return CoreAudioEditingTools.crossfade(
      inputFilePath,
      nextAudio,
      outputPath,
      durationSeconds,
    );
  }

  /// Helper method to extract file extension from file path
  static String _getFileExtension(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return '.$extension';
  }
}
