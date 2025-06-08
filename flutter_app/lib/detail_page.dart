import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  final String menuName;
  final String methodCategory;
  final String countryCategory;
  final String difficulty;
  final String mainIngredients;
  final List<String> recipe;

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
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isLiked = false;
  String? userId; // <-- 실제 로그인한 유저 id

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  String get recipeName => widget.menuName;

  Future<void> _toggleLike() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다!')),
      );
      return;
    }

    setState(() {
      isLiked = !isLiked;
    });

    try {
      final dio = Dio();
      final url = 'http://172.30.1.7:3000/like';

      if (isLiked) {
        // 좋아요 등록
        await dio.post(url, data: {
          'userId': userId,
          'recipeName': recipeName,
        });
      } else {
        // 좋아요 취소
        await dio.delete(url, data: {
          'userId': userId,
          'recipeName': recipeName,
        });
      }
    } catch (e) {
      setState(() {
        isLiked = !isLiked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("좋아요 처리 실패: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orange = Colors.deepOrange[400];
    final grayBg = Colors.grey[100];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuName),
        backgroundColor: orange,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? Colors.red : Colors.grey,
          size: 32,
        ),
        onPressed: _toggleLike,
        tooltip: isLiked ? "좋아요 취소" : "좋아요",
      ),
      body: Container(
        color: grayBg,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ...생략 (나머지 UI는 이전과 동일)...
                // 정보/레시피 등은 그대로!
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
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(label: "분류", value: "${widget.methodCategory} (${widget.countryCategory})"),
                        _InfoRow(label: "난이도", value: widget.difficulty),
                        _InfoRow(label: "주재료", value: widget.mainIngredients),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  '레시피',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: orange,
                  ),
                ),
                const SizedBox(height: 14),
                widget.recipe.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text("레시피 정보가 없습니다.", style: TextStyle(fontSize: 16, color: Colors.grey)),
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.recipe.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String step = entry.value;
                    final stepText = step.replaceFirst(RegExp(r'^\d+\.\s*'), '');
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
