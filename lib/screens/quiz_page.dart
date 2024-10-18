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
  int? _selectedChoiceIndex;
  TextEditingController _answerController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_difficulty == null) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _difficulty = args['difficulty'];
      _username = args['username'];
      _loadQuestions();
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

  void _checkAnswer(String answer) {
    if (_randomizedQuestions.isEmpty) return;

    if (answer.toLowerCase() ==
        _randomizedQuestions[_currentQuestionIndex]
            .correctAnswer
            .toLowerCase()) {
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
          _selectedChoiceIndex = null;
          _answerController.clear();
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

  Widget _buildQuestionWidget() {
    if (_difficulty == 'Easy') {
      return Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                _randomizedQuestions[_currentQuestionIndex].imagePath!,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildChoices(),
        ],
      );
    } else if (_difficulty == 'Medium') {
      return Column(
        children: [
          Text(
            _randomizedQuestions[_currentQuestionIndex].question!,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          _buildChoices(),
        ],
      );
    } else {
      return Column(
        children: [
          Text(
            _randomizedQuestions[_currentQuestionIndex].question!,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          TextField(
            controller: _answerController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your answer',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _checkAnswer(_answerController.text),
            child: Text('Submit'),
          ),
        ],
      );
    }
  }

  Widget _buildChoices() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _randomizedQuestions[_currentQuestionIndex].choices!.length,
      itemBuilder: (context, index) {
        bool isSelected = _selectedChoiceIndex == index;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.green : Color(0xFFB7A6E0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () {
            setState(() {
              _selectedChoiceIndex = index;
            });
          },
          child: Text(
            _randomizedQuestions[_currentQuestionIndex].choices![index],
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: _randomizedQuestions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            AppBar(
              backgroundColor: Color(0xFFB7A6E0),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black), // Changed to black
              title: Text(
                'Quiz - $_difficulty',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.black),
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
                    Text(
                      'Select the correct Kapampangan word for each image',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    iconTheme: IconThemeData(color: Colors.black),
                    title: Text(
                      'Quiz - $_difficulty',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.black),
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
                    SizedBox(height: 30),
                    Expanded(
                      flex: 2, // Make the choices area bigger
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _randomizedQuestions[_currentQuestionIndex].choices.length,
                        itemBuilder: (context, index) {
                          bool isSelected = _selectedChoiceIndex == index;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.deepPurple.withOpacity(0.5) // Active color
                                      : Colors.white.withOpacity(0.2), // Default color
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: isSelected
                                          ? Colors.deepPurple // Highlight active choice
                                          : Colors.white.withOpacity(0.2)),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? Colors.deepPurple // Active background color
                                        : Color(0xFFB7A6E0), // Default background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedChoiceIndex = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Text(
                                      _randomizedQuestions[_currentQuestionIndex].choices[index],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildQuestionWidget(),
                    ),
                  ),
                  if (_difficulty != 'Hard')
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 180, vertical: 20),
                        backgroundColor: _selectedChoiceIndex != null
                            ? Color(0xFFB7A6E0)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        side: BorderSide(
                          color: _selectedChoiceIndex != null
                              ? Color(0xFFB7A6E0)
                              : Colors.grey,
                          width: 2,
                        ),
                        shadowColor: Colors.black.withOpacity(0.2),
                        elevation: 6,
                      ),
                      onPressed: _selectedChoiceIndex != null
                          ? () => _checkAnswer(
                              _randomizedQuestions[_currentQuestionIndex]
                                  .choices![_selectedChoiceIndex!])
                          : null,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: _selectedChoiceIndex != null
                              ? Colors.white
                              : Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    unselectedItemColor: Colors.black,
                    selectedItemColor: Colors.black,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home, color: Colors.black),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.lightbulb, color: Colors.black),
                        label: 'Hint',
                      ),
                    ],
                    onTap: (index) {
                      if (index == 0) {
                        Navigator.pushNamed(context, '/home',
                            arguments: _username);
                      } else if (index == 1 && !_hintUsed) {
                        // Implement hint functionality
                      }
                    },
                  ),
                ],
              ),
            ),
            BottomNavigationBar(
              backgroundColor: Colors.white,
              unselectedItemColor: Colors.black,
              selectedItemColor: Colors.black,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Color(0xFFB7A6E0)),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.lightbulb, color: Color(0xFFB7A6E0)),
                  label: 'Hint',
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushNamed(context, '/home', arguments: _username);
                } else if (index == 1 && !_hintUsed) {
                  _useHint();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
