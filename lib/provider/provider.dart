import 'dart:async';

import 'package:flutter/material.dart';

class ProfileImage with ChangeNotifier {
  late Image _profileImage;
  Image get profileImage => _profileImage;

  void callProfileImageFromFirebase() {
    notifyListeners();
  }
}

class QuestionIndex with ChangeNotifier {
  int _questionIndex = -1;
  int get questionIndex => _questionIndex;

  void add() {
    _questionIndex++;
    print(_questionIndex);
    notifyListeners();
  }
}

class IsPlay with ChangeNotifier {
  bool _isPlay = false;
  bool get isPlay => _isPlay;

  void change() {
    _isPlay = !_isPlay;
    notifyListeners();
  }
}

class Timers with ChangeNotifier {
  double _time = 0;
  double get time => _time;
  late Timer _timer;

  void start() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      ((timer) {
        _time++;
        notifyListeners();
      }),
    );
  }

  void stop() {
    _timer.cancel();
  }
}
