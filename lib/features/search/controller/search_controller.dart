// import 'package:asseigment/core/data/models/quote_model.dart';
// import 'package:asseigment/core/data/repositories/quote_repository.dart';
// import 'package:asseigment/features/home/controller/home_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// class SearchController extends GetxController {
//   final QuoteRepository repository;
//   final HomeController homeController = Get.find(); 

//   SearchController(this.repository);

//   // ===== Data =====
//   final searchResults = <QuoteModel>[].obs; // قائمة نتائج البحث من الـ API
//   final isLoading = false.obs;

//   // ===== Filters =====
//   final selectedCategory = 'All'.obs;
//   final searchKeyword = ''.obs;
//   final searchCtrl = TextEditingController();
//   final showFilters = false.obs;
//    final isFetchingMore = false.obs;
//   // ===== Pagination =====
//   int currentOffset = 0;
//   @override
//   void onInit() {
//     super.onInit();
//     // جلب بيانات أولية عند فتح الشاشة أو تركها فارغة حتى يبحث المستخدم
//     fetchSearchResults(); 
//   }

//   // ===== Fetch from API =====
//   Future<void> fetchSearchResults({bool refresh = false}) async {
//     if (isLoading.value || isFetchingMore.value) return;

//     if (refresh) {
//       searchResults.clear();
//       currentOffset = 0;
//       isLoading.value = true;
//     } else {
//       isFetchingMore.value = true;
//     }

//     try {
//       final result = await repository.fetchQuotes(
//         category: selectedCategory.value != 'All'
//             ? selectedCategory.value
//             : null,
//         limit: 10,
//         offset: currentOffset,
//       );
//       currentOffset += 10;
//       searchResults.addAll(result);
//     } catch (e) {
//       Get.snackbar("Error", "Fetching: $e");
//     } finally {
//       isLoading.value = false;
//       isFetchingMore.value = false;
//     }
//   }


//   List<QuoteModel> get filteredQuotes {
//     return searchResults.where((q) {
//       final matchesSearch = q.quote.toLowerCase().contains(searchKeyword.value.toLowerCase());
//       return matchesSearch;
//     }).toList();
//   }

//   void changeCategory(String category) {
//     selectedCategory.value = category;
//     fetchSearchResults(); // اطلب من الـ API فور تغيير التصنيف
//   }

//   void toggleFilters() => showFilters.value = !showFilters.value;
//   void clearSearch() {
//     searchKeyword.value = '';
//     searchCtrl.clear();
//   }

//   bool isFavorite(String id) => homeController.isFavorite(id);
//   void toggleFavorite(String id) => homeController.toggleFavorite(id);
// }