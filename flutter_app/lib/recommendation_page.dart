import 'package:flutter/material.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  late final TextEditingController _ingredientController;
  final List<String> ingredients = [];

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
            controller: _ingredientController,
            onSubmitted: (value) => _addIngredient(),
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: Colors.grey),
              hintText: '재료를 입력하고 엔터!',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 입력된 재료들을 Chip으로 보여주기
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

            // 추천 레시피 영역
            Expanded(
              child: Center(
                child: Text(
                  '여기에 추천 레시피가 표시됩니다.',
                  style: TextStyle(fontSize: 18),
                ),
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
