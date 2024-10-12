import 'package:flutter/material.dart';
import 'package:geul_gil/models/word.dart';

class WordList extends StatefulWidget {
  final List<Word> words;
  final Function(BuildContext, Word) onAddWord;

  const WordList({
    super.key,
    required this.words,
    required this.onAddWord,
  });

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  void _filterList() {
    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      _filteredWords = widget.words
          .where((item) => item.word.contains(searchQuery))
          .toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredWords = widget.words;
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredWords = widget.words;
    _searchController.addListener(_filterList);
  }

  final TextEditingController _searchController = TextEditingController();
  late List<Word> _filteredWords;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: '검색',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearSearch,
                    )
                  : null,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredWords.length,
            itemBuilder: (ctx, index) {
              final item = _filteredWords[index];
              return Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      spreadRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    shape: const Border(),
                    title: Text(
                      item.word,
                      style: const TextStyle(fontSize: 20),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          item.meaning,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onAddWord(context, item);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("단어장에 추가"),
                              Icon(Icons.add_rounded),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
