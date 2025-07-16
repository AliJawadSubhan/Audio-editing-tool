import 'package:audio_editing_tool/src/file_services/core_audio_editing_tools.dart';
import 'package:audio_editing_tool/src/file_services/file_service.dart';

class AudioEditorHelper {
  /// Trims an audio file from [start] to [end] seconds.
  static Future<(bool success, String outputPath)> trim(
    String inputFilePath,
    double start,
    double end,
  ) async {
    final outputPath = await FileServices().getOutputFilePath();
    return CoreAudioEditingTools.trimAudio(
      inputFilePath,
      outputPath,
      start,
      end,
    );
  }

  /// Changes volume of [inputFilePath] by [factor].
  static Future<(bool, String)> changeVolume(
    String inputFilePath,
    double factor,
  ) async {
    final outputPath = await FileServices().getOutputFilePath();
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
    final outputPath = await FileServices().getOutputFilePath();
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
    final outputPath = await FileServices().getOutputFilePath();
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
    final outputPath = await FileServices().getOutputFilePath();
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
    final outputPath = await FileServices().getOutputFilePath();
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
    final outputPath = await FileServices().getOutputFilePath();
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
    final outputPath = await FileServices().getOutputFilePath();
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
    final outputPath = await FileServices().getOutputFilePath();
    return CoreAudioEditingTools.crossfade(
      inputFilePath,
      nextAudio,
      outputPath,
      durationSeconds,
    );
  }
}
