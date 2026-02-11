import 'package:flutter/material.dart' hide SearchController;

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    //final controller = Get.find<SearchController>();

    return Scaffold(
      // body: Obx(
      //   () => Container(
      //     color: const Color.fromARGB(255, 244, 243, 243),
      //     child: Column(
      //       children: [
      //         // ===== Header =====
      //         Container(
      //           padding: const EdgeInsets.only(
      //             top: 48,
      //             left: 16,
      //             right: 16,
      //             bottom: 16,
      //           ),
      //           decoration: BoxDecoration(
      //             color: Colors.white,
      //             border: Border(
      //               bottom: BorderSide(color: Colors.grey.shade300, width: 1),
      //             ),
      //           ),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               const Text('Search Quotes', style: TextStyle(fontSize: 24)),
      //               const SizedBox(height: 20),

      //               // ===== Search Bar =====
      //               Row(
      //                 children: [
      //                   Expanded(
      //                     child: Stack(
      //                       children: [
      //                         TextField(
      //                           controller: controller.searchCtrl,
      //                           onChanged: (val) =>
      //                               controller.searchKeyword.value = val,
      //                           decoration: InputDecoration(
      //                             hintText: 'Search quotes or authors...',
      //                             prefixIcon: const Icon(
      //                               Icons.search,
      //                               color: Color.fromARGB(196, 158, 158, 158),
      //                             ),
      //                             contentPadding: const EdgeInsets.symmetric(
      //                               vertical: 16,
      //                               horizontal: 16,
      //                             ),
      //                             border: OutlineInputBorder(
      //                               borderRadius: BorderRadius.circular(16),
      //                               borderSide: BorderSide(
      //                                 color: Colors.grey.shade300,
      //                               ),
      //                             ),
      //                             focusedBorder: OutlineInputBorder(
      //                               borderRadius: BorderRadius.circular(16),
      //                               borderSide: const BorderSide(
      //                                 color: primaryOrange,
      //                                 width: 2,
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                         if (controller.searchKeyword.isNotEmpty)
      //                           Positioned(
      //                             right: 0,
      //                             top: 0,
      //                             bottom: 0,
      //                             child: IconButton(
      //                               icon: const Icon(
      //                                 Icons.clear,
      //                                 color: Colors.grey,
      //                               ),
      //                               onPressed: () {
      //                                 controller.searchCtrl.clear();
      //                                 controller.clearSearch();
      //                                 FocusScope.of(context).unfocus();
      //                               },
      //                             ),
      //                           ),
      //                       ],
      //                     ),
      //                   ),
      //                   const SizedBox(width: 8),
      //                   // ===== Filter Button =====
      //                   IconButton(
      //                     icon: Icon(
      //                       LucideIcons.listFilter,
      //                       color: controller.showFilters.value
      //                           ? primaryOrange
      //                           : Colors.grey,
      //                     ),
      //                     onPressed: () => controller.toggleFilters(),
      //                     splashRadius: 24,
      //                   ),
      //                 ],
      //               ),

      //               // ===== Filters =====
      //               if (controller.showFilters.value) ...[
      //                 const SizedBox(height: 12),
      //                 Text("Category", style: TextStyle(color: Colors.grey)),
      //                 DropdownButtonFormField<String>(
      //                   value:
      //                       controller.homeController.categories.contains(
      //                         controller.selectedCategory.value,
      //                       )
      //                       ? controller.selectedCategory.value
      //                       : 'All',
      //                   decoration: InputDecoration(
      //                     contentPadding: const EdgeInsets.symmetric(
      //                       horizontal: 16,
      //                       vertical: 12,
      //                     ),
      //                     enabledBorder: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(15),
      //                       borderSide: BorderSide(
      //                         color: Colors.grey.shade300,
      //                         width: 1.5,
      //                       ),
      //                     ),
      //                     focusedBorder: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(15),
      //                       borderSide: const BorderSide(
      //                         color: Colors.orange,
      //                         width: 2,
      //                       ),
      //                     ),
      //                     filled: true,
      //                     fillColor: Colors.white,
      //                   ),
      //                   dropdownColor: Colors.white,
      //                   isExpanded: true,
      //                   items: controller.homeController.categories
      //                       .map(
      //                         (cat) => DropdownMenuItem(
      //                           value: cat,
      //                           child: Text(cat),
      //                         ),
      //                       )
      //                       .toList(),
      //                   onChanged: (val) {
      //                     if (val != null) controller.changeCategory(val);
      //                   },
      //                 ),
      //               ],
      //             ],
      //           ),
      //         ),

      //         // ===== Results =====
      //         Expanded(
      //           child: Obx(() {
      //             if (controller.isLoading.value) {
      //               return buildLoadingShimmer();
      //             } else if (controller.filteredQuotes.isEmpty) {
      //               return const Center(
      //                 child: Text(
      //                   'No quotes found',
      //                   style: TextStyle(color: Colors.grey),
      //                 ),
      //               );
      //             } else {
      //               return ListView.builder(
      //                 padding: const EdgeInsets.symmetric(
      //                   horizontal: 16,
      //                   vertical: 8,
      //                 ),
      //                 itemCount: controller.filteredQuotes.length,
      //                 itemBuilder: (context, index) {
      //                   final quote = controller.filteredQuotes[index];
      //                   return Padding(
      //                     padding: const EdgeInsets.only(bottom: 16),
      //                     child: Obx(() {
      //                       final isFav = controller.isFavorite(quote.id);
      //                       return QuoteCard(
      //                         quote: quote,
      //                         fontSize: 18,
      //                         isFavorite: isFav,
      //                         onToggleFavorite: controller.toggleFavorite,
      //                       );
      //                     }),
      //                   );
      //                 },
      //               );
      //             }
      //           }),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
   
    );
  }
}
