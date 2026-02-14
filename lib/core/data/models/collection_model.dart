import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteCollectionModel {
  final String id;
  final String name;
  final List<String> quoteIds;
  final DateTime? createdAt;

  const QuoteCollectionModel({
    required this.id,
    required this.name,
    required this.quoteIds,
    this.createdAt,
  });

  factory QuoteCollectionModel.fromJson(Map<String, dynamic> json) {
    return QuoteCollectionModel(
      id: json['id'],
      name: json['name'],
      quoteIds: List<String>.from(json['quote_ids'] ?? const []),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quote_ids': quoteIds,
      'created_at': FieldValue.serverTimestamp(),
    };
  }
}