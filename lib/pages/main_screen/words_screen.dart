import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geul_gil/models/word.dart';
import 'package:geul_gil/widgets/word_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordsScreen extends StatefulWidget {
  const WordsScreen({super.key});

  @override
  State<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen> {
  late List<Word> _words = [];

  void _openWordModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: WordForm(
            onSubmit: (word) {
              _addWord(ctx, word);
            },
          ),
        );
      },
    );
  }

  Future<void> _loadWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? wordsJson = prefs.getString('words');

    if (wordsJson != null) {
      List<dynamic> decoded = jsonDecode(wordsJson);
      setState(() {
        _words =
            decoded.map((item) => Word.fromJson(jsonDecode(item))).toList();
      });
    }
  }

  Future<void> _addWord(BuildContext ctx, Word newWord) async {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? wordsJson = prefs.getString('words');
    List<dynamic> wordList = [];

    if (wordsJson != null) {
      wordList = jsonDecode(wordsJson);

      if (wordList.contains(jsonEncode(newWord.toJson()))) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('단어장에 "${newWord.word}"이/가 이미 있습니다'),
          ),
        );
        return;
      }
    }

    wordList.add(jsonEncode(newWord.toJson()));

    await prefs.setString('words', jsonEncode(wordList));

    setState(() {
      _words = wordList.map((item) => Word.fromJson(jsonDecode(item))).toList();
    });

    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('단어장에 "${newWord.word}"이/가 추가되었습니다'),
      ),
    );
  }

  Future<void> _removeWords(Word removeWord) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _words.remove(removeWord);
    });
    await prefs.setString(
      'words',
      jsonEncode(_words.map((word) => jsonEncode(word.toJson())).toList()),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: min(800, MediaQuery.of(context).size.width),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "단어장",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _openWordModal(context);
                    },
                    child: const Text("새 단어"),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              _words.isEmpty
                  ? const Expanded(child: Center(child: Text("- 단어장이 비었습니다 -")))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _words.length,
                        itemBuilder: (ctx, index) {
                          final item = _words[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.025),
                                  blurRadius: 8,
                                  spreadRadius: 8,
                                  offset: const Offset(0, 0),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.word,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _removeWords(item);
                                      },
                                      icon: const Icon(Icons.delete_rounded),
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.black.withOpacity(0.05)),
                                const SizedBox(height: 8),
                                Text(item.meaning),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
