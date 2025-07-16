import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart' as ffmpeg;
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

class CoreAudioEditingTools {
  static Future<(bool success, String result)> _runFFmpeg(
      String command, String outputPath) async {
    final session = await ffmpeg.FFmpegKit.execute(command);
    final rc = await session.getReturnCode();

    if (ReturnCode.isSuccess(rc)) {
      return (true, outputPath);
    } else {
      final logs = await session.getAllLogsAsString();
      return (false, logs ?? "Unable to get logs");
    }
  }

  static Future<(bool, String)> trimAudio(
    String input,
    String output,
    double start,
    double end,
  ) async {
    final cmd = '-y -i "$input" -ss $start -to $end -c copy "$output"';
    return _runFFmpeg(cmd, output);
  }

  static Future<(bool, String)> changeVolume(
    String input,
    String output,
    double factor, // 0.5 = half, 2.0 = double
  ) async {
    final cmd = '-y -i "$input" -filter:a "volume=$factor" "$output"';
    return _runFFmpeg(cmd, output);
  }

  static Future<(bool, String)> fadeIn(
    String input,
    String output,
    double durationSeconds,
  ) async {
    final cmd =
        '-y -i "$input" -af "afade=t=in:ss=0:d=$durationSeconds" "$output"';
    return _runFFmpeg(cmd, output);
  }

  static Future<(bool, String)> fadeOutAuto(
    String input,
    String output,
    double fadeDuration,
  ) async {
    try {
      // Step 1: Get duration using ffprobe (via ffmpeg)
      final probeSession = await ffmpeg.FFmpegKit.executeWithArguments([
        '-i',
        input,
        '-hide_banner',
        '-f',
        'null',
        '-',
      ]);

      final logs = await probeSession.getAllLogsAsString();
      final match = RegExp(r'Duration: (\d+):(\d+):(\d+\.\d+)')
          .firstMatch(logs ?? "No logs");

      if (match == null) {
        return (false, 'Failed to detect duration');
      }

      final h = int.parse(match.group(1)!);
      final m = int.parse(match.group(2)!);
      final s = double.parse(match.group(3)!);

      final totalDuration = h * 3600 + m * 60 + s;

      if (fadeDuration > totalDuration) {
        return (false, 'fadeDuration is longer than audio length');
      }

      // Step 2: Compute start time
      final start = totalDuration - fadeDuration;

      // Step 3: Build FFmpeg command
      final cmd =
          '-y -i "$input" -af "afade=t=out:st=$start:d=$fadeDuration" "$output"';

      return _runFFmpeg(cmd, output);
    } catch (e) {
      return (false, e.toString());
    }
  }

  static Future<(bool, String)> changeSpeed(
    String input,
    String output,
    double speed, // 0.5 = slow, 2.0 = fast
  ) async {
    final cmd = '-y -i "$input" -filter:a "atempo=$speed" "$output"';
    return _runFFmpeg(cmd, output);
  }

  static Future<(bool, String)> convertFormat(
    String input,
    String newExtension,
  ) async {
    if (!newExtension.startsWith('.')) {
      return (false, 'Invalid extension: must start with a dot (e.g. .mp3)');
    }

    final dir = p.dirname(input);
    final baseNameWithoutExt = p.basenameWithoutExtension(input);
    final outputPath = p.join(dir, '$baseNameWithoutExt$newExtension');

    final cmd = '-y -i "$input" "$outputPath"';
    return _runFFmpeg(cmd, outputPath);
  }

  static Future<(bool, String)> compressAudio(
    String input,
    String output,
  ) async {
    final cmd = '-y -i "$input" -b:a 96k "$output"';
    return _runFFmpeg(cmd, output);
  }

  static Future<(bool, String)> mergeAudios(
    List<String> inputPaths,
    String outputPath,
  ) async {
    if (inputPaths.length < 2) {
      return (false, 'Need at least two audio files to merge');
    }

    // Build input args: -i "file1" -i "file2" ...
    final inputArgs = inputPaths.map((p) => '-i "$p"').join(' ');
    final amixFilter =
        'amix=inputs=${inputPaths.length}:duration=longest:dropout_transition=2';

    final command = '-y $inputArgs -filter_complex "$amixFilter" "$outputPath"';

    return _runFFmpeg(command, outputPath);
  }

  static Future<(bool, String)> addWatermark(
    String input,
    String output,
    String watermarkAudio,
    bool placeWatermarkAtStart,
  ) async {
    // If placing at end, we delay the watermark by the input's full duration
    // If at start, no delay needed

    final durationResult = await ffmpeg.FFmpegKit.executeWithArguments(
        ['-i', input, '-hide_banner', '-f', 'null', '-']);

    final logs = await durationResult.getAllLogsAsString();
    final match = RegExp(r'Duration: (\d+):(\d+):(\d+\.\d+)')
        .firstMatch(logs ?? 'Unable to get logs');
    if (match == null) return (false, 'Failed to parse audio duration');

    final hours = int.parse(match.group(1)!);
    final minutes = int.parse(match.group(2)!);
    final seconds = double.parse(match.group(3)!);
    final totalDuration = hours * 3600 + minutes * 60 + seconds;

    // 2. Compute delay for watermark
    final delayMs = placeWatermarkAtStart ? 0 : (totalDuration * 1000).round();
    final delayFilter = 'adelay=$delayMs|$delayMs';

    // 3. Final FFmpeg command
    final cmd =
        '-y -i "$input" -i "$watermarkAudio" -filter_complex "[1:a]$delayFilter[wm];[0:a][wm]amix=inputs=2:duration=first:dropout_transition=2" "$output"';

    return _runFFmpeg(cmd, output);
  }

  static Future<(bool, String)> crossfade(
    String input1,
    String input2,
    String output,
    double duration,
  ) async {
    final cmd =
        '-y -i "$input1" -i "$input2" -filter_complex "acrossfade=d=$duration:c1=tri:c2=tri" "$output"';
    return _runFFmpeg(cmd, output);
  }
}


// Features to include.
// 1) Trim.
// 2) Lower or higher the volume.
// 3) Fade Audio in/out.
// 4) Change audio speed.
// 5) convert audio into different file types.
// 6) Audio Compressor.
// 7) Merge audio.
// 8) add watermark.
// 9) add crossfade between transistion
// 10) generate audio wave_form x