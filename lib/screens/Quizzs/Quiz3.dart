import 'package:flutter/material.dart';
import 'Quiz4.dart'; // Importez la page des résultats

void main() {
  runApp(MaterialApp(
    home: DevOpsQuizPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class DevOpsQuizPage extends StatefulWidget {
  @override
  _DevOpsQuizPageState createState() => _DevOpsQuizPageState();
}

class _DevOpsQuizPageState extends State<DevOpsQuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0; // Compteur pour les réponses correctes
  int? _selectedAnswer;

  List<Question> _questions = [
    Question(
        text: "What does CI/CD stand for?",
        options: [
          "Code Integration / Code Deployment",
          "Continuous Integration / Continuous Deployment",
          "Central Integration / Continuous Delivery",
          "Code Installation / Continuous Delivery"
        ],
        correctIndex: 1),
    Question(
        text: "What is Docker primarily used for?",
        options: [
          "Virtual Machines",
          "Continuous Deployment",
          "Containerization",
          "CI Pipelines"
        ],
        correctIndex: 2),
  ];

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blueGrey),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Quiz",
          style: TextStyle(fontSize: 18, color: Colors.blueGrey),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Compteur de Questions
            Text(
              "${_currentQuestionIndex + 1}/${_questions.length}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 20),

            // Question
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                currentQuestion.text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Options de Réponses
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: RadioListTile<int>(
                      value: index,
                      groupValue: _selectedAnswer,
                      activeColor: Colors.blueGrey,
                      onChanged: (value) {
                        setState(() {
                          _selectedAnswer = value;
                        });
                      },
                      title: Text(
                        currentQuestion.options[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bouton Next
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedAnswer != null) {
                    // Vérifier si la réponse est correcte
                    if (_selectedAnswer == currentQuestion.correctIndex) {
                      _score++;
                    }

                    if (_currentQuestionIndex < _questions.length - 1) {
                      setState(() {
                        _currentQuestionIndex++;
                        _selectedAnswer = null;
                      });
                    } else {
                      // Rediriger vers la page Quiz4 à la fin
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizResultsPage(
                            userName: "Wiam", // Statique pour l'instant
                            score: _score,
                            totalQuestions: _questions.length,
                          ),
                        ),
                      );
                    }
                  } else {
                    // Alerte si aucune réponse n'est sélectionnée
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select an answer!"),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe Question
class Question {
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}
