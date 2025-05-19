import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:untitled/widget/logo.dart';
import 'package:fluttertoast/fluttertoast.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController idController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController passwordCheckController = TextEditingController();


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _PWobscureText = true;
  bool _PWChkobscureText = true;
  final _RegisterFormkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Padding(
            padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _RegisterFormkey,
            child: ListView(
              children: [
                CustomLogo('회원가입하자'),
                const SizedBox(height: 32,),
                const Text('이름'),
                TextFormField(
                  controller: nameController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      labelText: 'name',
                      hintText: '이름을 입력해주세요.',
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.orangeAccent)
                      )
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return '이름을 입력해주세요!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16,),
                const Text("아이디"),
                TextFormField(
                  controller: idController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      labelText: 'id',
                      hintText: '아이디를 입력해주세요.',
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.orangeAccent)
                      )
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return '아이디를 입력해주세요!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16,),
                const Text("패스워드"),
                TextFormField(
                  controller: passwordController,
                  obscureText: _PWobscureText,
                  decoration: InputDecoration(
                    labelText: 'password',
                    hintText: '비밀번호를 입력해주세요.',
                    border: const OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.orangeAccent)
                    ),
                    suffixIcon: IconButton( // 눈 모양 아이콘 버튼
                      icon: Icon(
                        _PWobscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _PWobscureText = !_PWobscureText; // 상태 반전
                        });
                      },
                    ),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return '비밀번호를 입력해주세요!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16,),
                const Text("패스워드확인"),
                TextFormField(
                  controller: passwordCheckController,
                  obscureText: _PWChkobscureText,
                  decoration: InputDecoration(
                    labelText: 'password',
                    hintText: '비밀번호를 한 번 더 입력해주세요.',
                    border: const OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.orangeAccent)
                    ),
                    suffixIcon: IconButton( // 눈 모양 아이콘 버튼
                      icon: Icon(
                        _PWChkobscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _PWChkobscureText = !_PWChkobscureText; // 상태 반전
                        });
                      },
                    ),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return '비밀번호를 입력해주세요!';
                    } else if(value != passwordController.text){
                      return '비밀번호가 일치하지 않습니다.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: (){
                        if (_RegisterFormkey.currentState!.validate()){
                          _registerUser();
                          print('ID: ${idController.text}, Password: ${passwordController.text}');
                        }
                      },
                      child: const Text("Sign Up  ")),
                )

              ],

            )
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    try{
      var url = 'http://192.168.163.1:3000/register';
      var dio = Dio();

      Map<String, dynamic> userData = {
        'name': nameController.text,
        'id': idController.text,
        'password': passwordController.text,
      };

      Response response = await dio.post(
        url,
        data: userData,
      );
      if(response.statusCode == 200){
        StateToast('회원가입 성공: ${response.data}');
      } else{
        StateToast('회원가입 실패: ${response.statusCode}, ${response.data}');
      }
    } catch(e){
      StateToast(e);
    };
  }
}

void StateToast(msg){
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT, // 또는 Toast.LENGTH_LONG
    gravity: ToastGravity.BOTTOM, // 또는 ToastGravity.TOP, ToastGravity.CENTER 등
    timeInSecForIosWeb: 1, // iOS 및 웹에서 지속 시간 (초)
    backgroundColor: Colors.grey,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

