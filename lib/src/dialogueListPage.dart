import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:voice/src/repeatDialogueReadyPage.dart';

import '../server/getName.dart';

class DialogueListPage extends StatefulWidget {
  String email;
  List allDialogue;
  DialogueListPage({required this.email, required this.allDialogue});

  @override
  State<DialogueListPage> createState() => _DialogueListPageState();
}

class _DialogueListPageState extends State<DialogueListPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.allDialogue);
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
                  height: 10,
                ),
                Expanded(
                  child: _listView_builder(),
                )
              ],
            )
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
          tag: "selfDialog",
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.grey.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _listView_builder() {
    return ListView.builder(
        itemCount: widget.allDialogue.length,
        itemBuilder: (context, int index) => _listTile(
              widget.allDialogue[index]["title"],
              widget.allDialogue[index]["date"],
              index,
            ));
  }

  Widget _listTile(String title, String date, int i) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FutureBuilder(
                future: getName(widget.email),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ReapeatDialogueReadyPage(
                        dialogueAtDay: widget.allDialogue[i],
                        name: snapshot.data);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          );
        },
        title: Text(title),
        subtitle: Text(date),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
