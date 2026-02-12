import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteQuoteModel {
  final String quoteId;
  final String quote;
  final String author;
  final List<String> categories;
  final DateTime? createdAt;

  FavoriteQuoteModel({
    required this.quoteId,
    required this.quote,
    required this.author,
    required this.categories,
    this.createdAt,
  });

  factory FavoriteQuoteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteQuoteModel(
      quoteId: json['quote_id'],
      quote: json['quote'],
      author: json['author'],
      categories: List<String>.from(json['categories'] ?? []),
      createdAt: (json['created_at'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quote_id': quoteId,
      'quote': quote,
      'author': author,
      'categories': categories,
      if (createdAt == null) 'created_at': FieldValue.serverTimestamp()
      else 'created_at':createdAt,
    };
  }
}
