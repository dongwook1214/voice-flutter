import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice/provider/provider.dart';
import 'package:voice/provider/provider.dart';
import 'package:voice/src/home.dart';
import 'package:record/record.dart';
import 'package:microphone/microphone.dart';

import '../server/recordServer.dart';

class DialoguePage extends StatefulWidget {
  List<String> questionList;
  List<String>? questionRecordURLList;
  String email;
  DialoguePage(
      {required this.questionList,
      required this.questionRecordURLList,
      required this.email});
  @override
  State<DialoguePage> createState() => _DialoguePageState();
}

class _DialoguePageState extends State<DialoguePage> {
  late AudioPlayer audio;
  int _answerIndex = 0;
  int _audioIndex = 0;
  int _index = 1;
  bool _isrecording = false;
  bool _isSendPossible = false;
  DateTime now = DateTime.now();
  final TextEditingController _textController = TextEditingController();
  late MicrophoneRecorder _microphoneRecorder;
  final record = Record();
  @override
  void didChangeDependencies() async {
    print(widget.questionList);
    print(widget.questionRecordURLList);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    audio = AudioPlayer();
    await audio.play(UrlSource(widget.questionRecordURLList![_audioIndex]));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    size = Size(size.width <= 480 ? size.width : 480, size.height);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.white,
            ),
            Column(
              children: [
                Container(
                  height: 10,
                ),
                Expanded(child: _listView_builder()),
              ],
            ),
            _messageBar(size),
          ],
        ),
      ),
    );
  }

  Widget _listView_builder() {
    return ListView.builder(
        itemCount: _index,
        itemBuilder: (context, int index) {
          if (index % 2 == 0) {
            return _notSenderMessage(widget.questionList[index ~/ 2]);
          } else {
            return _senderMessage();
          }
        });
  }

  Widget _messageBar(size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            _isrecording ? _recordingStopFunction() : _recordingFunction();
          },
          child: Container(
            height: 65,
            color: Color.fromARGB(255, 234, 232, 232),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 10,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: _isrecording
                          ? const Text(
                              "녹음을 멈추려면 누르세요.",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            )
                          : const Text(
                              "녹음하려면 누르세요.",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                    ),
                  ),
                ),
                Container(
                  width: 10,
                ),
                _isSendPossible
                    ? IconButton(
                        onPressed: () async {
                          if (_index == widget.questionList.length * 2 - 1) {
                            setState(() {
                              _index++;
                            });
                          } else {
                            _audioIndex++;
                            setState(() {
                              _index++;
                              _isSendPossible = false;
                            });
                            await Future.delayed(Duration(seconds: 1));
                            setState(() {
                              _index++;
                            });
                            await audio.play(UrlSource(
                                widget.questionRecordURLList![_audioIndex]));
                          }
                          if (_index == widget.questionList.length * 2) {
                            _displayDialog();
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                      )
                    : IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.send,
                          color: Colors.brown,
                        ),
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _recordingFunction() async {
    if (kIsWeb) {
      await _recordStartWeb();
    } else {
      await _recordStartAndroid();
    }

    setState(() {
      _isrecording = true;
    });
  }

  Future<void> _recordingStopFunction() async {
    if (kIsWeb) {
      Uint8List value = await _recordStopWeb();
      uploadRecordFileWeb(value, widget.email,
          "${now.year}.${now.month}.${now.day}", "answer ${_answerIndex}");
    } else {
      var value = await _recordStopAndroid();
      uploadRecordFileAndrodid(value, widget.email,
          "${now.year}.${now.month}.${now.day}", "answer ${_answerIndex}");
    }

    _answerIndex++;

    setState(() {
      _isrecording = false;
      _isSendPossible = true;
    });
  }

  Future<void> _recordStartAndroid() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    if (await record.hasPermission()) {
      await record.start(
        path: '$tempPath/${DateTime.now().millisecondsSinceEpoch}',
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
    }
    print("start");
  }

  Future<String> _recordStopAndroid() async {
    var path = await record.stop();
    print("stop");
    return path.toString();
  }

  Future<void> _recordStartWeb() async {
    _microphoneRecorder = MicrophoneRecorder();
    await _microphoneRecorder.init();
    await _microphoneRecorder.start();
  }

  Future<Uint8List> _recordStopWeb() async {
    await _microphoneRecorder.stop();
    Uint8List bytesData = await _microphoneRecorder.toBytes();
    return bytesData;
  }

  Widget _senderMessage() {
    return BubbleNormalAudio(
      color: Color(0xFFE8E8EE),
      duration: 1,
      position: 1,
      isSender: true,
      onPlayPauseButtonClick: () {},
      onSeekChanged: (double value) {},
    );
  }

  Widget _notSenderMessage(String content) {
    return Column(
      children: [
        BubbleSpecialThree(
          text: content,
          color: Color(0xFFE8E8EE),
          tail: false,
          isSender: false,
        ),
      ],
    );
  }

  Future<void> _displayDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('대화를 저장합니다.'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: "제목을 적어주세요."),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => homePage(id: widget.email)),
                      (route) => false);
                  setTitle(widget.email, "${now.year}.${now.month}.${now.day}",
                      _textController.text);
                },
                child: Text("저장하기"))
          ],
        );
      },
    );
  }
}
