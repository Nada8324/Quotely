class FavoriteQuoteModel {
  final String id; 
  final String quoteId;
  final String quote;
  final String author;
  final List<String> categories;

  FavoriteQuoteModel({
    required this.id,
    required this.quoteId,
    required this.quote,
    required this.author,
    required this.categories,
  });

  factory FavoriteQuoteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteQuoteModel(
      id: json['id'],
      quoteId: json['quote_id'],
      quote: json['quote'],
      author: json['author'],
      categories: List<String>.from(json['categories'] ?? []),
    );
  }
}
