class ParsedMention {
  final String id;
  final String display;

  ParsedMention(this.id, this.display);
}

List<ParsedMention> parseMentions(String markup) {
  final regex = RegExp(r'@\[([^\]]+)\]\(([^)]+)\)');
  return regex.allMatches(markup).map((m) {
    return ParsedMention(
      m.group(2)!, // id
      m.group(1)!, // display
    );
  }).toList();
}
