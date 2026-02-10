// import 'package:asseigment/core/data/models/favorite_model.dart';
// import 'package:asseigment/core/data/repositories/favorites_repository.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import '../../../core/data/models/quote_model.dart';
// import '../../../core/data/repositories/quote_repository.dart';

// class HomeController extends GetxController {
//   final QuoteRepository repository;
//   final FavoritesRepository favoritesRepo;

//   HomeController(this.repository, this.favoritesRepo);

//   // ===== Data =====
//   final quotes = <QuoteModel>[].obs;
//   final isLoading = false.obs;
//   final isFetchingMore = false.obs;

//   // ===== Filters =====
//   final selectedCategory = 'All'.obs;

//   // ===== Favorites =====
//   final favorites = <FavoriteQuoteModel>[].obs;

//   // ===== Static Categories =====
//   final categories = [
//     'All',
//     'wisdom',
//     'philosophy',
//     'life',
//     'truth',
//     'inspirational',
//     'relationships',
//     'love',
//     'faith',
//     'humor',
//     'success',
//     'courage',
//     'happiness',
//     'art',
//     'writing',
//     'fear',
//     'nature',
//     'time',
//     'freedom',
//     'death',
//     'leadership',
//   ];

//   // ===== Pagination =====
//  // int currentOffset = 0;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchQuotes(refresh: true);
//     loadFavorites();
//   }

//   // ===== Fetch Quotes =====
//   Future<void> fetchQuotes({bool refresh = false}) async {
//     if (isLoading.value || isFetchingMore.value) return;

//     if (refresh) {
//       quotes.clear();
//      // currentOffset = 0;
//       isLoading.value = true;
//     } else {
//       isFetchingMore.value = true;
//     }

//     try {
//       final result = await repository.fetchRandomQuotes(
//         category: selectedCategory.value != 'All'
//             ? selectedCategory.value
//             : null,
//         limit: 100,
       
//       );
      
//       quotes.addAll(result);
//     } catch (e) {
//       Get.snackbar("Error", "Fetching: $e");
//     } finally {
//       isLoading.value = false;
//       isFetchingMore.value = false;
//     }
//   }

//   // ===== Change Category =====
//   void changeCategory(String category) {
//     selectedCategory.value = category;
//     fetchQuotes(refresh: true);
//   }

//   // ===== Favorites =====
//   Future<void> loadFavorites() async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) {
//       Get.snackbar("Error", "Please sign in to view favorites.");
//       return;
//     }
//     final result = await favoritesRepo.getFavorites(userId);
//     favorites.assignAll(result);
//   }

//   bool isFavorite(String quoteId) {
//     return favorites.any((f) => f.quoteId == quoteId);
//   }

//   Future<void> toggleFavorite(String quoteId) async {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) {
//       Get.snackbar("Error", "Please sign in to manage favorites.");
//       return;
//     }
//     final quote = quotes.firstWhere((q) => q.id == quoteId);

//     if (isFavorite(quoteId)) {
//       await favoritesRepo.removeFavorite(userId: userId, quoteId: quoteId);
//       favorites.removeWhere((f) => f.quoteId == quoteId);
//     } else {
//       final fav = await favoritesRepo.addFavorite(userId: userId, quote: quote);
//       favorites.add(fav);
//     }
//   }



//   // ===== Toggle Filters UI =====
//   final showFilters = false.obs;
//   void toggleFilters() => showFilters.value = !showFilters.value;
// }
