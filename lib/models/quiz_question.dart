import 'package:objectbox/objectbox.dart';

@Entity()
class QuizQuestion {
  @Id()
  int id = 0;

  String question;
  List<String> choices;
  String correctAnswer;
  String difficulty;
  final String? imagePath;

  QuizQuestion({
    required this.question,
    required this.choices,
    required this.correctAnswer,
    required this.difficulty,
    this.imagePath,
  });
}
