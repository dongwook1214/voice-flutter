import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:voice/provider/provider.dart';
import 'package:voice/provider/provider.dart';

class DialoguePage extends StatefulWidget {
  List<String> questionList;
  DialoguePage({required this.questionList});
  @override
  State<DialoguePage> createState() => _DialoguePageState();
}

class _DialoguePageState extends State<DialoguePage> {
  int _index = 1;

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
      itemBuilder: (context, int index) =>
          _NotSenderMessage(widget.questionList[index], 20),
    );
  }

  Widget _messageBar(size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
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
                  child: const Center(
                    child: Text(
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
              IconButton(
                onPressed: () {
                  setState(() {
                    _index++;
                  });
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _senderMessage(String content) {
    return BubbleSpecialThree(
      text: content,
      color: Color(0xFF1B97F3),
      tail: false,
      textStyle: TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Widget _NotSenderMessage(String content, double duration) {
    return Column(
      children: [
        BubbleSpecialThree(
          text: content,
          color: Color(0xFFE8E8EE),
          tail: false,
          isSender: false,
        ),
        BubbleNormalAudio(
          color: Color(0xFFE8E8EE),
          duration: duration,
          position: 3,
          isPlaying: false,
          isLoading: false,
          isPause: true,
          isSender: false,
          onPlayPauseButtonClick: () {},
          onSeekChanged: (double value) {},
        ),
      ],
    );
  }
}
