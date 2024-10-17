import 'package:flutter/material.dart';
import 'dart:ui';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/login'),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFB7A6E0), // Background color
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                    Column(
                      children: [
                        Image.asset(
                          'assets/logo.png', // Add the correct path to the image file
                          width: 200, // Set width as desired
                          height: 200, // Set height as desired
                        ),
                        SizedBox(height: 16), // Space between the image and the title
                        Text(
                          'Sulyap Kapampangan',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.white, // Text color
                          ),
                        ),
                        Text(
                          'Pamagaral keng penibatan',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                            fontSize: 16, // Reduced font size
                            color: Colors.white, // Text color
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                    SizedBox(height: 50), // Adjust spacing as needed
                  ],
                ),
                Positioned(
                  bottom: 49,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Tap anywhere to start',
                      style: TextStyle(
                        color: Colors.white, // White text color
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
