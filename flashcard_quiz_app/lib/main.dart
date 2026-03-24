import 'package:flutter/material.dart';

void main() {
  runApp(FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FlashcardHome(),
    );
  }
}

class Flashcard {
  String question;
  String answer;
  Flashcard({required this.question, required this.answer});
}

class FlashcardHome extends StatefulWidget {
  @override
  _FlashcardHomeState createState() => _FlashcardHomeState();
}

class _FlashcardHomeState extends State<FlashcardHome> {
  List<Flashcard> cards = [
    Flashcard(question: 'What is the capital of Pakistan?', answer: 'Islamabad'),
    Flashcard(question: 'Flutter is developed by?', answer: 'Google'),
    Flashcard(question: 'What is 2 + 2?', answer: '4'),
  ];

  int currentIndex = 0;
  bool showAnswer = false;

  void nextCard() {
    if (currentIndex < cards.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    }
  }

  void previousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showAnswer = false;
      });
    }
  }

  void toggleAnswer() {
    setState(() {
      showAnswer = !showAnswer;
    });
  }

  void addCard(String question, String answer) {
    setState(() {
      cards.add(Flashcard(question: question, answer: answer));
    });
  }

  void editCard(int index, String question, String answer) {
    setState(() {
      cards[index].question = question;
      cards[index].answer = answer;
    });
  }

  void deleteCard(int index) {
    setState(() {
      if (cards.isNotEmpty) {
        cards.removeAt(index);
        if (currentIndex >= cards.length) currentIndex = cards.length - 1;
        showAnswer = false;
      }
    });
  }

  void showAddDialog() {
    final _questionController = TextEditingController();
    final _answerController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _questionController, decoration: InputDecoration(labelText: 'Question')),
            TextField(controller: _answerController, decoration: InputDecoration(labelText: 'Answer')),
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                addCard(_questionController.text, _answerController.text);
                Navigator.pop(context);
              },
              child: Text('Add')),
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ],
      ),
    );
  }

  void showEditDialog() {
    final _questionController = TextEditingController(text: cards[currentIndex].question);
    final _answerController = TextEditingController(text: cards[currentIndex].answer);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _questionController, decoration: InputDecoration(labelText: 'Question')),
            TextField(controller: _answerController, decoration: InputDecoration(labelText: 'Answer')),
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                editCard(currentIndex, _questionController.text, _answerController.text);
                Navigator.pop(context);
              },
              child: Text('Save')),
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Flashcard Quiz App')),
        body: Center(child: Text('No flashcards available. Add some!')),
        floatingActionButton: FloatingActionButton(
          onPressed: showAddDialog,
          child: Icon(Icons.add),
        ),
      );
    }

    final card = cards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard Quiz App'),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: showEditDialog),
          IconButton(icon: Icon(Icons.delete), onPressed: () => deleteCard(currentIndex)),
        ],
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(showAnswer ? card.answer : card.question,
                    style: TextStyle(fontSize: 22), textAlign: TextAlign.center),
                SizedBox(height: 20),
                ElevatedButton(onPressed: toggleAnswer, child: Text(showAnswer ? 'Show Question' : 'Show Answer')),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: previousCard, child: Text('Previous')),
                    ElevatedButton(onPressed: nextCard, child: Text('Next')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: showAddDialog, child: Icon(Icons.add)),
    );
  }
}
