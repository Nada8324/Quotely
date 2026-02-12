class QuoteModel {
  final String id;
  final String quote;
  final String author;
  final String work;
  final List<String> categories;

  QuoteModel({
    required this.id,
    required this.quote,
    required this.author,
    required this.work,
    required this.categories,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    final quote = json['quote'] ?? '';
    final author = json['author'] ?? '';

    return QuoteModel(
      id: '${quote}_$author'.hashCode.toString(),
      quote: quote,
      author: author,
      work: json['work'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
    );
  }
}
