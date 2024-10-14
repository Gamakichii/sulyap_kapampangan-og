import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('User Rion', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'The Kapampangan Language',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Select a difficulty',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Kapampangan derives from the root word pampáng (\'riverbank\'). The language was previously spoken in the monarchy of Tondo, which was governed by the Lakans. Several Kapampangan dictionaries and grammar books were written during the Spanish colonial period.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Set difficulty to Easy
                  },
                  child: Text('Easy'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Set difficulty to Medium
                  },
                  child: Text('Medium'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Home
                    },
                    child: Text('Home'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Dashboard
                    },
                    child: Text('Dashboard'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}