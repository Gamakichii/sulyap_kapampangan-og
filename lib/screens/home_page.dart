import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String username = arguments['username'];
    final Map<String, dynamic> userData = arguments['userData'];

    int points = userData['points'];
    String avatarPath = userData['avatar']; // Retrieve avatar path directly
    int level = userData['level'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600, // Optional: Limit width on larger screens
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildWelcomeHeader(username), // Rectangle 1
                    const SizedBox(height: 30),

                    // Avatar with updated logic
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/profile',
                        arguments: {'username': username, 'userData': userData},
                      ),
                      child: CircleAvatar(
                        radius: 62, // Avatar 124x124 px
                        backgroundImage: avatarPath != null && avatarPath.isNotEmpty
                            ? AssetImage(avatarPath) // Use a local asset image
                            : AssetImage('assets/images/avatar1.png'), // Fallback local asset image
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        child: avatarPath == null || avatarPath.isEmpty
                            ? const Icon(
                          Icons.person, // Placeholder for anonymous profile
                          size: 40,
                          color: Colors.white,
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Points Display
                    Text(
                      'Points: $points',
                      style: const TextStyle(
                        fontFamily: 'ADLaM Display',
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 41),

                    // Select Difficulty Header
                    const Text(
                      'Select a Difficulty',
                      style: TextStyle(
                        fontFamily: 'ADLaM Display',
                        fontSize: 32,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Difficulty Buttons and Logout in 2x2 Grid
                    _buildDifficultyAndLogoutGrid(level, context, username, userData),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(String username) {
    return Container(
      width: double.infinity,
      height: 134,
      decoration: BoxDecoration(
        color: const Color(0xFFB7A6E0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withOpacity(0.4), width: 2), // Lighter border opacity
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Stronger shadow effect
            offset: const Offset(0, 5), // Larger offset for more prominence
            blurRadius: 20, // Increased blur for aesthetic shadow
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'Welcome back, $username!',
        style: const TextStyle(
          fontFamily: 'ADLaM Display',
          fontSize: 32,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDifficultyAndLogoutGrid(int level, BuildContext context, String username, Map<String, dynamic> userData) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: 1.2,
      children: [
        _buildDifficultyButton('Easy', level >= 1, context, username, userData),
        _buildDifficultyButton('Medium', level >= 2, context, username, userData),
        _buildDifficultyButton('Hard', level >= 3, context, username, userData),
        _buildLogoutButton(context),
      ],
    );
  }

  Widget _buildDifficultyButton(String difficulty, bool isUnlocked, BuildContext context, String username, Map<String, dynamic> userData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withOpacity(0.4), width: 2), // Lighter border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Stronger shadow
            offset: const Offset(0, 12), // Increased offset
            blurRadius: 24, // Aesthetic blur
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isUnlocked
            ? () => Navigator.pushNamed(
          context,
          '/difficulty',
          arguments: {'difficulty': difficulty, 'username': username, 'userData': userData},
        )
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB7A6E0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(160, 134),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              difficulty,
              style: const TextStyle(
                fontFamily: 'ADLaM Display',
                fontSize: 32,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Status',
              style: const TextStyle(
                fontFamily: 'Actor',
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isUnlocked ? 'Unlocked' : 'Locked',
              style: const TextStyle(
                fontFamily: 'ADLaM Display',
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
      icon: const Icon(Icons.logout, color: Colors.black),
      label: const Text(
        'Logout',
        style: TextStyle(
          fontFamily: 'ADLaM Display',
          fontSize: 32,
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB7A6E0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(160, 134),
      ),
    );
  }
}
