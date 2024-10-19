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
  bool _hintUsed = false;
  String? _errorMessage;
  String? _difficulty;
  String? _username;
  Map<String, dynamic>? userData;
  int? _selectedChoiceIndex;
  TextEditingController _answerController = TextEditingController();
  int _points = 0;
  int _questionsAnswered = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_difficulty == null) {
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

        _loadQuestions();
      } else {
        print('Missing or invalid route arguments.');
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

  Future<void> _checkAnswer(String answer) async {
    if (_randomizedQuestions.isEmpty) return;

    bool isCorrect = answer.toLowerCase() ==
        _randomizedQuestions[_currentQuestionIndex].correctAnswer.toLowerCase();

    setState(() {
      _isAnswerCorrect = isCorrect;
      if (isCorrect) {
        _points += 10;
        _questionsAnswered++;
        _progress =
            (_questionsAnswered / _randomizedQuestions.length * 100).round();
      } else {
        _points = max(0, _points - 5);
      }
      _errorMessage = isCorrect ? null : 'Incorrect! Please try again.';
    });

    await _updateUserPoints();

    if (isCorrect) {
      if (_questionsAnswered >= _randomizedQuestions.length) {
        _showCongratsDialog();
      } else {
        setState(() {
          _currentQuestionIndex =
              (_currentQuestionIndex + 1) % _randomizedQuestions.length;
          _hintUsed = false;
          _selectedChoiceIndex = null;
          _answerController.clear();
        });
      }
    }
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

        // Update local userData
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

  void _showCongratsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Congratulations!', style: TextStyle(color: Colors.black)),
          content: Text('You have completed the quiz. Final points: $_points',
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.black)),
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

  Widget _buildQuestionWidget() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safeAreaPadding = MediaQuery.of(context).padding;
    final availableHeight = screenHeight -
        safeAreaPadding.top -
        safeAreaPadding.bottom -
        kBottomNavigationBarHeight -
        AppBar().preferredSize.height;

    if (_difficulty == 'Easy') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildErrorMessage(),
          SizedBox(height: availableHeight * 0.02),
          Text(
            'Select the correct Kapampangan word for each image',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
              height:
                  availableHeight * 0.05), // Gap between instruction and image
          Container(
            height: availableHeight * 0.2,
            width: screenWidth * 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                _randomizedQuestions[_currentQuestionIndex].imagePath!,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
              height: availableHeight *
                  0.05), // Gap between image and choices (same as above)
          Container(
            height: availableHeight * 0.3,
            child: _buildChoices(),
          ),
          SizedBox(
              height: availableHeight *
                  0.01), // Reduced gap between choices and submit button
          _buildSubmitButton(width: 1000), // Width set to 1000
        ],
      );
    } else if (_difficulty == 'Medium') {
      // Medium mode remains unchanged
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildErrorMessage(),
          SizedBox(height: availableHeight * 0.02),
          Text(
            _randomizedQuestions[_currentQuestionIndex].question!,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: availableHeight * 0.05),
          Container(
            height: availableHeight * 0.3,
            child: _buildChoices(),
          ),
          SizedBox(
              height: availableHeight *
                  0.01), // Reduced gap between choices and submit button
          _buildSubmitButton(width: 1000), // Width set to 1000
        ],
      );
    } else {
      // Hard mode remains unchanged
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _randomizedQuestions[_currentQuestionIndex].question!,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: availableHeight * 0.05),
          Container(
            width: screenWidth * 0.8,
            child: TextField(
              controller: _answerController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your answer',
              ),
            ),
          ),
          SizedBox(height: availableHeight * 0.03),
          _buildSubmitButton(width: screenWidth * 0.8),
          SizedBox(height: 45),
          _buildErrorMessage(),
        ],
      );
    }
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
      itemCount: _randomizedQuestions[_currentQuestionIndex].choices!.length,
      itemBuilder: (context, index) {
        bool isSelected = _selectedChoiceIndex == index;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.deepPurple : Color(0xFFB7A6E0),
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
            style: TextStyle(color: Colors.white, fontSize: 20),
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
                ? () => _checkAnswer(_randomizedQuestions[_currentQuestionIndex]
                    .choices![_selectedChoiceIndex!])
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
          ? Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 18),
              textAlign: TextAlign.center,
            )
          : SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFB7A6E0),
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
      body: SafeArea(
        child: _randomizedQuestions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  LinearProgressIndicator(value: _progress / 100),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Points: $_points',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
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
            Navigator.pushNamed(context, '/home', arguments: {
              'username': _username,
              'userData': {...?userData, 'points': _points}
            });
          } else if (index == 1 && !_hintUsed) {
            // Implement hint functionality
          }
        },
      ),
    );
  }
}
