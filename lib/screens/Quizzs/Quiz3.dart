import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Quiz4.dart'; // Import the page to show quiz results

void main() {
  runApp(MaterialApp(
    home: DevOpsQuizPage(quizId: 52, userId: 1), // Pass quizId and userId for testing
    debugShowCheckedModeBanner: false,
  ));
}

class DevOpsQuizPage extends StatefulWidget {
  final int userId;
  final int quizId;

  DevOpsQuizPage({required this.quizId, required this.userId});

  @override
  _DevOpsQuizPageState createState() => _DevOpsQuizPageState();
}

class _DevOpsQuizPageState extends State<DevOpsQuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;

  List<Question> _questions = []; // List to store questions
  List<UserQNA> _userQnAs = []; // List to store user answers

  @override
  void initState() {
    super.initState();
    _fetchQuestions(widget.quizId); // Fetch questions based on quizId
  }

  Future<void> _fetchQuestions(int quizId) async {
    final response = await http.get(Uri.parse('http://localhost:8080/question/quiz/$quizId'));

    if (response.statusCode == 200) {
      final List<dynamic> questionsJson = jsonDecode(response.body);
      setState(() {
        _questions = questionsJson.map((json) => Question.fromJson(json)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load questions')),
      );
    }
  }

  Future<void> _submitResult() async {
    // Initialize a variable to count the correct answers
    int correctAnswerCount = 0;

    // Loop through each question and compare the selected answer with the correct one
    for (int i = 0; i < _questions.length; i++) {
      var question = _questions[i];
      String userAnswer = question.options[_selectedAnswer!];

      // Fetch the correct answer for the question
      final response = await http.get(Uri.parse('http://localhost:8080/question/quesid/${question.id}'));

      if (response.statusCode == 200) {
        final questionData = jsonDecode(response.body);
        String correctAnswer = questionData['answer']; // Correct answer from the question table

        // Compare userAnswer with correctAnswer
        if (userAnswer == correctAnswer) {
          correctAnswerCount++;
        }

        // Add the user's answer to the list of user answers
        _userQnAs.add(UserQNA(
          quesid: question.id,
          answer: userAnswer,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load question details')),
        );
      }
    }

    // Prepare result data
    final result = Result(
      uid: widget.userId,
      quizid: widget.quizId,
      numofquestions: _questions.length,
      correctanswers: correctAnswerCount, // The correct answer count
      marksgot: correctAnswerCount * 10, // Example calculation for marks
      attempted: _questions.length,
      date: DateTime.now().toString(),
      userqnas: _userQnAs,
    );

    // Send result data to backend
    final response = await http.post(
      Uri.parse('http://localhost:8080/result/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(result.toJson()),
    );

    if (response.statusCode == 200) {
      final resultData = jsonDecode(response.body);
      final resultId = resultData['resultid']; // Retrieve resultId from the response

      // If the result is successfully submitted, navigate to the results page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultsPage(
            userId: widget.userId,
            quizId: widget.quizId,
            resultId: resultId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit results')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Center(child: CircularProgressIndicator()); // Show loading indicator if questions are not loaded
    }

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
            // Question Counter
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

            // Answer Options
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

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedAnswer != null) {
                    // If all questions are answered, submit the result
                    if (_currentQuestionIndex < _questions.length - 1) {
                      setState(() {
                        _currentQuestionIndex++;
                        _selectedAnswer = null;
                      });
                    } else {
                      // Submit the result and redirect to results page
                      _submitResult();
                    }
                  } else {
                    // Show alert if no answer is selected
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

// Question class
class Question {
  final String text;
  final List<String> options;
  final int correctIndex;
  final int id;

  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.id,
  });

  // Factory method to create Question from JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['content'] ?? '', // Default empty string if null
      options: [
        json['option1'] ?? '', // Default empty string if null
        json['option2'] ?? '',
        json['option3'] ?? '',
        json['option4'] ?? ''
      ],
      correctIndex: json['answer'] == json['option1']
          ? 0
          : json['answer'] == json['option2']
              ? 1
              : json['answer'] == json['option3']
                  ? 2
                  : 3,
      id: json['quesid'],
    );
  }
}

// UserQNA class
class UserQNA {
  final int quesid;
  final String answer;

  UserQNA({
    required this.quesid,
    required this.answer,
  });
}

// Result class to send to the backend
class Result {
  final int uid;
  final int quizid;
  final int numofquestions;
  final int correctanswers;
  final int marksgot;
  final int attempted;
  final String date;
  final List<UserQNA> userqnas;

  Result({
    required this.uid,
    required this.quizid,
    required this.numofquestions,
    required this.correctanswers,
    required this.marksgot,
    required this.attempted,
    required this.date,
    required this.userqnas,
  });

  // Convert the result object to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'quizid': quizid,
      'numofquestions': numofquestions,
      'correctanswers': correctanswers,
      'marksgot': marksgot,
      'attempted': attempted,
      'date': date,
      'userqnas': userqnas.map((qna) => {
        'quesid': qna.quesid,
        'answer': qna.answer,
      }).toList(),
    };
  }
}
