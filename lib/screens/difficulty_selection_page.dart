import 'package:flutter/material.dart';
import 'dart:ui'; // For ImageFilter

class DifficultySelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String difficulty =
        ModalRoute.of(context)!.settings.arguments as String;

    return SafeArea(
      top: false, // Allow the content to extend behind the status bar
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent, // Transparent AppBar
              elevation: 0, // Remove shadow
              iconTheme: IconThemeData(
                color: Colors.white, // Change the back arrow to white
              ),
              title: Text(
                '$difficulty Level',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white, // Ensure text stands out
                    ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Are you ready?',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white, // Ensure text is visible
                              ),
                    ),
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () => Navigator.pushNamed(
                                context, '/quiz',
                                arguments: difficulty),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                'Start Quiz',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16, // Adjust the font size here
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
