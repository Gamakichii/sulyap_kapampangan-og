import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sulyap_kapampangan/screens/login_page.dart';
import 'models/quiz_question.dart';
import 'screens/landing_page.dart';
import 'screens/home_page.dart';
import 'screens/difficulty_selection_page.dart';
import 'screens/quiz_page.dart';
import 'screens/profile_page.dart';
import 'screens/update_password_page.dart';
import 'objectbox.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();
  if (objectbox.quizQuestionBox.isEmpty()) {
    _populateDatabase();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SulyapKapampanganApp());
}

void _populateDatabase() {
  final questions = [
    // Easy questions (photo only)
    QuizQuestion(
      choices: ['Kotsi', 'Catsi', 'Kutse', 'Carsi'],
      correctAnswer: 'Kotsi',
      difficulty: 'Easy',
      imagePath: 'assets/easy_mode_images/kotsi.png',
    ),
    QuizQuestion(
      choices: ['Itlog', 'Eglog', 'Ibon', 'Ebun'],
      correctAnswer: 'Ebun',
      difficulty: 'Easy',
      imagePath: 'assets/egg.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Sombrero', 'Kupia', 'Cupa', 'Capia'],
      correctAnswer: 'Kupia',
      difficulty: 'Easy',
      imagePath: 'assets/cap.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Luklukan', 'Bukbukan', 'Upuan', 'Sukuan'],
      correctAnswer: 'Luklukan',
      difficulty: 'Easy',
      imagePath: 'assets/chair.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Rasbul', 'Pasbul', 'Pintu', 'Pastu'],
      correctAnswer: 'Pasbul',
      difficulty: 'Easy',
      imagePath: 'assets/door.png', // Update with the actual image path
    ),
  ];

  objectbox.quizQuestionBox.putMany(questions);
  print("Inserted ${questions.length} questions into the database.");
}

class SulyapKapampanganApp extends StatelessWidget {
  const SulyapKapampanganApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sulyap Kapampangan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.pathwayGothicOneTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ).copyWith(
          displayLarge: GoogleFonts.pathwayGothicOne(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          displayMedium:
              GoogleFonts.pathwayGothicOne(fontSize: 24, color: Colors.white),
          bodyLarge:
              GoogleFonts.pathwayGothicOne(fontSize: 16, color: Colors.white),
          bodyMedium:
              GoogleFonts.pathwayGothicOne(fontSize: 14, color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            textStyle: GoogleFonts.pathwayGothicOne(fontSize: 16),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/login': (context) => LoginPage(),
        '/profile': (context) => ProfilePage(
              username: ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/updatePassword': (context) => UpdatePasswordPage(
              username: ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/home': (context) => HomePage(),
        '/difficulty': (context) => DifficultySelectionPage(),
        '/quiz': (context) => QuizPage(),
      },
    );
  }
}
