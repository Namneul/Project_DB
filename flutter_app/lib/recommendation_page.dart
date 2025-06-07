import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:untitled/detailPage.dart';
import 'package:untitled/parseRecipeSteps.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  late final TextEditingController _ingredientController;
  final List<String> ingredients = [];
  List<dynamic>? searchResults;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _ingredientController = TextEditingController();
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final text = _ingredientController.text.trim();
    if (text.isNotEmpty && !ingredients.contains(text)) {
      setState(() {
        ingredients.add(text);
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      ingredients.remove(ingredient);
    });
  }

  Future<void> _searchRecipeByIngredients() async {
    if (ingredients.isEmpty) return;

    setState(() {
      isLoading = true;
      error = null;
      searchResults = null;
    });

    try {
      var url = 'http://192.168.50.15:3000/recommendFood'; // 서버 라우트는 네가 맞게!
      var dio = Dio();

      Map<String, dynamic> searchData = {
        'ingredients': ingredients, // 예: ["계란", "양파", "당근"]
      };

      Response response = await dio.post(
        url,
        data: searchData,
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        var receivedData = response.data['data'];
        if (receivedData != null && receivedData is List) {
          setState(() {
            searchResults = receivedData;
            isLoading = false;
          });
        } else {
          setState(() {
            error = "검색 결과가 없거나 서버 응답 형식이 다릅니다.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = "서버 오류: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "에러 발생: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _ingredientController,
                  onSubmitted: (value) => _addIngredient(),
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.add, color: Colors.deepOrange),
                    hintText: '재료를 입력하고 엔터!',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              tooltip: "이 재료들로 레시피 찾기",
              onPressed: ingredients.isNotEmpty ? _searchRecipeByIngredients : null,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 입력된 재료들
            ingredients.isNotEmpty
                ? Wrap(
              spacing: 10,
              runSpacing: 6,
              children: ingredients
                  .map((ing) => Chip(
                label: Text(ing),
                backgroundColor: Colors.deepOrange[50],
                deleteIcon: Icon(Icons.cancel, color: Colors.deepOrange),
                onDeleted: () => _removeIngredient(ing),
              ))
                  .toList(),
            )
                : Text(
              "재료를 입력해 주세요.",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 22),

            // 검색 결과 표시
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                  ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
                  : (searchResults == null || searchResults!.isEmpty)
                  ? const Center(child: Text('여기에 추천 레시피가 표시됩니다.', style: TextStyle(fontSize: 18)))
                  : ListView.builder(
                itemCount: searchResults!.length,
                itemBuilder: (context, index) {
                  var item = searchResults![index];
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
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder:
                            (context) => DetailPage(
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
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.image,
                          size: 32,
                          color: Colors.grey,
                        ),
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
        onPressed: _addIngredient,
        tooltip: "재료 추가",
      ),
    );
  }
}
