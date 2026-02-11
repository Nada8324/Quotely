class FavoriteQuoteModel {
  final String id; 
  final String quoteId;
  final String quote;
  final String author;
  final List<String> categories;
    final DateTime? createdAt;

  FavoriteQuoteModel({
    required this.id,
    required this.quoteId,
    required this.quote,
    required this.author,
    required this.categories, this.createdAt,
  });

  factory FavoriteQuoteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteQuoteModel(
      id: json['id'] as String,
      quoteId: json['quote_id'] as String,
      quote: json['quote'] as String? ?? '',
      author: json['author'] as String? ?? '',
      categories: List<String>.from(json['categories'] ?? const []),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quote_id': quoteId,
      'quote': quote,
      'author': author,
      'categories': categories,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
