import 'portfolio_asset.dart';

abstract class PortfolioRepository {
  Future<List<PortfolioAsset>> load();
  Future<void> add(PortfolioAsset asset);
  Future<void> update(PortfolioAsset asset);
  Future<void> remove(String id);
  Future<void> clear();
}
