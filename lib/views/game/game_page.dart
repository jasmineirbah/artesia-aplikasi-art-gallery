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

  bool isStarted = false;
  bool isFinished = false;

  String? selectedAnswer;

  final ShakeController shakeController = ShakeController();

  @override
  void initState() {
    super.initState();

    // SHAKE SENSOR
    shakeController.start(() {
      skipQuestion();
    });

    loadGame();
  }

  @override
  void dispose() {
    shakeController.dispose();
    super.dispose();
  }

  // SKIP VIA SHAKE
  void skipQuestion() {
    if (!isStarted || isFinished) return;

    setState(() {
      currentIndex = (currentIndex + 1) % questions.length;
      selectedAnswer = null;
    });
  }

  Future<void> loadGame() async {
    final data = await GameService().fetchQuestions();

    final shuffled = List.from(data);
    shuffled.shuffle();

    final selected = shuffled.take(5).map((q) {
      final options = List<String>.from(q['options']);
      options.shuffle();

      return {
        ...q,
        'options': options,
      };
    }).toList();

    setState(() {
      questions = selected;
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
        setState(() {
          isFinished = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // LOADING
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // START PAGE
    if (!isStarted) {
      return Scaffold(
        backgroundColor: const Color(0xFFFBF9F4),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Art Quiz 🎨",
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                onPressed: () async {
                  setState(() {
                    isStarted = true;
                    isFinished = false;
                    currentIndex = 0;
                    score = 0;
                    selectedAnswer = null;
                    isLoading = true;
                  });

                  await loadGame();
                },
                child: const Text("Start Game"),
              ),
            ],
          ),
        ),
      );
    }

    // END PAGE
    if (isFinished) {
      return Scaffold(
        backgroundColor: const Color(0xFFFBF9F4),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Game Over 🎉",
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Score: $score / ${questions.length}",
                style: GoogleFonts.inter(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                onPressed: () async {
                  setState(() {
                    isFinished = false;
                    isStarted = false;
                    currentIndex = 0;
                    score = 0;
                    selectedAnswer = null;
                    isLoading = true;
                  });

                  await loadGame();
                },
                child: const Text("Play Again"),
              ),
            ],
          ),
        ),
      );
    }

    // GAME PAGE
    final q = questions[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// PROGRESS
                Text(
                  "${currentIndex + 1} / ${questions.length}",
                  style: GoogleFonts.inter(fontSize: 14),
                ),

                const SizedBox(height: 30),

                // IMAGE 
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 300,
                            maxHeight: 260,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              q['image'], 
                              fit: BoxFit.contain, 
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // QUESTION
                Text(
                  q['question'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // OPTIONS
                Column(
                  children:
                      List.generate(q['options'].length, (index) {
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

                    return Center(
                      child: Container(
                        constraints:
                            const BoxConstraints(maxWidth: 300),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: selectedAnswer == null
                              ? () => selectAnswer(option)
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade300),
                            ),
                            child: Center(
                              child: Text(
                                option,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}