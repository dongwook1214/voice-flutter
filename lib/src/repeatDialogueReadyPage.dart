import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:math' as math;
import 'package:just_audio/just_audio.dart';
import 'package:universal_html/html.dart' as html;

class ReapeatDialogueReadyPage extends StatefulWidget {
  String name;
  Map dialogueAtDay;
  ReapeatDialogueReadyPage({required this.dialogueAtDay, required this.name});

  @override
  State<ReapeatDialogueReadyPage> createState() =>
      _ReapeatDialogueReadyPageState();
}

class _ReapeatDialogueReadyPageState extends State<ReapeatDialogueReadyPage> {
  bool isCanFinish = false;
  late AudioPlayer audiop;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getUserMedia();
  }

  _getUserMedia() async {
    //var stream = await html.window.navigator.getUserMedia(audio: true);
    await html.window.navigator.mediaDevices!.getUserMedia({"audio": true});
    //var permission = await html.window.navigator.permissions!.query({'name': 'microphone'});
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Duration? duration;
    int index = 0;
    while (widget.dialogueAtDay.containsKey("answer ${index}") != false) {
      audiop = AudioPlayer();
      duration = await audiop.setUrl(widget.dialogueAtDay["question $index"]);

      await audiop.play();

      while (audiop.processingState != ProcessingState.completed) {
        await Future.delayed(Duration(seconds: 1));
      }

      audiop = AudioPlayer();
      duration = await audiop.setUrl(widget.dialogueAtDay["answer $index"]);
      await audiop.play();
      while (audiop.processingState != ProcessingState.completed) {
        await Future.delayed(Duration(seconds: 1));
      }
      index++;
    }
    isCanFinish = true;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.name);
    Size size = MediaQuery.of(context).size;
    size = Size(size.width <= 480 ? size.width : 480, size.height);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          Column(
            children: [
              Container(
                height: size.height * 0.1,
              ),
              _name(),
              Container(
                height: size.height * 0.1,
              ),
              _iconCollection(size),
            ],
          ),
          _callButtonIcon(size),
        ],
      ),
    );
  }

  Widget _name() {
    return Center(
      child: Column(
        children: [
          Text(
            widget.name,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
          ),
          Text("휴대전화 연결 중..."),
        ],
      ),
    );
  }

  Widget _iconCollection(size) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon(Icons.mic_outlined, size),
            Container(
              width: size.width * 0.1,
            ),
            _icon(Icons.keyboard, size),
            Container(
              width: size.width * 0.1,
            ),
            _icon(Icons.campaign, size),
          ],
        ),
        Container(
          height: size.width * 0.1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon(Icons.add, size),
            Container(
              width: size.width * 0.1,
            ),
            _icon(Icons.video_camera_front_outlined, size),
            Container(
              width: size.width * 0.1,
            ),
            _icon(Icons.person, size),
          ],
        ),
      ],
    );
  }

  Widget _icon(icon, size) {
    return SizedBox(
      width: size.width * 0.18,
      height: size.width * 0.18,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromARGB(255, 66, 64, 64),
        ),
        child: Icon(
          icon,
          size: size.width * 0.1,
        ),
      ),
    );
  }

  Widget _callButtonIcon(size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: size.width * 0.18,
          height: size.width * 0.18,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.red,
            ),
            child: Transform.rotate(
              angle: 135 * math.pi / 180,
              child: IconButton(
                icon: Icon(Icons.phone_rounded),
                iconSize: size.width * 0.12,
                onPressed: () => _callFinish(),
              ),
            ),
          ),
        ),
        Container(
          height: size.height * 0.1,
        ),
      ],
    );
  }

  void _callFinish() {
    if (isCanFinish) {
      Navigator.pop(context);
    } else {
      _showSnackBar("통화를 끝까지 들어주세요.");
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
