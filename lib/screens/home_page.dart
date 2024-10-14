import 'package:flutter/material.dart';
import 'dart:ui';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
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
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'The Kapampangan Language',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
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
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                              ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Kapampangan derives from the root word pampáng (\'riverbank\'). The language was previously spoken in the monarchy of Tondo, which was governed by the Lakans. Several Kapampangan dictionaries and grammar books were written during the Spanish colonial period.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: 3,
                        children: [
                          _buildDifficultyButton(context, 'Easy',
                              isLocked: false),
                          _buildDifficultyButton(context, 'Medium',
                              isLocked: true),
                          _buildDifficultyButton(context, 'Hard',
                              isLocked: true),
                        ],
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

  Widget _buildDifficultyButton(BuildContext context, String difficulty,
      {required bool isLocked}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isLocked
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: isLocked
                  ? null
                  : () => Navigator.pushNamed(
                        context,
                        '/difficulty',
                        arguments: difficulty,
                      ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    difficulty,
                    style: TextStyle(
                      color: isLocked ? Colors.grey : Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  if (isLocked) ...[
                    SizedBox(width: 10),
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
