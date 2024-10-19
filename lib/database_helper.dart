import '../models/quiz_question.dart';
import '../objectbox.dart';

class DatabaseHelper {
  static void populateDatabase() {
    if (objectbox.quizQuestionBox.isEmpty()) {
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
          correctAnswer: 'Pitudturan',
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

        // Medium
        QuizQuestion(
          question: 'Have you eaten?',
          choices: [
            'Makananu ka?',
            'Nanu ing buri mu?',
            'Mengan na ka?',
            'Mako na ka?'
          ],
          correctAnswer: 'Mengan na ka?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "What's your name?",
          choices: [
            'Nanung oras na?',
            'Nokarin ka manuknangan?',
            'Nanung lagyu mu?',
            'Nanu ing obra mu?'
          ],
          correctAnswer: 'Nanung lagyu mu?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: 'How are you?',
          choices: [
            'Komusta ka?',
            'Makananu ka munta?',
            'Nanung aldo ini?',
            'Nanu ing buri mu?'
          ],
          correctAnswer: 'Komusta ka?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: 'Where are you going?',
          choices: [
            'Nokarin ka mengan?',
            'Nokarin ka munta?',
            'Nanu ing daraptan mu?',
            'Kapilan ka datang?'
          ],
          correctAnswer: 'Nokarin ka munta?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: 'Good morning!',
          choices: [
            'Mayap a bengi!',
            'Mayap a gatpanapun!',
            'Mayap a abak!',
            'Mayap a aldo!'
          ],
          correctAnswer: 'Mayap a abak!',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: 'Thank you very much!',
          choices: [
            'Salamat pu!',
            'Dakal a salamat!',
            'Mayap pu!',
            'Sige na pu!'
          ],
          correctAnswer: 'Dakal a salamat!',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "I don't understand",
          choices: [
            'Ali ku balu.',
            'E ku aintindian.',
            'Buri ku yan.',
            'Masaya ku.'
          ],
          correctAnswer: 'E ku aintindian.',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: 'What time is it?',
          choices: [
            'Nanung aldo ini?',
            'Pilan kang banua?',
            'Nanung oras na?',
            'Nokarin ka munta?'
          ],
          correctAnswer: 'Nanung oras na?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: 'I like this food.',
          choices: [
            'Manyaman ya ing pamangan.',
            'Buri ke ining pamangan.',
            'Mengan na ku.',
            'Ali ku buri ining pamangan.'
          ],
          correctAnswer: 'Buri ke ining pamangan.',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: 'See you tomorrow',
          choices: [
            'Mako na ku.',
            'Salamat pu.',
            'Mayap a bengi.',
            'Mikit ka ta bukas.'
          ],
          correctAnswer: 'Mikit ka ta bukas.',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: 'How old are you?',
          choices: [
            'Pilan na kang banua?',
            'Nanung oras na?',
            'Ninu ka?',
            'Nokarin ka munta?'
          ],
          correctAnswer: 'Pilan na kang banua?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "I'm hungry",
          choices: [
            'Mako na ku.',
            'Mayap a bengi.',
            'Maranup ku.',
            'Mapagal ku.'
          ],
          correctAnswer: 'Maranup ku.',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "What's the weather like today?",
          choices: [
            'Nanung oras na?',
            'Makananu ing panaun ngeni?',
            'Nanung lagyu mu?',
            'Nokarin ka manuknangan?'
          ],
          correctAnswer: 'Makananu ing panaun ngeni?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: 'I love you.',
          choices: [
            'Kaluguran daka.',
            'Salamat pu.',
            'Ali ku balu.',
            'Mayap a aldo.'
          ],
          correctAnswer: 'Kaluguran daka.',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: 'Can you help me?',
          choices: [
            'Malyari mu ku saupan?',
            'Nanung oras na?',
            'Mayap a gatpanapun!',
            'Nanu ing buri mu?'
          ],
          correctAnswer: 'Malyari mu ku saupan?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "I'm sorry.",
          choices: [
            'Mayap a abak!',
            'Pasensya.',
            'Salamat pu.',
            'Masanting ka?'
          ],
          correctAnswer: 'Pasensya.',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "What's your job?",
          choices: [
            'Nanu ing obra mu?',
            'Pilan ka banua?',
            'Nokarin ka munta?',
            'Nanung aldo ini?'
          ],
          correctAnswer: 'Nanu ing obra mu?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "Happy birthday!",
          choices: [
            'Mayap a kebaitan!',
            'Mayap a aldo!',
            'Salamat pu!',
            'Pasensya.'
          ],
          correctAnswer: 'Mayap a kebaitan!',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "How much is this?",
          choices: [
            'Magkanu ya ini?',
            'Nanu ing buri mu?',
            'Nokarin ka munta?',
            'Nanung oras na?'
          ],
          correctAnswer: 'Magkanu ya ini?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "I'm tired.",
          choices: ['Mapagal ku.', 'Maranup ku.', 'Masaya ku.', 'Mako na ku.'],
          correctAnswer: 'Mapagal ku.',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "Do you speak English?",
          choices: [
            'Makananu ka?',
            'Byasa ka mag-Ingles?',
            'Nanung lagyu mu?',
            'Nokarin ka manuknangan?'
          ],
          correctAnswer: 'Byasa ka mag-Ingles?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "Where do you live?",
          choices: [
            'Nanung aldo ini?',
            'Pilan ka banua?',
            'Nokarin ka makatuknang?',
            'Nanu ing obra mu?'
          ],
          correctAnswer: 'Nokarin ka makatuknang?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "I don't know.",
          choices: [
            'Ali ku balu.',
            'Salamat pu.',
            'Mayap a aldo.',
            'Mako na ku.'
          ],
          correctAnswer: 'Ali ku balu.',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "Nice to meet you.",
          choices: [
            'Agagalak dakang akilala.',
            'Mayap a bengi.',
            'Pasensya.',
            'Maranup ku.'
          ],
          correctAnswer: 'Agagalak dakang akilala.',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "What's your favorite food?",
          choices: [
            'Nanu ing paborito mung pamangan?',
            'Nanung oras na?',
            'Nokarin ka munta?',
            'Pilan ka banua?'
          ],
          correctAnswer: 'Nanu ing paborito mung pamangan?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "I'm thirsty.",
          choices: ['Mapagal ku.', 'Mako na ku.', 'Mau ku.', 'Maranup ku.'],
          correctAnswer: 'Mau ku.',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "Do you like it?",
          choices: [
            'Buri me?',
            'Ninu ka?',
            'Pilan ka banua?',
            'Nokarin ka manuknangan?'
          ],
          correctAnswer: 'Buri me?',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "I'm lost.",
          choices: [
            'Mewala ku.',
            'Mayap a aldo.',
            'Salamat pu.',
            'Maranup ku.'
          ],
          correctAnswer: 'Mewala ku.',
          difficulty: 'Medium',
        ),

        QuizQuestion(
          question: "Happy New Year!",
          choices: [
            'Masayang Bayung Banua!',
            'Mayap a kebaitan!',
            'Salamat pu!',
            'Pasensya.'
          ],
          correctAnswer: 'Masayang Bayung Banua!',
          difficulty: 'Medium',
        ),

        // Hard
        QuizQuestion(
          question: "Mabanglu ya itang seli kung (perfume/pabango) __________.",
          correctAnswer: 'pabanglu',
          difficulty: 'Hard',
          imagePath: null,
        ),

        QuizQuestion(
          question: "(Hungry/Gutom) _______ naku uling e ku mengan.",
          correctAnswer: 'maranup',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Sara me ing (door/pintuan) ________.",
          correctAnswer: 'pasbul',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question:
              "Ing kapatad ku (bought/bumili) _______ yang bayung sapatus.",
          correctAnswer: 'sinali ',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "(Tired/Pagod) _______ naku kaibat ning malyaring obra.",
          correctAnswer: 'malugud ',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Sopan mukung maminturang (roof/bubong) ________ pota.",
          correctAnswer: 'bubung',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Pakikwa itang (chair/upuan) ___________ kusina.",
          correctAnswer: 'luklukan',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Malambut ne ing (wheel/gulong) _______ mu, pabomba mune.",
          correctAnswer: 'gulung',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Mabilis ya ing seli mung (car/kotse) ________ magkanu ya?",
          correctAnswer: 'kotsi',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Tara mamyalung tamu kwanan me itang (ball/bola) _____.",
          correctAnswer: 'bola',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Masanting ya ing (weather/panahon) __________ ngeni.",
          correctAnswer: 'panaun',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Malagad kong mangan (vegetables/gulay) __________.",
          correctAnswer: 'gule',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question:
              "Masarap ya ing (food/pagkain) __________ king piestang iti.",
          correctAnswer: 'pamangan',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Makasilo ya ing (light/ilaw) __________ king kwartu.",
          correctAnswer: 'sulu',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Maragul ya ing (dog/aso) __________ ning siping bale.",
          correctAnswer: 'asu',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Masikan ya ing (wind/hangin) __________ ngeni.",
          correctAnswer: 'angin',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Masanting ya ing (color/kulay) __________ ning malan mu.",
          correctAnswer: 'kule',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Malapit ya ing (market/palengke) __________ king bale mi.",
          correctAnswer: 'palengki',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Malambut ya ing (pillow/unan) __________ ku.",
          correctAnswer: 'ulunan',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Masakit ya ing (head/ulo) __________ ku ngeni.",
          correctAnswer: 'buntuk',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Matua ne ing (grandfather/lolo) __________ ku.",
          correctAnswer: 'apu',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Masikan ya ing (rain/ulan) __________ ngeni.",
          correctAnswer: 'uran',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Matas ya ing (mountain/bundok) __________ a yan.",
          correctAnswer: 'bunduk',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Mapali ya ing (sun/araw) __________ ngeni.",
          correctAnswer: 'aldo',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Marimla ya ing (night/gabi) __________ ngeni.",
          correctAnswer: 'bengi',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Malati ya ing (nose/ilong) __________ ning anak ku.",
          correctAnswer: 'arung',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Masiksik la reng (people/tao) __________ king palengki.",
          correctAnswer: 'tau',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Manyaman ya ing (soup/sabaw) __________ keni.",
          correctAnswer: 'sabo',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "(Delicious/Masarap) ______ ya ing lutung Kapampangan.  ",
          correctAnswer: 'manyaman',
          difficulty: 'Hard',
        ),

        QuizQuestion(
          question: "Malati ya ing (road/kalsada) __________ papunta kekami.",
          correctAnswer: 'dalan',
          difficulty: 'Hard',
        ),
      ];

      objectbox.quizQuestionBox.putMany(questions);
      print("Inserted ${questions.length} questions into the database.");
    }
  }
}
