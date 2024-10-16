import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import '../objectbox.dart';
import '../models/quiz_question.dart';
import '../objectbox.g.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _progress = 0;
  int _currentQuestionIndex = 0;
  bool _isAnswerCorrect = true;
  List<QuizQuestion> _randomizedQuestions = [];
  bool _hintUsed = false;
  String? _errorMessage;
  String? _difficulty;
  String? _username;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_difficulty == null) {
      {
        final args = ModalRoute
            .of(context)!
            .settings
            .arguments as Map<String, dynamic>;
        _difficulty = args['difficulty'];
        _username = args['username'];
        _loadQuestions();
      }
    }
  }

  void _loadQuestions() {
    final questions = objectbox.quizQuestionBox
        .query(QuizQuestion_.difficulty.equals(_difficulty!))
        .build()
        .find();
    setState(() {
      _randomizedQuestions = questions..shuffle();
    });
  }

  void _checkAnswer(int selectedIndex) {
    if (_randomizedQuestions.isEmpty) return;

    if (_randomizedQuestions[_currentQuestionIndex].choices[selectedIndex] ==
        _randomizedQuestions[_currentQuestionIndex].correctAnswer) {
      setState(() {
        _isAnswerCorrect = true;
        _progress += 20;
        _errorMessage = null;

        if (_progress >= 100) {
          _showCongratsDialog();
        } else {
          _currentQuestionIndex =
              (_currentQuestionIndex + 1) % _randomizedQuestions.length;
          _hintUsed = false;
        }
      });
    } else {
      setState(() {
        _isAnswerCorrect = false;
        _errorMessage = 'Incorrect! Please try again.';
      });
    }
  }

  void _showCongratsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
          Text('Congratulations!', style: TextStyle(color: Colors.black)),
          content: Text('You have completed the quiz.',
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.pushNamed(context, '/home', arguments: _username);
              },
            ),
          ],
        );
      },
    );
  }

  void _useHint() {
    if (!_hintUsed && _randomizedQuestions.isNotEmpty) {
      setState(() {
        var currentQuestion = _randomizedQuestions[_currentQuestionIndex];
        List<String> choices = List.from(currentQuestion.choices);
        int correctIndex = choices.indexOf(currentQuestion.correctAnswer);

        int indexToRemove;
        do {
          indexToRemove = Random().nextInt(choices.length);
        } while (indexToRemove == correctIndex);

        choices.removeAt(indexToRemove);
        currentQuestion.choices = choices;

        _hintUsed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background3.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: _randomizedQuestions.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                title: Text(
                  'Quiz - $_difficulty',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(value: _progress / 100),
              SizedBox(height: 10),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Instruction Text
                      Text(
                        'Select the correct Kapampangan word for each image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20), // Reduced space before image
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            _randomizedQuestions[_currentQuestionIndex]
                                .imagePath,
                            fit: BoxFit.contain, // Prevents cropping
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (_difficulty != 'Easy' &&
                          _randomizedQuestions[_currentQuestionIndex]
                              .question !=
                              null)
                        Text(
                          _randomizedQuestions[_currentQuestionIndex]
                              .question!,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(height: 50),
                      // Expanded container for choices
                      Expanded(
                        flex: 2, // Make the choices area bigger
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 columns
                            childAspectRatio: 2, // Adjust the aspect ratio as needed
                            crossAxisSpacing: 10, // Space between columns
                            mainAxisSpacing: 10, // Space between rows
                          ),
                          itemCount: _randomizedQuestions[_currentQuestionIndex].choices.length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color:
                                        Colors.white.withOpacity(0.2)),
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () => _checkAnswer(index),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: Text(
                                        _randomizedQuestions[_currentQuestionIndex].choices[index],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BottomNavigationBar(
                backgroundColor: Colors.transparent,
                unselectedItemColor: Colors.white70,
                selectedItemColor: Colors.white,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, color: Colors.white),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.lightbulb, color: Colors.white),
                    label: 'Hint',
                  ),
                ],
                onTap: (index) {
                  if (index == 0) {
                    Navigator.pushNamed(context, '/home');
                  } else if (index == 1 && !_hintUsed) {
                    _useHint();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
