import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation_project_nti/core/data/models/collection_model.dart';
import 'package:graduation_project_nti/core/data/models/favorite_model.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';
import 'package:graduation_project_nti/core/data/models/user_model.dart';

class FavoritesRemoteDataSource {
  FavoritesRemoteDataSource({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get currentUserId => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _profiles =>
      _firestore.collection('profiles');

  CollectionReference<Map<String, dynamic>> get _favorites =>
      _profiles.doc(currentUserId).collection('favorites');

  CollectionReference<Map<String, dynamic>> get _collections =>
      _profiles.doc(currentUserId).collection('collections');

  Future<void> addProfile({
    required String uid,
    required String name,
    required String email,
  }) {
    return _profiles.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
    }, SetOptions(merge: true));
  }

  Future<UserModel?> getProfile() async {
    final doc = await _profiles.doc(currentUserId).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    await _profiles.doc(currentUserId).set({
      'uid': currentUserId,
      'name': name,
      'email': email,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<FavoriteQuoteModel>> watchFavorites() {
    return _favorites.orderBy('created_at', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map(
            (doc) => FavoriteQuoteModel.fromJson({'id': doc.id, ...doc.data()}),
          )
          .toList();
    });
  }

  Future<void> toggleFavorite(QuoteModel quote) async {
    final docRef = _favorites.doc(quote.id);
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
      return;
    }
    await docRef.set({
      'quote_id': quote.id,
      'quote': quote.quote,
      'author': quote.author,
      'categories': quote.categories,
      'created_at': FieldValue.serverTimestamp(),
    });
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
