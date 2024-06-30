class Word {
  String word;
  String text;
  String partOf;
  List<String> definitions;
  String audio;

  Word(this.word, this.text, this.partOf, this.definitions, this.audio);

  factory Word.fromJson(Map<String, dynamic> json) {
    var wd = json["word"] as String? ?? "";
    var text = json["phonetic"] as String? ?? "";
    var part = json["meanings"]?[0]?["partOfSpeech"] as String? ?? "";
    var definitions = <String>[];
    if (json["meanings"] != null) {
      for (var meaning in json["meanings"]) {
        if (meaning["definitions"] != null) {
          definitions.addAll(
              (meaning["definitions"] as List).map((def) => def["definition"] as String).toList());
        }
      }
    }
    var audio = json["phonetics"]?[1]?["audio"] as String? ?? "";

    return Word(wd, text, part, definitions, audio);
  }
}
