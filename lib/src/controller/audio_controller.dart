import 'package:audio_editing_tool/src/file_services/core_audio_editing_tools.dart';
import 'package:audio_editing_tool/src/file_services/file_service.dart';

class AudioEditingController {
  String? _filePath;
  String? _tempOutPutPath;

  /// Sets the current audio file path and initializes a new output path.
  set setFilePath(String path) {
    _filePath = path;
    _getOutPutFilePath();
  }

  /// Returns the currently edited file path.
  String? get filePath => _filePath;

  /// Generates the temporary output file path for the next operation.
  Future<void> _getOutPutFilePath() async {
    if (_filePath != null) {
      _tempOutPutPath =
          await FileServices().getOutputFilePath(_getFileExtension(_filePath!));
    } else {
      _tempOutPutPath = await FileServices().getOutputFilePath();
    }
  }

  /// Trims the current audio between [start] and [end] seconds.
  Future<void> trim(double start, double end) async {
    if (_filePath == null || _tempOutPutPath == null) {
      throw Exception("filePath or tempOutPutPath is not set");
    }
    if (end <= start) {
      throw Exception("End time must be greater than start time.");
    }

    final result = await CoreAudioEditingTools.trimAudio(
      _filePath!,
      _tempOutPutPath!,
      start,
      end,
    );

    if (!result.$1) {
      throw Exception("Trimming failed: ${result.$2}");
    }

    _filePath = _tempOutPutPath;
    _getOutPutFilePath();
  }

  /// Changes volume of the current audio by [factor] (e.g., 0.5 = lower, 2.0 = louder).
  Future<void> changeVolume(double factor) async {
    if (_filePath == null || _tempOutPutPath == null) {
      throw Exception("filePath or tempOutPutPath is not set");
    }
    if (factor <= 0) {
      throw Exception("Volume factor must be greater than 0.");
    }

    final result = await CoreAudioEditingTools.changeVolume(
      _filePath!,
      _tempOutPutPath!,
      factor,
    );

    if (!result.$1) {
      throw Exception("Changing volume failed: ${result.$2}");
    }

    _filePath = _tempOutPutPath;
    _getOutPutFilePath();
  }

  /// Changes playback speed of the current audio by [factor].
  Future<void> changeSpeed(double factor) async {
    if (_filePath == null || _tempOutPutPath == null) {
      throw Exception("filePath or tempOutPutPath is not set");
    }
    if (factor <= 0) {
      throw Exception("Speed factor must be greater than 0.");
    }

    final result = await CoreAudioEditingTools.changeSpeed(
      _filePath!,
      _tempOutPutPath!,
      factor,
    );

    if (!result.$1) {
      throw Exception("Changing speed failed: ${result.$2}");
    }

    _filePath = _tempOutPutPath;
    _getOutPutFilePath();
  }

  /// Applies a fade-in effect to the start of the audio over [durationSeconds].
  Future<void> fadeIn(double durationSeconds) async {
    if (_filePath == null || _tempOutPutPath == null) {
      throw Exception("filePath or tempOutPutPath is not set");
    }
    if (durationSeconds <= 0) {
      throw Exception("Fade-in duration must be positive.");
    }

    final result = await CoreAudioEditingTools.fadeIn(
      _filePath!,
      _tempOutPutPath!,
      durationSeconds,
    );

    if (!result.$1) {
      throw Exception("Fade-in failed: ${result.$2}");
    }

    _filePath = _tempOutPutPath;
    _getOutPutFilePath();
  }

  /// Applies a fade-out effect over the last [durationSeconds] of the audio.
  Future<void> fadeOut(double durationSeconds) async {
    if (_filePath == null || _tempOutPutPath == null) {
      throw Exception("filePath or tempOutPutPath is not set");
    }
    if (durationSeconds <= 0) {
      throw Exception("Fade-out duration must be positive.");
    }

    final result = await CoreAudioEditingTools.fadeOutAuto(
      _filePath!,
      _tempOutPutPath!,
      durationSeconds,
    );

    if (!result.$1) {
      throw Exception("Fade-out failed: ${result.$2}");
    }

    _filePath = _tempOutPutPath;
    _getOutPutFilePath();
  }

  /// Converts the audio to a new format using [fileType] (e.g., ".mp3").
  Future<void> convertTo(String fileType) async {
    if (_filePath == null || fileType.isEmpty) {
      throw Exception("Invalid filePath or fileType.");
    }

    final result = await CoreAudioEditingTools.convertFormat(
      _filePath!,
      fileType,
    );

    if (!result.$1) {
      throw Exception("Convert failed: ${result.$2}");
    }

    _filePath = result.$2;
    _getOutPutFilePath();
  }

  /// Compresses the current audio using a default bitrate 96k.
  Future<void> compress() async {
    if (_filePath == null || _tempOutPutPath == null) {
      throw Exception("filePath or tempOutPutPath is not set");
    }

    final result = await CoreAudioEditingTools.compressAudio(
      _filePath!,
      _tempOutPutPath!,
    );

    if (!result.$1) {
      throw Exception("Compress failed: ${result.$2}");
    }

    _filePath = _tempOutPutPath;
    _getOutPutFilePath();
  }

  /// Merges the current audio with [mergeAudios]. Crossfading not applied.
  Future<void> mergeAudios(List<String> mergeAudios) async {
    if (_filePath == null || _tempOutPutPath == null) {
      throw Exception("filePath or tempOutPutPath is not set");
    }
    if (mergeAudios.isEmpty) {
      throw Exception("No audios provided to merge.");
    }

    final allInputs = [_filePath!, ...mergeAudios];

    final result = await CoreAudioEditingTools.mergeAudios(
      allInputs,
      _tempOutPutPath!,
    );

    if (!result.$1) {
      throw Exception("Merging audios failed: ${result.$2}");
    }

    _filePath = _tempOutPutPath;
    _getOutPutFilePath();
  }

  /// Adds a watermark audio either at the start or end depending on [placeWatermarkAtStart].
  Future<void> addWaterMark(
    String watermarkAudio,
    bool placeWatermarkAtStart,
  ) async {
    if (_filePath == null || _tempOutPutPath == null) {
      throw Exception("filePath or tempOutPutPath is not set");
    }
    if (watermarkAudio.isEmpty) {
      throw Exception("Watermark audio path is empty.");
    }

    final result = await CoreAudioEditingTools.addWatermark(
      _filePath!,
      _tempOutPutPath!,
      watermarkAudio,
      placeWatermarkAtStart,
    );

    if (!result.$1) {
      throw Exception("Watermarking audio failed: ${result.$2}");
    }

    _filePath = _tempOutPutPath;
    _getOutPutFilePath();
  }

  /// Applies a crossfade transition between the current audio and [input].
  Future<void> crossFade(String input, double durationTransition) async {
    if (_filePath == null || _tempOutPutPath == null) {
      throw Exception("filePath or tempOutPutPath is not set");
    }
    if (input.isEmpty || durationTransition <= 0) {
      throw Exception("Invalid crossfade input or duration.");
    }

    final result = await CoreAudioEditingTools.crossfade(
      _filePath!,
      input,
      _tempOutPutPath!,
      durationTransition,
    );

    if (!result.$1) {
      throw Exception("Crossfade audio failed: ${result.$2}");
    }

    _filePath = _tempOutPutPath;
    _getOutPutFilePath();
  }

  /// Helper method to extract file extension from file path
  String _getFileExtension(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return '.$extension';
  }
}
