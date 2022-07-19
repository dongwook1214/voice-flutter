import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:voice/server/getProfileImage.dart';

import '../server/getQuestionRecord.dart';
import 'dialoguePage.dart';

class RecordReadyPage extends StatefulWidget {
  List<String> questionList;
  Future asyncFunction;
  String email;
  RecordReadyPage(
      {required this.questionList,
      required this.asyncFunction,
      required this.email});

  @override
  State<RecordReadyPage> createState() => _RecordReadyPageState();
}

class _RecordReadyPageState extends State<RecordReadyPage> {
  List<String>? questionRecordURLList;
  bool isReady = false;

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    await widget.asyncFunction;
    questionRecordURLList = await getQuestionRecord(widget.email);
    try {
      setState(() {
        isReady = true;
      });
    } catch (e) {
      print(e);
    }
  }

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
              _command(),
              Container(
                height: size.height * 0.5,
              ),
              _startButton(),
            ],
          ),
        ],
      ),
    ));
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
        Container(
          width: size.width,
          height: size.height,
          color: Colors.black.withOpacity(0.8),
        ),
      ],
    );
  }

  Widget _command() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: AnimatedTextKit(
          isRepeatingAnimation: false,
          animatedTexts: [
            TyperAnimatedText(
              "나와의 대화를 시작합니다\n볼륨을 높여주세요",
              textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget _startButton() {
    if (isReady == true) {
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => FutureBuilder(
                          future: getProfileImage(widget.email),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return DialoguePage(
                                questionList: widget.questionList,
                                questionRecordURLList: questionRecordURLList,
                                email: widget.email,
                                profile: Image(
                                  image: NetworkImage(snapshot.data),
                                ),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        )));
          },
          child: const Text(
            "준비됐나요?",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      );
    } else {
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
          onPressed: () {},
          child: const Text(
            "서버 통신중...",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      );
    }
  }
}
