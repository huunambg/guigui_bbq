// import 'package:asa189_dream/config/global_text_style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:lottie/lottie.dart';

// class AudioRecorderCustom extends StatefulWidget {
//   const AudioRecorderCustom({super.key});

//   @override
//   _AudioRecorderCustomState createState() => _AudioRecorderCustomState();
// }

// class _AudioRecorderCustomState extends State<AudioRecorderCustom> {
//   FlutterSoundRecorder? _recorder;
//   FlutterSoundPlayer? _player;
//   bool _isRecording = false;
//   bool _isPlaying = false;
//   String? _filePath;

//   @override
//   void initState() {
//     super.initState();
//     _recorder = FlutterSoundRecorder();
//     _player = FlutterSoundPlayer();
//     _openAudioSession();
//   }

//   Future<void> _openAudioSession() async {
//     try {
//       await _recorder!.openRecorder();
//       await _player!.openPlayer();
//       await _checkPermissions();
//       await _loadFilePath();
//     } catch (e) {
//       debugPrint("Error opening audio session: $e");
//     }
//   }

//   Future<void> _checkPermissions() async {
//     final microphoneStatus = await Permission.microphone.request();
//     final storageStatus = await Permission.storage.request();

//     if (!microphoneStatus.isGranted || !storageStatus.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Microphone and Storage permissions are required")),
//       );
//     }
//   }

//   Future<void> _loadFilePath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     _filePath = "${directory.path}/recording1.aac";
//   }

//   void showDialogLoad() async {
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: const Color(0xFF1D273E),
//           child: SizedBox(
//               height: 350,
//               width: 350,
//               child: Column(
//                 children: [
//                   Lottie.asset("assets/lotties/recording.json",
//                       width: 250, height: 250, fit: BoxFit.cover),
//                   GestureDetector(
//                     onTap: () async {
//                       Get.back();

//                       _stopRecording();
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [
//                               Color(0xFF4350B0), // Màu #4350B0
//                               Color(0xFF3076C9), // Màu #3076C9
//                             ],
//                             stops: [
//                               0.0,
//                               0.9967
//                             ], // Tương ứng với tỷ lệ -0.33% và 99.67%
//                           ),
//                           borderRadius: BorderRadius.circular(12.0)),
//                       alignment: Alignment.center,
//                       height: 60,
//                       width: 100,
//                       child: Text(
//                         "Stop",
//                         style: GlobalTextStyles.font14w600ColorWhite,
//                       ),
//                     ),
//                   )
//                 ],
//               )),
//         );
//       },
//     );
//   }

//   Future<void> _startRecording() async {
//     try {
//       await _recorder!.startRecorder(
//         toFile: _filePath,
//         codec: Codec.aacADTS,
//       );
//       showDialogLoad();
//       setState(() {
//         _isRecording = true;
//       });
//     } catch (e) {
//       debugPrint("Error starting recording: $e");
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _recorder!.stopRecorder();
//       debugPrint("Succcess Record");
//       setState(() {
//         _isRecording = false;
//       });
//     } catch (e) {
//       debugPrint("Error stopping recording: $e");
//     }
//   }

//   Future<void> _playRecording() async {
//     try {
//       if (_filePath != null && !_isPlaying) {
//         await _player!.startPlayer(
//           fromURI: _filePath,
//           codec: Codec.aacADTS,
//           whenFinished: () {
//             setState(() {
//               _isPlaying = false;
//             });
//           },
//         );
//         setState(() {
//           _isPlaying = true;
//         });
//       }
//     } catch (e) {
//       debugPrint("Error playing recording: $e");
//     }
//   }

//   Future<void> _stopPlaying() async {
//     try {
//       await _player!.stopPlayer();
//       setState(() {
//         _isPlaying = false;
//       });
//     } catch (e) {
//       debugPrint("Error stopping playback: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _recorder?.closeRecorder();
//     _player?.closePlayer();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Audio Recorder")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _isRecording ? _stopRecording : _startRecording,
//               child: Text(_isRecording ? "Stop Recording" : "Start Recording"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isPlaying ? _stopPlaying : _playRecording,
//               child: Text(_isPlaying ? "Stop Playing" : "Play Recording"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
