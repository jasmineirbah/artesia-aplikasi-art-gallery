import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:artesia_aplikasi_art_gallery/services/game_service.dart';
import '../../controllers/shake_controller.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List questions = [];
  int currentIndex = 0;
  int score = 0;
  bool isLoading = true;
  final ShakeController shakeController = ShakeController();

  String? selectedAnswer;

  @override
  void initState() {
    super.initState();

    loadGame();

    shakeController.start(() {
      print("SHAKE DETECTED"); // 🔥 TAMBAH INI
      skipQuestion();
    });
  }

  @override
  void dispose() {
    shakeController.dispose();
    super.dispose();
  }

 void skipQuestion() {
    setState(() {
      currentIndex = (currentIndex + 1) % questions.length;
      selectedAnswer = null;
    });
  }

  Future<void> loadGame() async {
    final data = await GameService().fetchQuestions();

    data.shuffle();

    setState(() {
      questions = data.take(5).toList();
      isLoading = false;
    });
  }

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });

    final correct = questions[currentIndex]['correct_answer'];

    if (answer == correct) {
      score++;
    }

    Future.delayed(const Duration(milliseconds: 700), () {
      if (currentIndex < questions.length - 1) {
        setState(() {
          currentIndex++;
          selectedAnswer = null;
        });
      } else {
        showResult();
      }
    });
  }

  void showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Finished 🎉"),
        content: Text("Score kamu: $score / 5"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentIndex = 0;
                score = 0;
                loadGame();
              });
            },
            child: const Text("Main Lagi"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// 🔥 1. LOADING
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    /// 🔥 2. DATA KOSONG
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No questions found")),
      );
    }

    final q = questions[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// 🔙 BACK + PROGRESS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    "${currentIndex + 1} / 5",
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 🖼 IMAGE
              Container(
                height: 250,
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Image.network(
                  q['image'],
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              /// ❓ QUESTION
              Text(
                q['question'],
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// 🔘 OPTIONS
              Column(
                children: List.generate(q['options'].length, (index) {
                  final option = q['options'][index];

                  final isSelected = selectedAnswer == option;
                  final isCorrect =
                      option == q['correct_answer'];

                  Color bgColor = Colors.white;

                  if (selectedAnswer != null) {
                    if (isCorrect) {
                      bgColor = Colors.green.shade100;
                    } else if (isSelected) {
                      bgColor = Colors.red.shade100;
                    }
                  }

                  return GestureDetector(
                    onTap: selectedAnswer == null
                        ? () => selectAnswer(option)
                        : null,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        option,
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}