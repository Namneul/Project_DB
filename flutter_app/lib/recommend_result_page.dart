import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:untitled/detail_page.dart';
import 'parseRecipeSteps.dart';

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

          // 안전하게 여러 경우 대비!
          String menuName = item['menuName'] ??
              item['메뉴이름'] ??
              item['메뉴 이름'] ??
              '이름 없음';
          String methodCategory = item['methodCategory'] ??
              item['방법분류'] ??
              item['방법 분류'] ??
              '';
          String countryCategory = item['countryCategory'] ??
              item['국가분류'] ??
              item['국가 분류'] ??
              '';
          String difficulty = item['difficulty'] ??
              item['난이도분류'] ??
              item['난이도 분류'] ??
              '';
          String mainIngredients = item['mainIngredients'] ??
              item['주재료이름'] ??
              item['주재료 이름'] ??
              '';
          // 레시피는 문자열이든 리스트든 string으로 변환 후 파싱
          String rawRecipe = (item['recipe'] ??
              item['레시피'] ??
              '')
              .toString();
          rawRecipe =
              rawRecipe.replaceAll(RegExp(r'^\[|\]$'), '');
          List<String> recipeSteps = parseRecipeSteps(rawRecipe);

          // 유사도 값도 여러 경우 대비
          String similarity = (item['similarity'] ??
              item['유사도'] ??
              '').toString();

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: ListTile(
              leading: Icon(Icons.star, color: orange, size: 32),
              title: Text(menuName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('유사도: $similarity'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(
                      menuName: menuName,
                      methodCategory: methodCategory,
                      countryCategory: countryCategory,
                      difficulty: difficulty,
                      mainIngredients: mainIngredients,
                      recipe: recipeSteps,
                      // 필요하다면 더 많은 데이터 전달
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
