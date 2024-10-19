import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<Map<String, dynamic>?> _getUserData(String username) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final String username =
        ModalRoute.of(context)!.settings.arguments as String;

    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserData(username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData) {
          return Center(child: Text('User not found'));
        }

        final userData = snapshot.data!;
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
                                    color: Colors
                                        .black, // Change text color to black
                                  ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Kapampangan derives from the root word pampáng...',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors
                                        .black, // Change text color to black
                                  ),
                            ),
                            SizedBox(height: 250),
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 1,
                                childAspectRatio: 3,
                                children: [
                                  _buildDifficultyButton(
                                      context, 'Easy', username),
                                  _buildDifficultyButton(
                                      context, 'Medium', username),
                                  _buildDifficultyButton(
                                      context, 'Hard', username),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                _buildProfileButton(
                    context, userData['username']), // Positioned top-right
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDifficultyButton(
      BuildContext context, String difficulty, String username) {
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
                arguments: {'difficulty': difficulty, 'username': username},
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

  Widget _buildProfileButton(BuildContext context, String username) {
    return Positioned(
      top: 75,
      right: 25,
      child: GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, '/profile', arguments: username),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.withOpacity(0.2), // Change color to gray
          child: Icon(
            Icons.person, // Placeholder for anonymous profile
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
