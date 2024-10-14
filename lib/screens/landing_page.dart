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
            image: DecorationImage(
              image: AssetImage('assets/background1.png'),
              fit: BoxFit.cover,
            ),
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
                        Text(
                          'Sulyap Kapampangan',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text(
                          'Pamagaral keng penibatan',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                            fontSize: 16, // Reduced font size
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
                      style: TextStyle(color: Colors.white, fontSize: 16),
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