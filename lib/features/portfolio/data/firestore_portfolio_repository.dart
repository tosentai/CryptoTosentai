import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/portfolio_asset.dart';
import '../domain/portfolio_repository.dart';

class FirestorePortfolioRepository implements PortfolioRepository {
  FirestorePortfolioRepository(this._fs, this._uid);

  final FirebaseFirestore _fs;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _col =>
      _fs.collection('users').doc(_uid).collection('portfolio');

  @override
  Future<List<PortfolioAsset>> load() async {
    final snap = await _col.get();
    return snap.docs
        .map((d) => PortfolioAsset.fromJson({...d.data(), 'id': d.id}))
        .toList(growable: false);
  }

  @override
  Future<void> add(PortfolioAsset asset) =>
      _col.doc(asset.id).set(asset.toJson());

  @override
  Future<void> update(PortfolioAsset asset) =>
      _col.doc(asset.id).set(asset.toJson(), SetOptions(merge: true));

  @override
  Future<void> remove(String id) => _col.doc(id).delete();

  @override
  Future<void> clear() async {
    final snap = await _col.get();
    final batch = _fs.batch();
    for (final d in snap.docs) {
      batch.delete(d.reference);
    }
    await batch.commit();
  }
}

class NoopPortfolioRepository implements PortfolioRepository {
  const NoopPortfolioRepository();

  @override
  Future<List<PortfolioAsset>> load() async => const [];

  @override
  Future<void> add(PortfolioAsset asset) async {}
  @override
  Future<void> update(PortfolioAsset asset) async {}
  @override
  Future<void> remove(String id) async {}
  @override
  Future<void> clear() async {}
}
