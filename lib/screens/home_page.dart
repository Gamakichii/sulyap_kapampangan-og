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
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black.withOpacity(0.2)),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () => Navigator.pushNamed(
                context,
                '/difficulty',
                arguments: {'difficulty': difficulty, 'userData': userData, 'username':username},
              ),
              child: Text(
                difficulty,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ),
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
          backgroundColor: Colors.grey.withOpacity(0.2), // Change color to gray
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
