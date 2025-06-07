List<String> parseRecipeSteps(String raw) {
  final regex = RegExp(r'(\d+\.\s*)');
  final matches = regex.allMatches(raw);

  if (matches.isEmpty) return [raw.trim()];

  List<String> steps = [];
  int start = 0;

  for (var i = 0; i < matches.length; i++) {
    final match = matches.elementAt(i);
    if (i > 0) {
      steps.add(raw.substring(start, match.start).trim());
    }
    start = match.start;
  }
  steps.add(raw.substring(start).trim());

  // 여기서 끝부분 정리!
  return steps
      .map((s) =>
      s.replaceFirst(RegExp(r'^\d+\.\s*'), '')
          .replaceAll(RegExp(r"[',\s]+$"), '') // <- 쉼표, 따옴표, 공백 다 제거
  )
      .where((s) => s.isNotEmpty)
      .toList();
}
