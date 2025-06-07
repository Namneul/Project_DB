import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // FontAwesomeIcons 사용을 위해
import 'package:untitled/edit_profile_page.dart'; // 수정 페이지 import
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/main.dart';


late final changedId;
late final changedPW;
late final changedEmail;

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // 예시 사용자 데이터 (실제로는 백엔드에서 가져오거나 상태 관리로 처리)
  String _userId = "changwoo";
  String _userPW = "1234";
  String _userEmail = "Koreanmanchangwoo.com";

  // 회원 정보 업데이트 콜백 함수
  void _updateUserProfile({String? id, String? password, String? email}) {
    setState(() {
      if (id != null) changedId = id;
      if (password != null) changedPW = password;
      if (email != null) changedEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 프로필 사진
            GestureDetector(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.grey,
                    ),
                    backgroundColor: Colors.grey[200],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 사용자 이름
            Text(
              _userId,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // 사용자 이메일
            Text(
              _userEmail,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),

            // 프로필 옵션 목록
            _buildProfileOption(
              icon: FontAwesomeIcons.userEdit, // FontAwesomeIcons 사용
              title: '회원 정보 수정',
              onTap: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      currentId: _userId,
                      currentPW: _userPW,
                      currentEmail: _userEmail,
                    ),
                  ),
                );
                if (updatedData != null) {
                  _updateUserProfile(
                    id: updatedData['id'],
                    password: updatedData['password'],
                    email: updatedData['email'],
                  );
                }
              },
            ),
            _buildDivider(),
            _buildProfileOption(
              icon: FontAwesomeIcons.heart, // FontAwesomeIcons 사용
              title: '좋아요 누른 게시글',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('좋아요 누른 게시글 페이지로 이동 (구현 예정)')),
                );
                // Navigator.push(context, MaterialPageRoute(builder: (context) => LikedPostsPage()));
              },
            ),
            _buildDivider(),
            _buildProfileOption(
              icon: Icons.settings,
              title: '설정',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('설정 페이지로 이동 (구현 예정)')),
                );
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
            _buildDivider(),
            _buildProfileOption(
              icon: Icons.logout,
              title: '로그아웃',
              textColor: Colors.red,
              onTap: () => _logout(context), // 여기!
            ),
          ],
        ),
      ),
    );
  }

  // 프로필 옵션 항목을 위한 위젯
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = Colors.black,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.grey[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // 구분선 위젯
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
      color: Colors.grey,
    );
  }
}

Future<void> _modifyUser() async{
  try{
    var url = 'http:// 192.168.50.15:3000/user';
    var dio = Dio();
    Map<String, dynamic> userData = {
      'id': changedId,
      'password': changedPW,
    };

  } catch(e){
    print(e);
  }
}

void _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwt_token');
  // 로그인 화면으로 이동, 뒤로가기 막기 (pushAndRemoveUntil)
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => MyApp()),
        (route) => false,
  );
}
