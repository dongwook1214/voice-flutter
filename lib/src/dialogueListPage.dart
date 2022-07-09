import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DialogueListPage extends StatefulWidget {
  const DialogueListPage({Key? key}) : super(key: key);

  @override
  State<DialogueListPage> createState() => _DialogueListPageState();
}

class _DialogueListPageState extends State<DialogueListPage> {
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
        itemCount: 3, itemBuilder: (context, int index) => _listTile());
  }

  Widget _listTile() {
    return Card(
      child: ListTile(
        onTap: () => print("sdsas"),
        leading: FlutterLogo(),
        title: Text('One-line with both widgets'),
        subtitle: Text('Here is a second line'),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
