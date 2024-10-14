import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_question_screen.dart';
import 'question_details_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    List<Question> questions = await _dbHelper.getQuestions();
    setState(() {
      _questions = questions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Sulyap Kapampangan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Pag-Aral at Paggalugad',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _questions.isEmpty
                ? Center(
                    child: Text('Tap the + button to add questions'),
                  )
                : ListView.builder(
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionDetailsScreen(question: _questions[index]),
                            ),
                          ).then((_) => _fetchQuestions());
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          elevation: 4.0,
                          child: ListTile(
                            title: Text(_questions[index].title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Text(_questions[index].description),
                          ),
                        ),
                      );
                    },
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Current screen (Home)
                    },
                    child: Text('Home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardScreen()),
                      );
                    },
                    child: Text('Dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddQuestionScreen()),
          ).then((_) => _fetchQuestions());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}