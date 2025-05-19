import 'package:flutter/material.dart';
import 'package:untitled/widget/logo.dart';
import 'package:dio/dio.dart';

final TextEditingController idController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  bool _obscureText = true;
  final _LoginFormkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _LoginFormkey,
            child: ListView(
              children: [
                CustomLogo(''),
                const SizedBox(height: 32,),
                const Text("id"),
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
                const Text("password"),
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                      labelText: 'password',
                      hintText: '비밀번호를 입력해주세요.',
                      border: const OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.orangeAccent)
                      ),
                    suffixIcon: IconButton( // 눈 모양 아이콘 버튼
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText; // 상태 반전
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
                const SizedBox(height: 32,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: (){
                        if (_LoginFormkey.currentState!.validate()){
                          print('ID: ${idController.text}, Password: ${passwordController.text}');
                        }
                      },
                      child: const Text("Sign In")),
                )
              ],
            ),
          ),
        )

      ),
    );
  }

  Future<void> _loginUser() async {
    try{
      var url = 'http://192.168.163.1:3000/register';
      var dio = Dio();

      Map<String, dynamic> userData = {
        'id': idController.text,
        'password': passwordController.text,
      };

      Response response = await dio.post(
        url,
        data: userData,
      );
      if(response.statusCode == 200){
      } else{

      }
    } catch(e){
      print(e);
    };
  }



@override
  void dispose(){
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}