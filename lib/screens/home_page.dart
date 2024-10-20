import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String username = arguments['username'];
    final Map<String, dynamic> userData = arguments['userData'];

    int points = userData['points'] ?? 0;
    String avatarPath = userData['avatar'] ?? '';
    int level = userData['level'];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7), // Softer background tone
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(), // Smooth scrolling
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildWelcomeHeader(context, username, userData),
                    const SizedBox(height: 40),
                    _buildAvatar(avatarPath, username, userData, context),
                    const SizedBox(height: 30),
                    _buildPointsDisplay(points),
                    const SizedBox(height: 35),
                    const Text(
                      'Select a Difficulty',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDifficultyGrid(level, context, username, userData),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(
      BuildContext context, String username, Map<String, dynamic> userData) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: const Color(0xFF6A4C93),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.person_outline, color: Colors.white, size: 32),
          Expanded(
            child: Center(
              child: Text(
                'Welcome back, $username!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              '/profile',
              arguments: {'username': username, 'userData': userData},
            ),
            child: const Icon(Icons.settings, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(
      String avatarPath, String username, Map<String, dynamic> userData, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/profile',
        arguments: {'username': username, 'userData': userData},
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 80, // Slightly larger for prominence
            backgroundImage: avatarPath.isNotEmpty
                ? AssetImage(avatarPath)
                : const AssetImage('assets/images/avatar1.png'),
            backgroundColor: Colors.grey[300],
            child: avatarPath.isEmpty
                ? const Icon(
              Icons.person,
              size: 60,
              color: Colors.white70,
            )
                : null,
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.greenAccent.shade700,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.check_circle,
              size: 28,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsDisplay(int points) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.star, size: 32, color: Colors.amber),
        const SizedBox(width: 8),
        Text(
          'Points: $points',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyGrid(int level, BuildContext context,
      String username, Map<String, dynamic> userData) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: 1.2,
      children: [
        _buildDifficultyButton('Easy', level >= 1, context, username, userData),
        _buildDifficultyButton(
            'Medium', level >= 2, context, username, userData),
        _buildDifficultyButton('Hard', level >= 3, context, username, userData),
        _buildLogoutButton(context),
      ],
    );
  }

  Widget _buildDifficultyButton(String difficulty, bool isUnlocked,
      BuildContext context, String username, Map<String, dynamic> userData) {
    return ElevatedButton(
      onPressed: isUnlocked
          ? () => Navigator.pushNamed(
        context,
        '/difficulty',
        arguments: {
          'difficulty': difficulty,
          'username': username,
          'userData': userData,
        },
      )
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isUnlocked
            ? const Color(0xFFB58DB6)
            : Colors.grey[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(20),
        shadowColor: Colors.black45,
        elevation: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            difficulty,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Icon(
            isUnlocked ? Icons.lock_open : Icons.lock,
            size: 24,
            color: Colors.white70,
          ),
          const SizedBox(height: 4),
          Text(
            isUnlocked ? 'Unlocked' : 'Locked',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
      icon: const Icon(Icons.logout, size: 30, color: Colors.white),
      label: const Text(
        'Logout',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6A4C93),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        elevation: 10,
      ),
    );
  }
}
