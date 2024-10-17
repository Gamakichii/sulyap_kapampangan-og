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
      choices: ['Mabayat', 'Dalan', 'Ditak', 'Malagad'],
      correctAnswer: 'Mabayat',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/mabayat.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Manuk', 'Anak', 'Bale', 'Buri'],
      correctAnswer: 'Bale',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/bale.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Mukha', 'Lupa', 'Mata', 'Arap'],
      correctAnswer: 'Lupa',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/lupa.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Pitudturan', 'Masakit', 'Masaya', 'Malungkut'],
      correctAnswer: 'Pidtudturan',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/pitudturan.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Bayu', 'Pamangan', 'Sagin', 'Manuk'],
      correctAnswer: 'Pamangan',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/pamangan.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Ditak', 'Danum', 'Dakal', 'Dalan'],
      correctAnswer: 'Danum',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/danum.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Pusa', 'Asu', 'Babi', 'Manuk'],
      correctAnswer: 'Asu',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/asu.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Punu', 'Dutung', 'Bunga', 'Bulung'],
      correctAnswer: 'Punu',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/punu.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Palaman', 'Bulung', 'Bunga', 'Tanaman'],
      correctAnswer: 'Tanaman',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/tanaman.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Pabanglu', 'Malagad', 'Manyaman', 'Malalam'],
      correctAnswer: 'Pabanglu',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/pabanglu.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Bengi', 'Aldo', 'Awang', 'Bayu'],
      correctAnswer: 'Awang',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/awang.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Manuk', 'Babi', 'Pusa', 'Ebun'],
      correctAnswer: 'Ebun',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/ebun.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Matuling', 'Maputi', 'Kupia', 'Malutu'],
      correctAnswer: 'Kupia',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/kupia.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Luklukan', 'Dalan', 'Bale', 'Dutung'],
      correctAnswer: 'Luklukan',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/luklukan.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Anak', 'Pasbul', 'Mata', 'Arap'],
      correctAnswer: 'Pasbul',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/pasbul.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Mata', 'Arap', 'Bitis', 'Bulung'],
      correctAnswer: 'Bitis',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/bitis.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Dalan', 'Bale', 'Pisamban', 'Eskuela'],
      correctAnswer: 'Dalan',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/dalan.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Manuk', 'Asan', 'Babi', 'Damulag'],
      correctAnswer: 'Manuk',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/manuk.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Dutung', 'Batu', 'Bulung', 'Danum'],
      correctAnswer: 'Dutung',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/dutung.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Matuling', 'Maputi', 'Malutu', 'Madilim'],
      correctAnswer: 'Matuling',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/matuling.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Matua', 'Anak', 'Pengari', 'Kapatad'],
      correctAnswer: 'Matua',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/matua.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Kanan', 'Kayli', 'Babo', 'Lalam'],
      correctAnswer: 'Kayli',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/kayli.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Marimla', 'Mapali', 'Matas', 'Mababa'],
      correctAnswer: 'Marimla',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/marimla.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Pisamban', 'Eskuela', 'Ospital', 'Tindahan'],
      correctAnswer: 'Pisamban',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/pisamban.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Malutu', 'Maputla', 'Matuling', 'Maputi'],
      correctAnswer: 'Malutu',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/malutu.png', // Update with the actual image path
    ),
    QuizQuestion(
      choices: ['Yelu', 'Danum', 'Api', 'Angin'],
      correctAnswer: 'Yelu',
      difficulty: 'Easy',
      imagePath:
          'assets/easy_mode_images/yelu.png', // Update with the actual image path
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
