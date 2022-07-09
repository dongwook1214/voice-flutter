import 'package:flutter/material.dart';
import 'package:voice/src/home.dart';
import 'package:voice/src/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.white,
                    brightness: Brightness.dark,
                  ),
                  fontFamily: 'NotoSansKr',
                ),
                home: snapshot.data.getString('name') == null
                    ? LoginPage()
                    : homePage(name: snapshot.data.getString('name')),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
