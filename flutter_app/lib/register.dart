import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

// 컨트롤러는 각 입력란마다 할당
final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController idController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController passwordCheckController = TextEditingController();

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _PWobscureText = true;
  bool _PWChkobscureText = true;
  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _registerFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 프로필 기본 아이콘
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    size: 64,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Text(
                "Welcome!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
              const SizedBox(height: 24),

              // 이름
              _buildInputField(
                label: '이름',
                controller: nameController,
                icon: FontAwesomeIcons.user,
                validator: (v) => v == null || v.isEmpty ? '이름을 입력해주세요!' : null,
              ),
              const SizedBox(height: 16),

              // 이메일
              _buildInputField(
                label: '이메일',
                controller: emailController,
                icon: FontAwesomeIcons.envelope,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || v.isEmpty ? '이메일을 입력해주세요!' : null,
              ),
              const SizedBox(height: 16),

              // 아이디
              _buildInputField(
                label: '아이디',
                controller: idController,
                icon: FontAwesomeIcons.idBadge,
                validator: (v) => v == null || v.isEmpty ? '아이디를 입력해주세요!' : null,
              ),
              const SizedBox(height: 16),

              // 비밀번호
              _buildInputField(
                label: '비밀번호',
                controller: passwordController,
                icon: FontAwesomeIcons.lock,
                obscureText: _PWobscureText,
                suffixIcon: IconButton(
                  icon: Icon(_PWobscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _PWobscureText = !_PWobscureText),
                ),
                validator: (v) => v == null || v.isEmpty ? '비밀번호를 입력해주세요!' : null,
              ),
              const SizedBox(height: 16),

              // 비밀번호 확인
              _buildInputField(
                label: '비밀번호 확인',
                controller: passwordCheckController,
                icon: FontAwesomeIcons.lock,
                obscureText: _PWChkobscureText,
                suffixIcon: IconButton(
                  icon: Icon(_PWChkobscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _PWChkobscureText = !_PWChkobscureText),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return '비밀번호를 다시 입력해주세요!';
                  if (v != passwordController.text) return '비밀번호가 일치하지 않습니다.';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(FontAwesomeIcons.userPlus),
                  label: const Text('회원가입', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.orangeAccent,
                  ),
                  onPressed: () {
                    if (_registerFormKey.currentState!.validate()) {
                      _registerUser();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.orangeAccent),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Future<void> _registerUser() async {
    try {
      var url = 'http://192.168.163.1:3000/register';
      var dio = Dio();
      Map<String, dynamic> userData = {
        'name': nameController.text,
        'email': emailController.text,
        'id': idController.text,
        'password': passwordController.text,
      };

      Response response = await dio.post(url, data: userData);
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        StateToast('회원가입 성공: ${response.data}');
        // 필요시 Navigator.pop(context);
      } else {
        StateToast('회원가입 실패: ${response.statusCode}, ${response.data}');
      }
    } catch (e) {
      StateToast('에러 발생: $e');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    idController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
    super.dispose();
  }
}

void StateToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey[800],
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
