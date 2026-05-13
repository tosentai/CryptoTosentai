import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/app_providers.dart';
import '../../home/presentation/home_providers.dart';

final sparklineProvider =
    FutureProvider.family<List<double>, String>((ref, coinId) async {
  final repo = ref.watch(coinRepositoryProvider);
  final currency = ref.watch(currencyProvider);
  return repo.fetchSparkline(coinId: coinId, currency: currency);
});
