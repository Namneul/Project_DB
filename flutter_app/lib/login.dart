import 'package:flutter/material.dart';
import 'package:untitled/register.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/userProfile.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  bool _obscureText = true;
  final _LoginFormkey = GlobalKey<FormState>();

  late final TextEditingController idController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.deepOrange[400];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        )
            : null,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Form(
            key: _LoginFormkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🎨 상단 일러스트 & WELCOME BACK!
                Column(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: Colors.grey[200],
                      child: Icon(Icons.person, color: Colors.grey[500], size: 64),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "WELCOME BACK!",
                      style: TextStyle(
                        color: orange,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("아이디", style: TextStyle(fontSize: 16, color: orange, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: idController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: 'ID',
                    hintText: '아이디를 입력해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return '아이디를 입력해주세요!';
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("비밀번호", style: TextStyle(fontSize: 16, color: orange, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: 'Password',
                    hintText: '비밀번호를 입력해주세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return '비밀번호를 입력해주세요!';
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      elevation: 2,
                    ),
                    onPressed: () {
                      if (_LoginFormkey.currentState!.validate()) {
                        _loginUser();
                      }
                    },
                    child: const Text("로그인"),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: orange!, width: 1.4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      textStyle: const TextStyle(fontSize: 17),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text("회원가입", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loginUser() async {
    try {
      var url = 'http://172.30.1.7:3000/login';
      var dio = Dio();

      Map<String, dynamic> userData = {
        'id': idController.text,
        'password': passwordController.text,
      };

      Response response = await dio.post(
        url,
        data: userData,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['token'];
        final userId = response.data['user']['id'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString('userId', userId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 성공!')),
        );

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserProfilePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 실패: 아이디 또는 비밀번호를 확인하세요')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 중 에러: $e')),
      );
    }
  }
}
