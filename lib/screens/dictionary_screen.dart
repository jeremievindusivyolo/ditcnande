/// dictionary_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'about_screen.dart';
import 'ctrl/dict_repo.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});
  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  late Future<List<Map<String, dynamic>>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() =>
      context.read<DictionaryRepository>().search(_query);

  Future<void> _onRefresh() async {
    // 1. run the async part
    await context.read<DictionaryRepository>().refresh();

    // 2. update state synchronously
    if (!mounted) return;                 // defensive: widget may be gone
    setState(() {
      _future = _load();                  // just assign; no await, no async
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            );
          },
          icon: const Icon(Icons.info),
        ),
        title: const Text('Dictionaire'),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                final result = await showSearch<String?>(
                  context: context,
                  delegate: DictionarySearchDelegate(),
                );
                if (result != null) {
                  setState(() {
                    _query = result;
                    _future = _load();
                  });
                }
              }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _future,
          builder: (c, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final rows = snap.data!;
            if (rows.isEmpty) {
              return const Center(child: Text('No entries'));
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: rows.length,
              separatorBuilder: (_, __) => Divider(height: 0, color: Theme.of(context).colorScheme.surface),
              itemBuilder: (_, i) {
                final r = rows[i];

                return ListTile(
                  title: Text(r['kinande'], style: Theme.of(context).textTheme.titleSmall),
                  subtitle: Text(r['french']),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DictionaryDetail(entry: r),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// simple search-delegate
class DictionarySearchDelegate extends SearchDelegate<String?> {
  @override
  List<Widget>? buildActions(c) => [IconButton(
    icon: const Icon(Icons.clear),
    onPressed: () => query = '',
  )];

  @override
  Widget? buildLeading(c) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(c, null),
  );

  @override
  Widget buildResults(c) => const SizedBox.shrink();
  @override
  Widget buildSuggestions(c) {
    final repo = c.read<DictionaryRepository>();
    return FutureBuilder(
      future: repo.search(query),
      builder: (c, s) {
        if (!s.hasData) return const Center(child: CircularProgressIndicator());
        final rows = s.data!;
        return ListView.builder(
          itemCount: rows.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(rows[i]['kinande']),
            subtitle: Text(rows[i]['french']),
            onTap: () {
              //close(c, rows[i]['kinande']);
              Navigator.push(
                  c,
                  MaterialPageRoute(
                  builder: (_) => DictionaryDetail(entry: rows[i]),
              ));
            },
          ),
        );
      },
    );
  }
}


/// dictionary_detail.dart
class DictionaryDetail extends StatelessWidget {
  const DictionaryDetail({super.key, required this.entry});
  final Map<String, dynamic> entry;

  @override
  Widget build(BuildContext context) {
    final kinande  = entry['kinande']  as String;
    final examples = (entry['examples'] ?? '') as String;

    return Scaffold(
      appBar: AppBar(title: Text(entry['kinande'])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Français : ${entry['french']}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            highlightText(
              source: examples,
              query: kinande,
              baseStyle: Theme.of(context).textTheme.bodyLarge,
              highlightStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)  // optional
            ),
          ],
        ),
      ),
    );
  }
}

/// Returns a RichText widget where every match of [query] inside [source]
/// is highlighted with [highlightStyle].  Non-matches use [baseStyle].
Widget highlightText({
  required String source,
  required String query,
  TextStyle? baseStyle,
  TextStyle? highlightStyle,
}) {
  if (query.isEmpty) {
    return Text(source, style: baseStyle);           // nothing to highlight
  }

  // Build a case-insensitive regex that escapes any special characters
  final pattern = RegExp(RegExp.escape(query), caseSensitive: false);

  final spans = <TextSpan>[];
  int start = 0;

  // Walk through every match, add normal + highlighted spans
  for (final m in pattern.allMatches(source)) {
    if (m.start > start) {
      spans.add(TextSpan(text: source.substring(start, m.start),
          style: baseStyle));
    }
    spans.add(TextSpan(text: m[0],
        style: highlightStyle ?? baseStyle?.copyWith(
          backgroundColor:
          baseStyle.color?.withOpacity(0.15) ??
              Colors.yellow.withOpacity(0.3),
          fontWeight: FontWeight.w600,
        )));
    start = m.end;
  }

  // Trailing text after the last match
  if (start < source.length) {
    spans.add(TextSpan(text: source.substring(start), style: baseStyle));
  }

  return Text.rich(TextSpan(children: spans));
}
