// import 'package:asseigment/data/models/favorite_model.dart';
// import 'package:asseigment/data/repositories/favorites_repository.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class FavoritesController extends GetxController {
//   final FavoritesRepository repo;

//   FavoritesController(this.repo);

//   final favorites = <FavoriteQuoteModel>[].obs;
//   final isLoading = false.obs;

//   String get userId =>
//       Supabase.instance.client.auth.currentUser!.id;

//   @override
//   void onInit() {
//     loadFavorites();
//     super.onInit();
//   }

//   Future<void> loadFavorites() async {
//     isLoading.value = true;
//     favorites.value = await repo.getFavorites(userId);
//     isLoading.value = false;
//   }

//   bool isFavorite(String quoteId) {
//     return favorites.any((q) => q.quoteId == quoteId);
//   }

//   Future<void> toggleFavorite({
//     required String quoteId,
//     required String quote,
//     required String author,
//     required List<String> categories,
//   }) async {
//     if (isFavorite(quoteId)) {
//       await repo.removeFavorite(
//         userId: userId,
//         quoteId: quoteId,
//       );
//       favorites.removeWhere((q) => q.quoteId == quoteId);
//     } else {
//       await repo.addFavorite(
//         userId: userId,
//         quoteId: quoteId,
//         quote: quote,
//         author: author,
//         categories: categories,
//       );
//       await loadFavorites();
//     }
//   }
// }
