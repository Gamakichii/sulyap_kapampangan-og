import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class QuestionDetailsScreen extends StatelessWidget {
  final Question question;

  QuestionDetailsScreen({required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Question Details', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              question.description,
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to Home
                  },
                  child: Text('Home'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Dashboard (you'll need to create this screen)
                  },
                  child: Text('Dashboard'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}