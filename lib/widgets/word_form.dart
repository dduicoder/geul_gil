import 'package:flutter/material.dart';
import 'package:geul_gil/models/word.dart';

class WordForm extends StatefulWidget {
  final Function(Word) onSubmit;

  const WordForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<WordForm> createState() => _WordFormState();
}

class _WordFormState extends State<WordForm> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  void _submitForm() {
    final word = _wordController.text;
    final meaning = _meaningController.text;

    if (word.isNotEmpty && meaning.isNotEmpty) {
      widget.onSubmit(
        Word(
          word: word,
          meaning: meaning,
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        padding: EdgeInsets.only(
          top: 0,
          left: 32,
          right: 32,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 32,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const SizedBox(
                    height: 5,
                    width: 100,
                  ),
                ),
              ),
            ),
            Text(
              "새 단어",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: "단어",
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              onSubmitted: (_) => _submitForm(),
              controller: _wordController,
            ),
            TextField(
              style: Theme.of(context).textTheme.bodyMedium,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                labelText: "뜻",
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              onSubmitted: (_) => _submitForm(),
              controller: _meaningController,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("취소"),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("단어 추가"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
