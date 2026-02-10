import 'package:flutter/material.dart';
import 'package:graduation_project_nti/core/colors.dart';
import 'package:graduation_project_nti/core/data/models/quote_model.dart';

class QuoteCard extends StatelessWidget {
  final QuoteModel quote;
  final double fontSize;
  final bool isFavorite;
  final Function(String) onToggleFavorite;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.fontSize,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '“${quote.quote}”',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              '- ${quote.author}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Divider(
              color: const Color.fromARGB(48, 158, 158, 158),
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => onToggleFavorite(quote.id),
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(29, 191, 190, 190),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        TweenAnimationBuilder<Color?>(
                          tween: ColorTween(
                            begin: const Color.fromARGB(
                              255,
                              128,
                              128,
                              128,
                            ), // رمادي
                            end: isFavorite
                                ? AppColors.primaryOrange
                                : const Color.fromARGB(255, 128, 128, 128),
                          ),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, color, child) {
                            return Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: color,
                            );
                          },
                        ),
                        const SizedBox(width: 2),
                        TweenAnimationBuilder<Color?>(
                          tween: ColorTween(
                            begin: const Color.fromARGB(255, 128, 128, 128),
                            end: isFavorite
                                ? AppColors.primaryOrange
                                : const Color.fromARGB(255, 128, 128, 128),
                          ),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, color, child) {
                            return Text(
                              isFavorite ? "Liked" : "Like",
                              style: TextStyle(color: color),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(29, 191, 190, 190),
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: Row(
                      children: [
                        Icon(
                          Icons.share_outlined,
                          color: const Color.fromARGB(255, 128, 128, 128),
                        ),
                        SizedBox(width: 2),
                        Text(
                          "Share",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 128, 128, 128),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
