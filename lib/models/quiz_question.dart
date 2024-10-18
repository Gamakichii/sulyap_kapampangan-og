import 'package:objectbox/objectbox.dart';

@Entity()
class QuizQuestion {
  @Id()
  int id = 0;

  String? question;
  List<String>? choices; // Make choices optional
  String correctAnswer;
  String difficulty;
  String? imagePath;

  QuizQuestion({
    this.question,
    this.choices, // Optional now
    required this.correctAnswer,
    required this.difficulty,
    this.imagePath,
  });
}
