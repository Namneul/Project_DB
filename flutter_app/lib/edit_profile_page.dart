import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String currentId;
  final String currentPW;
  final String currentEmail;

  const EditProfilePage({
    super.key,
    required this.currentId,
    required this.currentPW,
    required this.currentEmail
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _IdController;
  late TextEditingController _PWController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _IdController = TextEditingController();
    _PWController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _IdController.dispose();
    _PWController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 정보 수정'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _IdController,
              decoration:  InputDecoration(
                labelText: '아이디',
                hintText: widget.currentId,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _PWController,
              decoration:  InputDecoration(
                labelText: '비밀번호',
                hintText: widget.currentPW,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration:  InputDecoration(
                labelText: '이메일',
                hintText: widget.currentEmail,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // 수정된 정보를 이전 페이지로 전달
                Navigator.pop(context, {
                  'id': _IdController.text,
                  'password':_PWController.text,
                  'email': _emailController.text,
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '저장',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}