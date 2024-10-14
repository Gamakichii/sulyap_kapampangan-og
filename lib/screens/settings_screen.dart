import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Notifications'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: false,
            onChanged: (value) {},
          ),
          ListTile(
            title: Text('Language'),
            trailing: DropdownButton<String>(
              items: ['English', 'Spanish', 'French', 'Kapampangan']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Dashboard
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
    );
  }
}