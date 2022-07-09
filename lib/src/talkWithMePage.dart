import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:voice/provider/provider.dart';
import 'package:voice/src/dialoguePage.dart';

class TalkWithMePage extends StatefulWidget {
  List<String> questionList;
  TalkWithMePage({required this.questionList});

  @override
  State<TalkWithMePage> createState() => _TalkWithMePageState();
}

class _TalkWithMePageState extends State<TalkWithMePage> {
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
    if (Provider.of<QuestionIndex>(context).questionIndex == -1) {
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
          onPressed: () {
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
      return IconButton(
        onPressed: () {
          context.read<IsPlay>().change();
          if (context.read<IsPlay>().isPlay == false) {
            if (context.read<QuestionIndex>().questionIndex ==
                widget.questionList.length - 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(create: (_) => Timers())
                              ],
                              builder: (context, child) => DialoguePage(
                                    questionList: widget.questionList,
                                  ))));
            } else {
              Provider.of<QuestionIndex>(context, listen: false).add();
            }
          }
        },
        icon: context.watch<IsPlay>().isPlay
            ? Icon(Icons.stop_circle_rounded)
            : Icon(Icons.play_circle_rounded),
        iconSize: 100,
      );
    }
  }
}
