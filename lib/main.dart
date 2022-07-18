import 'package:flutter/material.dart';
import 'package:voice/src/home.dart';
import 'package:voice/src/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snap) {
        if (snap.hasData) {
          print("firebase connect");
          return FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'voice',
                      theme: ThemeData(
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: Colors.white,
                          brightness: Brightness.dark,
                        ),
                        fontFamily: 'NotoSansKr',
                      ),
                      home: snapshot.data.getString('id') == null
                          ? LoginPage()
                          : homePage(id: snapshot.data.getString('id')),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
