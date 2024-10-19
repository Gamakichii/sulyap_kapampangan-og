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
  Map<String, dynamic>? userData; // Store user data
  int? _selectedChoiceIndex;
  TextEditingController _answerController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_difficulty == null) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      // Check if routeArgs and required keys are present
      if (routeArgs != null &&
          routeArgs.containsKey('username') &&
          routeArgs.containsKey('difficulty') &&
          routeArgs.containsKey('userData')) {

        _username = routeArgs['username'] as String;
        _difficulty = routeArgs['difficulty'] as String;
        userData = routeArgs['userData'] as Map<String, dynamic>;

        // Perform any necessary initialization with these values
        _loadQuestions();
      } else {
        // Handle missing or invalid arguments gracefully
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
          _updateUserLevel(); // Update the user's level when quiz is completed
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

  Future<void> _updateUserLevel() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    try {
      // Query to find the user document by username
      final snapshot = await usersCollection
          .where('username', isEqualTo: _username) // Use the class variable for username
          .limit(1) // Limit to one user
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Determine the new level based on the difficulty
        int newLevel = userData?['level'] ?? 1; // Default to level 1 if not set

        if (_difficulty == 'Easy' && newLevel < 2) {
          newLevel = 2; // Set level to 2 for Easy completion
        } else if (_difficulty == 'Medium' && newLevel < 3) {
          newLevel = 3; // Set level to 3 for Medium completion
        }

        // Update the specific document with the new level
        await snapshot.docs.first.reference.update({'level': newLevel});
        print('User level updated successfully to level $newLevel');
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
          title:
          Text('Congratulations!', style: TextStyle(color: Colors.black)),
          content: Text('You have completed the quiz.',
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.pushNamed(context, '/home', arguments: {'username': _username, 'userData' : userData});
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
            Navigator.pushNamed(context, '/home', arguments: _username);
          } else if (index == 1 && !_hintUsed) {
            // Implement hint functionality
          }
        },
      ),
    );
  }
}
