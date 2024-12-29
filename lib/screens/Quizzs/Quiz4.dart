import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Quiz5.dart'; 

class QuizResultsPage extends StatefulWidget {
  final int userId;
  final int quizId;
  final int resultId;

  QuizResultsPage({
    required this.userId,
    required this.quizId,
    required this.resultId,
  });

  @override
  _QuizResultsPageState createState() => _QuizResultsPageState();
}

class _QuizResultsPageState extends State<QuizResultsPage> {
  String userName = "";
  int totalQuestions = 0;
  int score = 0;
  String userImage = "assets/Profil.png"; // Placeholder for user image
  String quizTitle = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchQuizData();
    _fetchResultData();
  }

  // Fetch user data using the userId
  Future<void> _fetchUserData() async {
    final response = await http.get(Uri.parse('http://localhost:8080/user/uid/${widget.userId}'));

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      setState(() {
        userName = userData['username'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load user data')));
    }
  }

  // Fetch quiz data using the quizId
  Future<void> _fetchQuizData() async {
    final response = await http.get(Uri.parse('http://localhost:8080/quiz/${widget.quizId}'));

    if (response.statusCode == 200) {
      final quizData = jsonDecode(response.body);
      setState(() {
        quizTitle = quizData['title'];
        totalQuestions = quizData['numofquestions'] ?? 0; // Ensure default value if null
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load quiz data')));
    }
  }

  // Fetch user result data using the resultId
  Future<void> _fetchResultData() async {
    final response = await http.get(Uri.parse('http://localhost:8080/result/${widget.resultId}'));

    if (response.statusCode == 200) {
      final resultData = jsonDecode(response.body);
      setState(() {
        // Get the total number of questions from the result
        totalQuestions = resultData['numofquestions'] ?? 0; // Ensure default value if null
        // Get the number of correct answers from the result
        score = resultData['correctanswers'] ?? 0; // Ensure default value if null
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load result data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle edge case where totalQuestions might be 0 or invalid
    double progressValue = (totalQuestions > 0) ? (score / totalQuestions) : 0.0;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blueGrey),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: const Text(
          "Quiz Results",
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile picture
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/Profil.png'),
                ),
                const SizedBox(height: 10),

                // User name
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 15),

                // Congratulations message
                const Text(
                  "CONGRATULATIONS!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),

                // "Your score" label
                const Text(
                  "Your score",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // Icon and score
                Image.asset(
                  'assets/Congrats.png',
                  height: 80,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.emoji_events,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  "$score / $totalQuestions",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 20),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progressValue, // Safe division value
                    backgroundColor: Colors.grey[300],
                    color: Colors.teal,
                    minHeight: 12,
                  ),
                ),
                const SizedBox(height: 30),

                // Next button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Redirect to leaderboard page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LeaderboardPage(userId : widget.userId , resultId:widget.resultId, quizId: widget.quizId)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
        ),
      ),
    );
  }
}
