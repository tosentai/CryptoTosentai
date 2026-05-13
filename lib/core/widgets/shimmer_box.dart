import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_colors.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.radius = 12,
  });

  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.elevatedDark : AppColors.elevatedLight,
      highlightColor:
          (isDark ? AppColors.emeraldGlow : AppColors.emeraldLight)
              .withValues(alpha: 0.15),
      period: const Duration(milliseconds: 1400),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: isDark ? AppColors.elevatedDark : AppColors.elevatedLight,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
