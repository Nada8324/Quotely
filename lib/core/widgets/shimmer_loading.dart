import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

Widget buildLoadingShimmer() {
  return ListView.builder(
    padding:  EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
    itemCount: 6,
    itemBuilder: (_, _) => Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 120.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    ),
  );
}
