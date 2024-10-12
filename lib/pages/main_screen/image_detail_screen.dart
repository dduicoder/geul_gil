import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:geul_gil/models/word.dart';
import 'package:geul_gil/widgets/word_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageDetailScreen extends StatefulWidget {
  final String imageUrl;
  final String tag;

  const ImageDetailScreen(
      {super.key, required this.imageUrl, required this.tag});

  @override
  State<ImageDetailScreen> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  final List<Word> _words = [
    Word(
      word: "에너지",
      meaning:
          """1.	인간이 활동하는 근원이 되는 힘.	2. 물리 기본적인 물리량의 하나. 물체나 물체계가 가지고 있는 일을 하는 능력을 통틀어 이르는 말로, 역학적 일을 기준으로 하여 이와 동등하다고 생각되는 것, 또는 이것으로 환산할 수 있는 것을 이른다. 에너지의 형태에 따라 운동, 위치, 열, 전기 따위의 에너지로 구분한다.""",
    ),
    Word(word: "이동", meaning: "1. 움직여 옮김. 또는 움직여 자리를 바꿈. 2. 권리나 소유권 따위가 넘어감."),
    Word(word: "줄", meaning: "Ipsum"),
    Word(word: "장력", meaning: "Ipsum"),
  ];

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

    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('단어장에 "${newWord.word}"이/가 추가되었습니다'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('전체 이미지')),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.025),
                    blurRadius: 16,
                    spreadRadius: 16,
                    offset: const Offset(0, 0),
                  )
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => FullScreenImageDialog(
                      imageUrl: widget.imageUrl,
                    ),
                  );
                },
                child: Hero(
                  tag: widget.tag,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child:
                          Image.network(widget.imageUrl, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: WordList(
              words: _words,
              onAddWord: _addWord,
            ),
          )
        ],
      ),
    );
  }
}

class FullScreenImageDialog extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageDialog({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Dialog(
        insetPadding: const EdgeInsets.all(64),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
