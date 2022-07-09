import 'package:flutter/material.dart';
import 'package:voice/src/home.dart';
import 'package:voice/src/loginPage.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({Key? key}) : super(key: key);

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
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
                    Container(height: 20),
                    _imageUploadPlace(size),
                    Container(height: size.height * 0.05),
                    Padding(
                      padding: EdgeInsets.only(
                        left: size.width * 0.1,
                        right: size.width * 0.1,
                      ),
                      child: _inputForm(size),
                    ),
                    Container(height: size.height * 0.05),
                    _createButton(size),
                    Container(height: size.height * 0.05),
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

  Widget _imageUploadPlace(size) {
    return Container(
      width: size.width * 0.65,
      height: size.width * 0.65,
      decoration: BoxDecoration(
        color: Color.fromARGB(155, 66, 66, 66),
        borderRadius: BorderRadius.circular(100),
      ),
      child: FittedBox(
          child: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.add_a_photo_outlined,
          color: Color.fromRGBO(224, 227, 227, 1),
        ),
      )),
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
                controller: _nameController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.face), hintText: "이름"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름이 입력되지 않았습니다.';
                  } else {
                    return null;
                  }
                },
              ),
              Container(height: 5),
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.account_circle), hintText: "이메일"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일이 입력되지 않았습니다.';
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
                    hintText: "비밀번호"),
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

  Widget _createButton(size) {
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "계정 생성하기",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
