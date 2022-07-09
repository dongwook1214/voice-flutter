import 'package:flutter/material.dart';
import 'package:voice/src/home.dart';
import 'package:voice/src/signUpPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    size = Size(size.width <= 480 ? size.width : 480, size.height);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              _backgroundImage(size),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(height: size.height * 0.5),
                    Padding(
                      padding: EdgeInsets.only(
                        left: size.width * 0.05,
                        right: size.width * 0.05,
                      ),
                      child: _inputForm(size),
                    ),
                    Container(height: size.height * 0.1),
                    _loginButton(size),
                    Container(height: 10),
                    _createAccountButton(),
                  ],
                ),
              ),
            ],
          ),
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
        Container(
          width: size.width,
          height: size.height,
          color: Colors.black.withOpacity(0.8),
        ),
      ],
    );
  }

  Widget _inputForm(size) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Color.fromARGB(155, 66, 66, 66),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 12, right: 12, bottom: 17),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.account_circle), hintText: "아이디를 입력해주세요."),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '아이디가 입력되지 않았습니다.';
                  } else {
                    return null;
                  }
                },
              ),
              Container(height: 5),
              TextFormField(
                controller: _passWordController,
                decoration: const InputDecoration(
                    icon: Icon(
                      Icons.vpn_key,
                    ),
                    hintText: "비밀번호를 입력해주세요."),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호가 입력되지 않았습니다.';
                  } else {
                    return null;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginButton(size) {
    return Padding(
      padding:
          EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
      child: SizedBox(
        height: size.height * 0.07,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(155, 66, 66, 66),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => homePage(name: "김동욱")),
                (route) => false);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "나와의 대화 시작하기",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createAccountButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => signUpPage()),
        );
      },
      child: const Text(
        "계정이 없다면 여기를 클릭하세요",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
