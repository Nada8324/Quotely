import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation_project_nti/core/data/models/collection_model.dart';
import 'package:graduation_project_nti/core/data/models/favorite_model.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';
import 'package:graduation_project_nti/core/data/models/user_model.dart';

class FavoritesRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _profiles =>
      _firestore.collection('profiles');

  CollectionReference<Map<String, dynamic>> get _favorites =>
      _profiles.doc(currentUserId).collection('favorites');

  CollectionReference<Map<String, dynamic>> get _collections =>
      _profiles.doc(currentUserId).collection('collections');

  Future<UserModel?> getProfile() async {
    final doc = await _profiles.doc(currentUserId).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }

  Stream<List<FavoriteQuoteModel>> watchFavorites() {
    return _favorites.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return FavoriteQuoteModel.fromJson(data);
      }).toList();
    });
  }

  Future<void> toggleFavorite(QuoteModel quote) async {
    final docRef = _favorites.doc(quote.id);
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
      return;
    }
    await docRef.set(
      FavoriteQuoteModel(
        quoteId: quote.id,
        quote: quote.quote,
        author: quote.author,
        categories: quote.categories,
        createdAt: null,
      ).toJson(),
    );
  }

  Stream<List<QuoteCollectionModel>> watchCollections() {
    return _collections.orderBy('created_at', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) =>
                  QuoteCollectionModel.fromJson({'id': doc.id, ...doc.data()}),
            )
            .toList();
      },
    );
  }

  Future<void> createCollection(String name) async {
    await _collections.add({
      'name': name,
      'quote_ids': <String>[],
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteCollection(String collectionId) async {
    await _collections.doc(collectionId).delete();
  }

  Future<void> toggleQuoteInCollection({
    required String collectionId,
    required String quoteId,
  }) async {
    final docRef = _collections.doc(collectionId);
    final snap = await docRef.get();
    if (!snap.exists) return;
    final data = snap.data() ?? {};
    final quoteIds = List<String>.from(data['quote_ids'] ?? const []);
    if (quoteIds.contains(quoteId)) {
      quoteIds.remove(quoteId);
    } else {
      quoteIds.add(quoteId);
    }
    await docRef.update({'quote_ids': quoteIds});
  }
}
