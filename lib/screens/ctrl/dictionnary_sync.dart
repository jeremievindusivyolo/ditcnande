/// dictionary_sync.dart
import 'dart:convert';
import 'package:diacritic/diacritic.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DictionarySync {
  DictionarySync(this.baseHost, {http.Client? client})
      : _client = client ?? http.Client();

  final String baseHost;                 // e.g. "api.example.com"
  final http.Client _client;
  late final Database _db;
  static const _prefsKey = 'last_sync_at';

  /* ––––– OPEN DB ––––– */
  Future<void> open() async {
    final dir = await getApplicationDocumentsDirectory();
    _db = await openDatabase(
      '${dir.path}/dictionary.db',
      version: 2,                      // ⬅ bump!
      onCreate: (db, _) async => db.execute('''
      CREATE TABLE IF NOT EXISTS dictionary(
        id             INTEGER PRIMARY KEY,
        kinande        TEXT,
        french         TEXT,
        part_of_speech TEXT,
        examples       TEXT,
        created_at     TEXT,
        updated_at     TEXT,
        kinande_norm   TEXT,            -- NEW
        french_norm    TEXT             -- NEW
      )
    '''),
      onUpgrade: (db, oldV, newV) async {
        if (oldV < 2) {
          await db.execute('ALTER TABLE dictionary ADD COLUMN created_at TEXT');
        }
      },
    );
  }

  /* ––––– PUBLIC SYNC ––––– */
  Future<void> initialSync() async {
    final json = await _get('/sync');
    await _applyRows(json['rows']);
    await _saveLastSync(json['last_sync']);
  }

  Future<void> incrementalSync() async {
    final since = await _loadLastSync() ?? '1970-01-01T00:00:00Z';
    final json = await _get('/sync', params: {'since': since});
    if ((json['rows'] as List).isNotEmpty) {
      await _applyRows(json['rows']);
      await _saveLastSync(json['last_sync']);
    }
  }

  /* ––––– INTERNALS ––––– */

  Uri _buildUri(String path, Map<String, String>? params) {
    final root = Uri.parse(baseHost);

    // If no scheme → treat `baseHost` as *authority* only
    if (root.scheme.isEmpty) {
      // remove the leading slash from `path` because Uri.http adds it for us
      final cleanPath = path.startsWith('/') ? path.substring(1) : path;
      return Uri.http(baseHost, cleanPath, params);
    }

    // baseHost already contains http/https → reuse it
    return root.replace(
      path: path.startsWith('/') ? path : '/$path',
      queryParameters: params,
    );
  }

  Future<Map<String, dynamic>> _get(String path,
      {Map<String, String>? params}) async {
    final uri = _buildUri(path, params);
    print(uri);
    final r   = await _client.get(uri);
    if (r.statusCode != 200) throw Exception('Sync failed – ${r.statusCode}');
    return jsonDecode(r.body) as Map<String, dynamic>;
  }
  String _normalize(String s) => removeDiacritics(s).toLowerCase().trim();

  Future<void> _applyRows(List rows) async {
    final batch = _db.batch();
    for (final row in rows) {
      row['kinande_norm'] = _normalize(row['kinande']);
      row['french_norm']  = _normalize(row['french']);
      batch.insert('dictionary', Map<String, dynamic>.from(row),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> _saveLastSync(String iso) async =>
      (await SharedPreferences.getInstance()).setString(_prefsKey, iso);

  Future<String?> _loadLastSync() async =>
      (await SharedPreferences.getInstance()).getString(_prefsKey);

  void dispose() => _client.close();

  /* ––––– QUERIES FOR UI ––––– */
  Future<List<Map<String, dynamic>>> search(String q) {
    final n = _normalize(q);
    return _db.query(
      'dictionary',
      where: 'kinande_norm LIKE ? OR french_norm LIKE ?',
      whereArgs: ['%$n%', '%$n%'],
      orderBy: 'kinande',
    );
  }
}
