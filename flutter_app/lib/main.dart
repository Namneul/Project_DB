import 'package:flutter/material.dart';
import 'search_page.dart'; // 요리 검색 화면
import 'recommendation_page.dart'; // 레시피 추천 화면

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RecipeHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RecipeHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '자취의 신',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Colors.white, // 완전 흰색 배경
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 80, color: Colors.deepOrange),
            const SizedBox(height: 10),
            const Text(
              '자취생을 위한 레시피 추천 앱',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 요리 검색 버튼
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                  child: buildMenuButton(Icons.search, '요리 검색'),
                ),
                const SizedBox(width: 10),
                // 레시피 추천 버튼
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecommendationPage()),
                    );
                  },
                  child: buildMenuButton(Icons.lightbulb_outline, '레시피 추천'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuButton(IconData icon, String label) {
    return Container(
      width: 120,
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFFBE3B8), // 버튼 배경색
        border: Border.all(color: Colors.deepOrange),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.deepOrange, size: 30),
          SizedBox(height: 10),
          Text(label, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
