import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (routeArgs == null) {
      return Scaffold(
        body: Center(
          child: Text('No user data provided.'),
        ),
      );
    }

    final String username = routeArgs['username'] as String;
    final Map<String, dynamic> userData = routeArgs['userData'] as Map<String, dynamic>;

    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white, // Set background color to white
        child: Stack(
          children: [
            Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.white),
                  title: Text(
                    'Welcome, ${userData['username']}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black, // Change text color to black
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select a difficulty',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            color: Colors.black, // Change text color to black
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Kapampangan derives from the root word pampáng...',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                            color: Colors.black, // Change text color to black
                          ),
                        ),
                        SizedBox(height: 250),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 1,
                            childAspectRatio: 3,
                            children: [
                              _buildDifficultyButton(context, 'Easy', username, userData),
                              _buildDifficultyButton(context, 'Medium', username, userData),
                              _buildDifficultyButton(context, 'Hard', username, userData),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _buildProfileButton(context, userData['username'], userData), // Positioned top-right
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String difficulty, String username, Map<String, dynamic> userData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFB7A6E0), // Set fill color to #B7A6E0 for the entire button
              borderRadius: BorderRadius.circular(15),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () => _showConfirmationDialog(context, difficulty, username, userData),
              child: Text(
                difficulty,
                style: TextStyle(
                  color: Colors.white, // Set text color to white
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context, String difficulty, String username, Map<String, dynamic> userData) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Do you want to proceed?",
          style: TextStyle(color: Colors.black), // Set text color to black
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/quiz_page', // Navigate to quiz_page.dart
                arguments: {'difficulty': difficulty, 'userData': userData, 'username': username},
              ).then((_) {
                Navigator.pop(ctx); // Close the dialog after navigation
              });
            },
            child: Text(
              "Yes",
              style: TextStyle(color: Color(0xFFB7A6E0)), // Set text color to #B7A6E0
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog if "No"
            },
            child: Text(
              "No",
              style: TextStyle(color: Color(0xFFB7A6E0)), // Set text color to #B7A6E0
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, String username, Map<String, dynamic> userData) {
    String? avatarPath = userData['avatar'];

    return Positioned(
      top: 75,
      right: 25,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/profile', arguments: {'username': username, 'userData': userData}),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFFB7A6E0),
          backgroundImage: avatarPath != null && avatarPath.isNotEmpty
              ? AssetImage(avatarPath) // Use the avatar image if available
              : null, // If no avatar, use default placeholder
          child: avatarPath == null || avatarPath.isEmpty
              ? Icon(
            Icons.person, // Placeholder for anonymous profile
            size: 40,
            color: Colors.white,
          )
              : null,
        ),
      ),
    );
  }
}
