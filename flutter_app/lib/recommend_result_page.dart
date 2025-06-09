import 'package:flutter/material.dart';
import 'package:dio/dio.dart';


class RecommendResultPage extends StatefulWidget {
  final String userId;
  const RecommendResultPage({required this.userId, Key? key}) : super(key: key);

  @override
  State<RecommendResultPage> createState() => _RecommendResultPageState();
}

class _RecommendResultPageState extends State<RecommendResultPage> {
  List<dynamic>? recommendations;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final dio = Dio();
      final url = 'http://192.168.50.15:3000/get-recommend'; // Node.js 엔드포인트
      final response = await dio.post(url, data: {'userId': widget.userId});

      if (response.statusCode == 200 && response.data['success'] == true) {
        setState(() {
          recommendations = response.data['recommendations'];
          isLoading = false;
        });
      } else {
        setState(() {
          error = response.data['error'] ?? '추천 실패';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = '네트워크 에러: $e';
        isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.deepOrange[400];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orange,
        title: const Text('추천 레시피 TOP 10'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : (recommendations == null || recommendations!.isEmpty)
          ? const Center(child: Text('추천 결과가 없습니다.'))
          : ListView.builder(
        itemCount: recommendations!.length,
        itemBuilder: (context, idx) {
          final item = recommendations![idx];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: ListTile(
              leading: Icon(Icons.star, color: orange, size: 32),
              title: Text(item['메뉴이름'] ?? '이름 없음',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('유사도: ${item['유사도']}'),
              // 필요하면 분류, 재료 등 추가!
            ),
          );
        },
      ),
    );
  }
}
