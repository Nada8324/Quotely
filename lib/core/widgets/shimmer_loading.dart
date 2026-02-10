import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildLoadingShimmer() {
  return ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    itemCount: 6,
    itemBuilder: (_, _) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
  );
}
