import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sulyap_kapampangan/models/quiz_question.dart';
import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

late ObjectBox objectbox;

class ObjectBox {
  late final Store store;

  late final Box<QuizQuestion> quizQuestionBox;

  ObjectBox._create(this.store) {
    quizQuestionBox = Box<QuizQuestion>(store);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));
    return ObjectBox._create(store);
  }
}
