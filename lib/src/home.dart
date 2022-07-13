import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:voice/src/dialogueListPage.dart';
import 'package:voice/src/talkWithMePage.dart';
import 'package:provider/provider.dart';
import 'package:voice/provider/provider.dart';
import 'package:voice/server/getQuestion.dart';

class homePage extends StatefulWidget {
  String id;
  homePage({required this.id});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    print(widget.id);
    Size size = MediaQuery.of(context).size;
    size = Size(size.width <= 480 ? size.width : 480, size.height);
    DateTime now = DateTime.now();
    print("${now.year}.${now.month}.${now.day}");
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _backgroundImage(size, now),
          ],
        ),
      ),
    );
  }

  Widget _backgroundImage(size, DateTime now) {
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
        Row(
          children: [
            Hero(
              tag: "talkWithMe",
              child: Container(
                width: size.width * 0.5,
                height: size.height,
                color: Colors.black.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                  create: (_) => QuestionIndex()),
                              ChangeNotifierProvider(
                                  create: (_) => ProfileImage()),
                              ChangeNotifierProvider(create: (_) => IsPlay()),
                            ],
                            child: FutureBuilder(
                                future: getQuestion(widget.id,
                                    "${now.year}.${now.month}.${now.day}"),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return TalkWithMePage(
                                      questionList: snapshot.data,
                                      email: widget.id,
                                    );
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                }),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.record_voice_over,
                              size: 27,
                            ),
                            Container(width: 5),
                            Transform.scale(
                              scaleX: -1,
                              child: const Icon(
                                Icons.record_voice_over,
                                size: 27,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "나와 대화\n하러 가기",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 27),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Hero(
              tag: "selfDialog",
              child: Container(
                width: size.width * 0.5,
                height: size.height,
                color: Colors.grey.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DialogueListPage()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.play_lesson,
                          size: 27,
                        ),
                        Text(
                          "셀프 대화\n기록 보기",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 27),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
