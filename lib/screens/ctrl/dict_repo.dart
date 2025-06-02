/// dict_repo.dart
import 'package:flutter/material.dart';
import 'dictionnary_sync.dart';

class DictionaryRepository with ChangeNotifier {
  DictionaryRepository(this.sync);

  final DictionarySync sync;

  Future<void> init() async {
    await sync.open();
    await sync.initialSync();
  }

  Future<void> refresh() async {
    await sync.incrementalSync();
    notifyListeners();    // data may have changed
  }

  Future<List<Map<String, dynamic>>> search(String q) => sync.search(q);
}
