abstract class EmailExtractor {
  List<String> extractEmails(String text);
}

class RegexEmailExtractor implements EmailExtractor {
  final RegExp _emailPattern = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
  );

  @override
  List<String> extractEmails(String text) {
    final matches = _emailPattern.allMatches(text);
    return matches.map((match) => match.group(0)!).toList();
  }
}
