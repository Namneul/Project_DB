import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String menuName;
  final String methodCategory;
  final String countryCategory;
  final String difficulty;
  final String mainIngredients;

  final List<String> recipe; // 레시피만!


  const DetailPage({
    Key? key,
    required this.menuName,
    required this.methodCategory,
    required this.countryCategory,
    required this.difficulty,
    required this.mainIngredients,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 색상 테마
    final orange = Colors.deepOrange[400];
    final grayBg = Colors.grey[100];

    return Scaffold(
      appBar: AppBar(
        title: Text(menuName),
        backgroundColor: orange,
      ),
      body: Container(
        color: grayBg,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이미지
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.image, size: 54, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),

                // 기본 정보 카드 스타일
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(label: "분류", value: "$methodCategory ($countryCategory)"),
                        _InfoRow(label: "난이도", value: difficulty),
                        _InfoRow(label: "주재료", value: mainIngredients),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 26),

                // 레시피
                Text(
                  '레시피',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: orange,
                  ),
                ),
                const SizedBox(height: 14),
                recipe.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text("레시피 정보가 없습니다.", style: TextStyle(fontSize: 16, color: Colors.grey)),
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String step = entry.value;

                    // 숫자. 뒷부분만 추출해서 앞의 '1. '을 빼고 예쁘게 만들 수도 있음
                    // 예: '1. 내용' -> '내용'
                    // 아래처럼 정제해도 OK:
                    final stepText = step.replaceFirst(RegExp(r'^\d+\.\s*'), '');

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 숫자 부분
                          Text(
                            "${idx + 1}.",
                            style: TextStyle(
                              fontSize: 28,
                              color: orange,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // 내용 부분
                          Expanded(
                            child: Text(
                              stepText,
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 정보 row 스타일을 위한 위젯
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
