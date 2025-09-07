import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:audio_editing_tool/src/controller/audio_controller.dart';
import 'package:audio_editing_tool/src/helper/audio_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ControllerDemoPage(),
                  ),
                );
              },
              child: const Text('Controller Demo'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelperDemoPage(),
                  ),
                );
              },
              child: const Text('Helper Demo'),
            ),
            const SizedBox(height: 32),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Add stubs for the two demo pages
class ControllerDemoPage extends StatefulWidget {
  const ControllerDemoPage({super.key});

  @override
  State<ControllerDemoPage> createState() => _ControllerDemoPageState();
}

class _ControllerDemoPageState extends State<ControllerDemoPage> {
  final AudioEditingController _controller = AudioEditingController();
  String? _selectedFile;
  String? _resultMessage;
  bool _loading = false;
  String? _outputPath;
  String? _mergeFile;
  String? _watermarkFile;
  String? _crossfadeFile;

  Future<void> _pickFile() async {
    setState(() {
      _loading = true;
      _resultMessage = null;
    });
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null && result.files.single.path != null) {
        _selectedFile = result.files.single.path;
        _controller.setFilePath = _selectedFile!;
        setState(() {});
      }
    } catch (e) {
      setState(() {
        _resultMessage = 'Error picking file: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _pickMergeFile() async {
    setState(() {
      _loading = true;
    });
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null && result.files.single.path != null) {
        _mergeFile = result.files.single.path;
        setState(() {});
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _pickWatermarkFile() async {
    setState(() {
      _loading = true;
    });
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null && result.files.single.path != null) {
        _watermarkFile = result.files.single.path;
        setState(() {});
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _pickCrossfadeFile() async {
    setState(() {
      _loading = true;
    });
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null && result.files.single.path != null) {
        _crossfadeFile = result.files.single.path;
        setState(() {});
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _runAllFeatures() async {
    setState(() {
      _loading = true;
      _resultMessage = null;
    });
    try {
      // 1. Trim
      await _controller.trim(0, 2);
      // 2. Change Volume
      await _controller.changeVolume(0.5);
      // 3. Change Speed
      await _controller.changeSpeed(1.5);
      // 4. Fade In
      await _controller.fadeIn(1.0);
      // 5. Fade Out
      await _controller.fadeOut(1.0);
      // 6. Convert (to mp3)
      await _controller.convertTo('.mp3');
      // 7. Compress
      await _controller.compress();
      // 8. Merge (if merge file selected)
      if (_mergeFile != null) {
        await _controller.mergeAudios([_mergeFile!]);
      }
      // 9. Watermark (if watermark file selected)
      if (_watermarkFile != null) {
        await _controller.addWaterMark(_watermarkFile!, true);
      }
      // 10. Crossfade (if crossfade file selected)
      if (_crossfadeFile != null) {
        await _controller.crossFade(_crossfadeFile!, 1.0);
      }
      setState(() {
        _outputPath = _controller.filePath;
        _resultMessage = 'All features applied! Output: $_outputPath';
      });
    } catch (e) {
      setState(() {
        _resultMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controller Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _loading ? null : _pickFile,
                child: const Text('Pick Audio File'),
              ),
              if (_selectedFile != null) ...[
                const SizedBox(height: 16),
                Text('Selected: $_selectedFile'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loading ? null : _pickMergeFile,
                  child: const Text('Pick File to Merge (optional)'),
                ),
                if (_mergeFile != null) Text('Merge File: $_mergeFile'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _loading ? null : _pickWatermarkFile,
                  child: const Text('Pick Watermark File (optional)'),
                ),
                if (_watermarkFile != null)
                  Text('Watermark File: $_watermarkFile'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _loading ? null : _pickCrossfadeFile,
                  child: const Text('Pick Crossfade File (optional)'),
                ),
                if (_crossfadeFile != null)
                  Text('Crossfade File: $_crossfadeFile'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loading ? null : _runAllFeatures,
                  child: const Text('Run All Features'),
                ),
              ],
              if (_loading) ...[
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator()),
              ],
              if (_resultMessage != null) ...[
                const SizedBox(height: 16),
                Text(_resultMessage!,
                    style: const TextStyle(color: Colors.blue)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HelperDemoPage extends StatefulWidget {
  const HelperDemoPage({super.key});

  @override
  State<HelperDemoPage> createState() => _HelperDemoPageState();
}

class _HelperDemoPageState extends State<HelperDemoPage> {
  String? _selectedFile;
  String? _resultMessage;
  bool _loading = false;
  String? _outputPath;
  String? _mergeFile;
  String? _watermarkFile;
  String? _crossfadeFile;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _pickFile() async {
    setState(() {
      _loading = true;
      _resultMessage = null;
    });
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null && result.files.single.path != null) {
        _selectedFile = result.files.single.path;
        setState(() {});
      }
    } catch (e) {
      setState(() {
        _resultMessage = 'Error picking file: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _pickMergeFile() async {
    setState(() {
      _loading = true;
    });
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null && result.files.single.path != null) {
        _mergeFile = result.files.single.path;
        setState(() {});
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _pickWatermarkFile() async {
    setState(() {
      _loading = true;
    });
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null && result.files.single.path != null) {
        _watermarkFile = result.files.single.path;
        setState(() {});
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _pickCrossfadeFile() async {
    setState(() {
      _loading = true;
    });
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null && result.files.single.path != null) {
        _crossfadeFile = result.files.single.path;
        setState(() {});
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _playOutput() async {
    if (_outputPath != null) {
      await _audioPlayer.stop();
      await _audioPlayer.play(DeviceFileSource(_outputPath!));
    }
  }

  Future<void> _runFeature(Future<(bool, String)> Function() feature) async {
    setState(() {
      _loading = true;
      _resultMessage = null;
      _outputPath = null;
    });
    try {
      final result = await feature();
      if (result.$1) {
        setState(() {
          _outputPath = result.$2;
          _resultMessage = 'Success! Output: $_outputPath';
        });
      } else {
        setState(() {
          _resultMessage = 'Failed: ${result.$2}';
          log(_resultMessage.toString());
        });
      }
    } catch (e) {
      setState(() {
        _resultMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Helper Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _loading ? null : _pickFile,
                child: const Text('Pick Audio File'),
              ),
              if (_selectedFile != null) ...[
                const SizedBox(height: 16),
                Text('Selected: $_selectedFile'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () => _runFeature(
                          () => AudioEditorHelper.trim(_selectedFile!, 0, 2)),
                  child: const Text('Trim (first 2 seconds)'),
                ),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () => _runFeature(() =>
                          AudioEditorHelper.changeVolume(_selectedFile!, 0.5)),
                  child: const Text('Change Volume (0.5x)'),
                ),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () => _runFeature(() =>
                          AudioEditorHelper.changeSpeed(_selectedFile!, 1.5)),
                  child: const Text('Change Speed (1.5x)'),
                ),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () => _runFeature(
                          () => AudioEditorHelper.fadeIn(_selectedFile!, 1.0)),
                  child: const Text('Fade In (1s)'),
                ),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () => _runFeature(
                          () => AudioEditorHelper.fadeOut(_selectedFile!, 1.0)),
                  child: const Text('Fade Out (1s)'),
                ),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () => _runFeature(() =>
                          AudioEditorHelper.convertTo(_selectedFile!, '.mp3')),
                  child: const Text('Convert to .mp3'),
                ),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () => _runFeature(
                          () => AudioEditorHelper.compress(_selectedFile!)),
                  child: const Text('Compress'),
                ),
                ElevatedButton(
                  onPressed: _loading ? null : _pickMergeFile,
                  child: const Text('Pick File to Merge (optional)'),
                ),
                if (_mergeFile != null) Text('Merge File: $_mergeFile'),
                ElevatedButton(
                  onPressed: _loading || _mergeFile == null
                      ? null
                      : () => _runFeature(() => AudioEditorHelper.mergeAudios(
                          _selectedFile!, [_mergeFile!])),
                  child: const Text('Merge Audios'),
                ),
                ElevatedButton(
                  onPressed: _loading ? null : _pickWatermarkFile,
                  child: const Text('Pick Watermark File (optional)'),
                ),
                if (_watermarkFile != null)
                  Text('Watermark File: $_watermarkFile'),
                ElevatedButton(
                  onPressed: _loading || _watermarkFile == null
                      ? null
                      : () => _runFeature(() => AudioEditorHelper.addWatermark(
                          _selectedFile!, _watermarkFile!, true)),
                  child: const Text('Add Watermark (at start)'),
                ),
                ElevatedButton(
                  onPressed: _loading ? null : _pickCrossfadeFile,
                  child: const Text('Pick Crossfade File (optional)'),
                ),
                if (_crossfadeFile != null)
                  Text('Crossfade File: $_crossfadeFile'),
                ElevatedButton(
                  onPressed: _loading || _crossfadeFile == null
                      ? null
                      : () => _runFeature(() => AudioEditorHelper.crossFade(
                          _selectedFile!, _crossfadeFile!, 1.0)),
                  child: const Text('Crossfade (1s)'),
                ),
              ],
              if (_outputPath != null) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _playOutput,
                  child: const Text('Play Output'),
                ),
              ],
              if (_loading) ...[
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator()),
              ],
              if (_resultMessage != null) ...[
                const SizedBox(height: 16),
                Text(_resultMessage!,
                    style: const TextStyle(color: Colors.blue)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
