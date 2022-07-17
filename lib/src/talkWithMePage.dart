import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:voice/provider/provider.dart';
import 'package:record/record.dart';
import 'package:microphone/microphone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice/server/recordServer.dart';
import 'package:voice/src/recordReadyPage.dart';
import 'package:permission_handler/permission_handler.dart';

class TalkWithMePage extends StatefulWidget {
  List<String> questionList;
  String email;
  TalkWithMePage({required this.questionList, required this.email});

  @override
  State<TalkWithMePage> createState() => _TalkWithMePageState();
}

class _TalkWithMePageState extends State<TalkWithMePage> {
  late MicrophoneRecorder _microphoneRecorder;
  DateTime now = DateTime.now();
  int qindex = 0;
  @override
  void initState() {
    super.initState();
  }

  final record = Record();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    size = Size(size.width <= 480 ? size.width : 480, size.height);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _backgroundImage(size),
            Column(
              children: [
                Container(
                  height: size.height * 0.1,
                ),
                _question(),
                Container(
                  height: size.height * 0.5,
                ),
                _recordIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _backgroundImage(size) {
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          child: Image.asset(
            "asset/images/background.jpeg",
            fit: BoxFit.fitWidth,
          ),
        ),
        Hero(
          tag: "talkWithMe",
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _question() {
    return Consumer<QuestionIndex>(
      builder: (context, value, child) => Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: AnimatedTextKit(
            key: ValueKey(value.questionIndex),
            isRepeatingAnimation: false,
            animatedTexts: [
              TyperAnimatedText(
                value.questionIndex == -1
                    ? "지금부터 나오는 질문들을 \n녹음버튼을 누르고 따라 읽어주세요"
                    : widget.questionList[value.questionIndex],
                textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _recordIcon() {
    bool isFirstQuestion =
        Provider.of<QuestionIndex>(context).questionIndex == -1;
    if (isFirstQuestion) {
      return SizedBox(
        height: 50,
        width: 130,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(155, 66, 66, 66),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          onPressed: () async {
            context.read<QuestionIndex>().add();
          },
          child: const Text(
            "준비됐나요?",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      );
    } else {
      bool isLastQuestion = context.read<QuestionIndex>().questionIndex ==
          widget.questionList.length - 1;

      return IconButton(
        onPressed: () async {
          context.read<IsPlay>().change();
          if (context.read<IsPlay>().isPlay == false) {
            Future asyncFunction = _audioServerFunction();
            if (isLastQuestion) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecordReadyPage(
                    questionList: widget.questionList,
                    asyncFunction: asyncFunction,
                    email: widget.email,
                  ),
                ),
              );
            } else {
              Provider.of<QuestionIndex>(context, listen: false).add();
            }
          } else {
            kIsWeb ? _recordStartWeb() : _recordStartAndroid();
          }
        },
        icon: context.watch<IsPlay>().isPlay
            ? Icon(Icons.stop_circle_rounded)
            : Icon(Icons.play_circle_rounded),
        iconSize: 100,
      );
    }
  }

  Future<void> _audioServerFunction() async {
    if (kIsWeb) {
      Uint8List value = await _recordStopWeb();
      await uploadRecordFileWeb(value, widget.email,
          "${now.year}.${now.month}.${now.day}", "question ${qindex}");
      _microphoneRecorder.dispose();
    } else {
      var value = await _recordStopAndroid();
      await uploadRecordFileAndrodid(value, widget.email,
          "${now.year}.${now.month}.${now.day}", "question ${qindex}");
    }
    qindex++;
  }

  void _recordStartAndroid() async {
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
    try {
      _microphoneRecorder = MicrophoneRecorder();
      await _microphoneRecorder.init();
      await _microphoneRecorder.start();
    } catch (e) {
      _showSnackBar(context, e.toString());
    }
  }

  Future<Uint8List> _recordStopWeb() async {
    await _microphoneRecorder.stop();
    Uint8List bytesData = await _microphoneRecorder.toBytes();
    return bytesData;
  }

  void _showSnackBar(context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
