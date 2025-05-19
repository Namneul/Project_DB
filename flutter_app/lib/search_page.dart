import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.deepOrange[300], // 좀 더 연한 주황색 배경
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '검색어를 입력하세요',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text('검색 결과 영역'),
      ),
    );
  }
}
