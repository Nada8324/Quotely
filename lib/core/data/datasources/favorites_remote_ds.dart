// import 'package:asseigment/core/data/models/favorite_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FavoritesRemoteDataSource {
//   final FirebaseFirestore firestore;

//   FavoritesRemoteDataSource(this.firestore);

//   Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
//     final snapshot = await firestore
//         .collection('favorites')
//         .where('user_id', isEqualTo: userId)
//         .get();

//     return snapshot.docs
//         .map((doc) => {
//               'id': doc.id,
//               ...doc.data(),
//             })
//         .toList();
//   }

//   Future<FavoriteQuoteModel> addFavorite({
//     required String userId,
//     required String quoteId,
//     required String quote,
//     required String author,
//     required List<String> categories,
//   }) async {
//     final doc = await firestore.collection('favorites').add({
//       'user_id': userId,
//       'quote_id': quoteId,
//       'quote': quote,
//       'author': author,
//       'categories': categories,
//     });

//     final saved = await doc.get();

//     return FavoriteQuoteModel.fromJson({
//       'id': saved.id,
//       ...saved.data() ?? {},
//     });
//   }

//   Future<void> removeFavorite({
//     required String userId,
//     required String quoteId,
//   }) async {
//     final snapshot = await firestore
//         .collection('favorites')
//         .where('user_id', isEqualTo: userId)
//         .where('quote_id', isEqualTo: quoteId)
//         .get();

//     for (final doc in snapshot.docs) {
//       await doc.reference.delete();
//     }
//   }
// }
