
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
 const HomeView({super.key});
  //final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //final controller = Get.find<HomeController>();
    
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels >=
    //       _scrollController.position.maxScrollExtent - 200) {
    //     controller.fetchQuotes(refresh: false);
    //   }
    // });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 243, 243),
    //   body: Column(
    //     children: [
    //       // Header
    //       Container(
    //         color: Colors.white,
    //         child: Padding(
    //           padding: const EdgeInsets.only(
    //             top: 48,
    //             left: 16,
    //             right: 16,
    //             bottom: 16,
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               const Text('QuoteVault', style: TextStyle(fontSize: 24)),
    //               SizedBox(height: 20),
    //               SizedBox(
    //                 height: 48,
    //                 child: ListView.separated(
    //                   scrollDirection: Axis.horizontal,
    //                   itemCount: controller.categories.length,
    //                   separatorBuilder: (_, _) => const SizedBox(width: 8),
    //                   itemBuilder: (context, index) {
    //                     final category = controller.categories[index];
    //                     return Obx(() {
    //                       final isSelected =
    //                           controller.selectedCategory.value == category;

    //                       return GestureDetector(
    //                         onTap: () => controller.changeCategory(category),
    //                         child: Container(
    //                           padding: const EdgeInsets.symmetric(
    //                             horizontal: 16,
    //                             vertical: 8,
    //                           ),
    //                           decoration: BoxDecoration(
    //                             color: isSelected
    //                                 ? primaryOrange
    //                                 : const Color.fromARGB(29, 191, 190, 190),
    //                             borderRadius: BorderRadius.circular(24),
    //                           ),
    //                           child: Center(
    //                             child: Text(
    //                               category,
    //                               style: TextStyle(
    //                                 color: isSelected
    //                                     ? Colors.white
    //                                     : Colors.black,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       );
    //                     });
    //                   },
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),

    //       Expanded(
    //         child: Obx(() {
    //           if (controller.isLoading.value && controller.quotes.isEmpty) {
    //             return buildLoadingShimmer();
    //           }
    //           return RefreshIndicator(
    //             onRefresh: () => controller.fetchQuotes(refresh: true),
    //             child: ListView.builder(
    //               controller: _scrollController,
    //               padding: const EdgeInsets.symmetric(vertical: 8),
    //               itemCount: controller.quotes.length + 1,
    //               itemBuilder: (context, index) {
    //                 if (index == controller.quotes.length) {
    //                   return Obx(
    //                     () => controller.isFetchingMore.value
    //                         ? const Padding(
    //                             padding: EdgeInsets.all(16),
    //                             child: Center(
    //                               child: CircularProgressIndicator(),
    //                             ),
    //                           )
    //                         : const SizedBox(),
    //                   );
    //                 }

    //                 final quote = controller.quotes[index];
    //                 return Padding(
    //                   padding: const EdgeInsets.symmetric(
    //                     horizontal: 16,
    //                     vertical: 8,
    //                   ),
    //                   child: Obx(() {
    //                     final isFav = controller.isFavorite(quote.id);
    //                     return QuoteCard(
    //                       quote: quote,
    //                       fontSize: 18,
    //                       isFavorite: isFav,
    //                       onToggleFavorite: controller.toggleFavorite,
    //                     );
    //                   }),
    //                 );
    //               },
    //             ),
    //           );
    //         }),
    //       ),
    //     ],
    //   ),
     );
  }
}
