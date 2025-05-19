import 'package:flutter/material.dart';

class RecommendationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: Colors.grey),
              hintText: '레시피를 검색하세요',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          '여기에 추천 레시피가 표시됩니다.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
