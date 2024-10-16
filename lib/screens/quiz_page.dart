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
        _progress += 10;
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
          Text(
            'Select the correct Kapampangan word for each image',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 70),
          Container(
            height: 230,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                _randomizedQuestions[_currentQuestionIndex].imagePath!,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 130),
          _buildChoices(),
          SizedBox(height: 75),
          _buildSubmitButton(),
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
          SizedBox(height: 20),
          _buildSubmitButton(),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFB7A6E0),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
          ),
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
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 180, vertical: 15),
        backgroundColor:
        _selectedChoiceIndex != null ? Color(0xFFB7A6E0) : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: _selectedChoiceIndex != null
          ? () => _checkAnswer(_randomizedQuestions[_currentQuestionIndex]
          .choices![_selectedChoiceIndex!])
          : null,
      child: Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildQuestionWidget(),
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