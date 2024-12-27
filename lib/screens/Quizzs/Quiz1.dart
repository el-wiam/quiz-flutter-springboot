import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Quiz2.dart';  // Page to show quiz questions
import 'package:fluttertoast/fluttertoast.dart'; // for toast messages (optional)

class TopicPage extends StatefulWidget {
  final int categoryId;
  final int userId;
  
  TopicPage({required this.categoryId, required this.userId});

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  List<Map<String, dynamic>> quizzes = [];

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    final response = await http.get(Uri.parse('http://localhost:8080/quiz/category/${widget.categoryId}'));

    if (response.statusCode == 200) {
      final List<dynamic> quizData = jsonDecode(response.body);
      setState(() {
        quizzes = List<Map<String, dynamic>>.from(quizData);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load quizzes')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.account_circle, color: Colors.white, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white, size: 28),
            onPressed: () {
              // Add help functionality here
            },
          ),
        ],
        centerTitle: true,
        title: Text(
          "Quizzes",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[700],
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: quizzes.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1, // Size of each item
                ),
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      final quiz = quizzes[index];
                      final quizId = quiz['quizid'];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubjectPage(quizId: quizId ,userId: widget.userId), // Pass quizId to next page
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                'http://localhost:8080/uploads/${quizzes[index]['image']}', // Use the image URL
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, color: Colors.red); // Handle error
                                },
                              ),
                            ),
                          ),
                          Text(
                            quizzes[index]['title'], // Display quiz title
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
