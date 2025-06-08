import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/detail_page.dart';
import 'package:untitled/parseRecipeSteps.dart';


class LikedRecipesPage extends StatefulWidget {
  const LikedRecipesPage({Key? key}) : super(key: key);

  @override
  State<LikedRecipesPage> createState() => _LikedRecipesPageState();
}

class _LikedRecipesPageState extends State<LikedRecipesPage> {
  List<dynamic>? likedRecipes;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchLikedRecipes();
  }

  Future<void> _fetchLikedRecipes() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null) {
        setState(() {
          error = "로그인이 필요합니다.";
          isLoading = false;
        });
        return;
      }

      final dio = Dio();
      final url = 'http://172.30.1.7:3000/liked-recipes'; // 서버 엔드포인트에 맞게!
      final response = await dio.post(url, data: {'userId': userId});

      if (response.statusCode == 200 && response.data['success'] == true) {
        setState(() {
          likedRecipes = response.data['data']; // [{메뉴 이름, ...}, ...]
          isLoading = false;
        });
      } else {
        setState(() {
          error = response.data['message'] ?? '불러오기 실패';
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
        title: const Text('좋아요 누른 레시피'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : (likedRecipes == null || likedRecipes!.isEmpty)
          ? const Center(child: Text('좋아요 누른 레시피가 없습니다.'))
          : ListView.builder(
        itemCount: likedRecipes!.length,
        itemBuilder: (context, idx) {
          var item = likedRecipes![idx];
          // 실제 데이터 키에 맞게 수정 (예시: '메뉴 이름', '난이도 분류' 등)
          String menuName = item['메뉴 이름'] ?? '이름 없음';
          String methodCategory = (item['방법 분류'] is List)
              ? (item['방법 분류'] as List).join(', ')
              : item['방법 분류']?.toString() ?? '분류 없음';
          String countryCategory = item['국가 분류'] ?? '국가 없음';
          String difficulty = item['난이도 분류'] ?? '난이도 없음';
          String mainIngredients = (item['주재료 이름'] is List)
              ? (item['주재료 이름'] as List).join(', ')
              : item['주재료 이름']?.toString() ?? '주재료 없음';
          String rawRecipe = item['레시피'];
          rawRecipe = rawRecipe.replaceAll(RegExp(r'^\[|\]$'), '');
          List<String> recipeSteps = parseRecipeSteps(rawRecipe);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: ListTile(
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, size: 32, color: Colors.grey),
              ),
              title: Text(menuName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('분류: $methodCategory ($countryCategory)'),
                  Text('난이도: $difficulty'),
                  Text('주재료: $mainIngredients'),
                ],
              ),
              onTap: () {
                // DetailPage로 이동!
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

  // 너가 쓰는 레시피 파싱 함수
  List<String> _parseRecipeSteps(String rawRecipe) {
    // [1. ~, 2. ~] 형식 -> 리스트로 변환 (커스텀 구현 가능)
    rawRecipe = rawRecipe.replaceAll(RegExp(r'^\[|\]$'), '');
    return rawRecipe.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
}
