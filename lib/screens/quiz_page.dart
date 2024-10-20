import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import '../objectbox.dart';
import '../models/quiz_question.dart';
import '../objectbox.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<int> _answeredQuestionsIndex = [];
  bool _hintUsed = false;
  String? _errorMessage;
  String? _difficulty;
  String? _username;
  Map<String, dynamic>? userData;
  int? _selectedChoiceIndex;
  TextEditingController _answerController = TextEditingController();
  int _points = 0;
  int _questionsAnswered = 0;
  late List<String> _availableChoices;
  final int _hintPointDeduction = 5;

  // For managing points change notification
  bool _isPointChangeVisible = false;
  String _pointChangeMessage = '';
  Color _pointChangeColor = Colors.green;

  // Flag to indicate whether the quiz has started
  bool _quizStarted = false;
  bool _isRandomized = false; // Flag to control question randomization

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final routeArgs =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (routeArgs != null &&
        routeArgs.containsKey('username') &&
        routeArgs.containsKey('difficulty') &&
        routeArgs.containsKey('userData')) {
      _username = routeArgs['username'] as String;
      _difficulty = routeArgs['difficulty'] as String;
      userData = routeArgs['userData'] as Map<String, dynamic>;
      _points = userData?['points'] ?? 0;

      // Start the quiz and load questions
      _startQuiz();
      // Fetch current points when user data is set
      _fetchCurrentPoints();
    } else {
      print('Missing or invalid route arguments.');
    }
  }

  void _startQuiz() {
    setState(() {
      _quizStarted = true; // Indicate that the quiz has started
      if (!_isRandomized) {
        _loadQuestions(); // Load and randomize questions only once
        _isRandomized = true; // Set to true after loading questions
      }
    });
  }

  void _fetchCurrentPoints() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    try {
      final snapshot = await usersCollection
          .where('username', isEqualTo: _username)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _points = snapshot.docs.first['points'] ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching user points: $e');
    }
  }

  void _loadQuestions() {
    final questions = objectbox.quizQuestionBox
        .query(QuizQuestion_.difficulty.equals(_difficulty ?? ''))
        .build()
        .find();

    setState(() {
      _randomizedQuestions = (questions..shuffle()).take(10).toList();
      _setAvailableChoices();
      print('Loaded ${_randomizedQuestions.length} questions for difficulty $_difficulty');
    });
  }

  void _setAvailableChoices() {
    if (_randomizedQuestions.isNotEmpty) {
      _availableChoices = List.of(_randomizedQuestions[_currentQuestionIndex].choices ?? []);
    }
  }

  void _useHint() {
    if (_points >= _hintPointDeduction) {
      if (_availableChoices.length > 2) {
        List<String> incorrectChoices = _availableChoices
            .where((choice) =>
        choice !=
            _randomizedQuestions[_currentQuestionIndex].correctAnswer)
            .toList();

        if (incorrectChoices.isNotEmpty) {
          final choiceToRemove = (incorrectChoices..shuffle()).first;
          setState(() {
            _availableChoices.remove(choiceToRemove);
            _hintUsed = true;
            _points -= _hintPointDeduction;
            _showPointsAnimation('Points decreased by $_hintPointDeduction', Colors.red);
            _updateUserPoints();
          });
        } else {
          setState(() {
            _errorMessage = "No incorrect choices available to remove!";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Not enough choices to use a hint!";
        });
      }
    } else {
      setState(() {
        _errorMessage = "Not enough points to use a hint!";
      });
    }
  }

  Future<void> _checkAnswer(String answer) async {
    if (_randomizedQuestions.isEmpty) return;

    bool isCorrect = answer.toLowerCase() ==
        (_randomizedQuestions[_currentQuestionIndex].correctAnswer ?? '')
            .toLowerCase();

    if (isCorrect && !_answeredQuestionsIndex.contains(_currentQuestionIndex)) {
      setState(() {
        _isAnswerCorrect = true;
        _points += 10;
        _questionsAnswered++;
        _progress =
            (_questionsAnswered / _randomizedQuestions.length * 100).round();
        _answeredQuestionsIndex.add(_currentQuestionIndex);
        _showPointsAnimation('Points increased by 10', Colors.green);
        _errorMessage = null;
      });

      await _updateUserPoints();

      // Randomize after answering correctly
      if (_questionsAnswered < _randomizedQuestions.length) {
        final previousIndex = _currentQuestionIndex;
        _currentQuestionIndex = Random().nextInt(_randomizedQuestions.length); // Pick a new random question

        while (_answeredQuestionsIndex.contains(_currentQuestionIndex) || _currentQuestionIndex == previousIndex) {
          _currentQuestionIndex = Random().nextInt(_randomizedQuestions.length);
        }

        _hintUsed = false;
        _selectedChoiceIndex = null;
        _answerController.clear();
        _setAvailableChoices();
      } else {
        _updateUserLevel();
        _showCongratsDialog();
      }
    } else {
      setState(() {
        _points = max(0, _points - 5);
        _errorMessage = 'Incorrect! Please try again.';
        _showPointsAnimation('Points decreased by 5', Colors.red);
      });

      await _updateUserPoints();
    }
  }

  void _showPointsAnimation(String message, Color color) {
    setState(() {
      _pointChangeMessage = message; // Update the message
      _pointChangeColor = color; // Update the color based on increase/decrease
      _isPointChangeVisible = true;   // Show the change message
    });

    // Hide the message after 2 seconds, then show current points
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isPointChangeVisible = false; // Hide the change message
        });

        // After hiding, show current points
        Future.delayed(Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _pointChangeMessage = 'Current Points: $_points'; // Show current points
              _isPointChangeVisible = true; // Show current points
            });
          }
        });
      }
    });
  }

  Future<void> _updateUserPoints() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    try {
      final snapshot = await usersCollection
          .where('username', isEqualTo: _username)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update({'points': _points});
        print('User points updated successfully to $_points');

        setState(() {
          userData?['points'] = _points;
        });
      } else {
        print('No user found with username: $_username');
      }
    } catch (e) {
      print('Error updating user points: $e');
    }
  }

  Future<void> _updateUserLevel() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    try {
      final snapshot = await usersCollection
          .where('username', isEqualTo: _username)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        int newLevel = userData?['level'] ?? 1;

        if (_difficulty == 'Easy' && newLevel < 2) {
          newLevel = 2;
        } else if (_difficulty == 'Medium' && newLevel < 3) {
          newLevel = 3;
        }

        await snapshot.docs.first.reference.update({'level': newLevel});
        print('User level updated successfully to level $newLevel');

        setState(() {
          userData?['level'] = newLevel;
        });
      } else {
        print('No user found with username: $_username');
      }
    } catch (e) {
      print('Error updating user level: $e');
    }
  }

  void _showCongratsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Congratulations!',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'You have completed the quiz. Final points: $_points',
              style: TextStyle(color: Colors.black, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home',
                    arguments: {'username': _username, 'userData': userData});
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPointsDisplay() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 50,
      color: _isPointChangeVisible ? _pointChangeColor : Colors.deepPurple,
      curve: Curves.easeInOut,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.monetization_on, color: Colors.white),
          SizedBox(width: 8),
          Text(
            _pointChangeMessage.isEmpty
                ? 'Current Points: $_points'
                : _pointChangeMessage,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionWidget() {
    if (_randomizedQuestions.isEmpty) {
      return Center(child: Text('No questions available for this difficulty.'));
    }

    final currentQuestion = _randomizedQuestions[_currentQuestionIndex];

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildErrorMessage(),
            SizedBox(height: 20),
            Text(
              _difficulty == 'Easy'
                  ? 'Select the correct Kapampangan word for each image'
                  : currentQuestion.question ?? 'Error: Question text is missing.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (_difficulty == 'Easy' && currentQuestion.imagePath != null) ...[
              Container(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    currentQuestion.imagePath!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
            if (_difficulty != 'Hard')
              Container(
                height: 200,
                child: _buildChoices(),
              )
            else
              TextField(
                controller: _answerController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your answer',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            SizedBox(height: 20),
            _buildSubmitButton(width: MediaQuery.of(context).size.width * 0.8),
          ],
        ),
      ),
    );
  }

  Widget _buildChoices() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _availableChoices.length,
      itemBuilder: (context, index) {
        bool isSelected = _selectedChoiceIndex == index;
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
              isSelected ? Colors.deepPurple : Color(0xFFB7A6E0),
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
              _availableChoices[index],
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton({required double width}) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: _difficulty == 'Hard' || _selectedChoiceIndex != null
              ? Color(0xFFB7A6E0)
              : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: _difficulty == 'Hard'
            ? () => _checkAnswer(_answerController.text)
            : (_selectedChoiceIndex != null
            ? () => _checkAnswer(_availableChoices[_selectedChoiceIndex!])
            : null),
        child: Text(
          'Submit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      height: 20,
      child: _errorMessage != null
          ? Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 300),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            _errorMessage!,
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Quiz - $_difficulty',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildPointsDisplay(), // Persistent points display
            LinearProgressIndicator(value: _progress / 100),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildQuestionWidget(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            // Only navigate back to home, no randomization of questions
            Navigator.pushNamed(context, '/home',
                arguments: {'username': _username, 'userData': userData});
          } else if (index == 1 && !_hintUsed) {
            _useHint();
          }
        },
      ),
    );
  }
}
