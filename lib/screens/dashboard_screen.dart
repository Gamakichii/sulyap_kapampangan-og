import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  int _totalQuestions = 0;
  List<QuestionLengthData> _chartData = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    List<Question> questions = await _dbHelper.getQuestions();
    setState(() {
      _totalQuestions = questions.length;
      _chartData = [
        QuestionLengthData('Short', questions.where((q) => q.description.length < 50).length),
        QuestionLengthData('Medium', questions.where((q) => q.description.length >= 50 && q.description.length < 100).length),
        QuestionLengthData('Long', questions.where((q) => q.description.length >= 100).length),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sulyap Kapampangan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Dashboard',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(height: 24),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Questions',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$_totalQuestions',
                        style: TextStyle(fontSize: 24, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question Length Distribution',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 200,
                        child: CustomBarChart(data: _chartData),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to Home
                    },
                    child: Text('Home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Current screen (Dashboard)
                    },
                    child: Text('Dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionLengthData {
  final String category;
  final int count;

  QuestionLengthData(this.category, this.count);
}

class CustomBarChart extends StatelessWidget {
  final List<QuestionLengthData> data;

  CustomBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    int maxCount = data.map((e) => e.count).reduce((a, b) => a > b ? a : b);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((item) {
        double percentage = item.count / maxCount;
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(item.count.toString()),
              SizedBox(height: 5),
              Container(
                height: 150 * percentage,
                color: Colors.blue,
              ),
              SizedBox(height: 5),
              Text(item.category, style: TextStyle(fontSize: 12)),
            ],
          ),
        );
      }).toList(),
    );
  }
}