import 'package:flutter/material.dart';

import '../../../../core/widgets/shimmer_box.dart';

class CoinTileSkeleton extends StatelessWidget {
  const CoinTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            ShimmerBox(height: 44, width: 44, radius: 14),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(height: 14, width: 140),
                  SizedBox(height: 6),
                  ShimmerBox(height: 12, width: 90),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ShimmerBox(height: 14, width: 70),
                SizedBox(height: 6),
                ShimmerBox(height: 12, width: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
