import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DialogueListPage extends StatefulWidget {
  const DialogueListPage({Key? key}) : super(key: key);

  @override
  State<DialogueListPage> createState() => _DialogueListPageState();
}

class _DialogueListPageState extends State<DialogueListPage> {
  List _list = [
    ["첫번째 나와의 대화", "2022.07.11"],
    ["두번째 나와의 대화", "2022.07.13"],
    ["세번째 나와의 대화", "2022.07.17"]
  ];
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
        itemCount: 3,
        itemBuilder: (context, int index) =>
            _listTile(_list[index][0], _list[index][1]));
  }

  Widget _listTile(String title, String date) {
    return Card(
      child: ListTile(
        onTap: () => print("sdsas"),
        leading: FlutterLogo(),
        title: Text(title),
        subtitle: Text(date),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
