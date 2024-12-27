import 'package:flutter/material.dart';
import 'Quiz3.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubjectPage extends StatefulWidget {
  final int quizId;
  final int userId;

  SubjectPage({required this.quizId, required this.userId});

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch the user's name when the page is loaded
    _fetchUserName(widget.userId);
  }

  Future<void> _fetchUserName(int userId) async {
    final url = Uri.parse('http://localhost:8080/user/uid/$userId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final user = json.decode(response.body);
        final username = user['username'];

        // Update the text field with the username
        _nameController.text = username;
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to fetch user data'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error fetching user data'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icône et titre
            Column(
              children: [
                const SizedBox(height: 50),
                // Icône Question
                Image.asset(
                  'assets/quiz1.png', // Chemin de l'image
                  height: 250,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image_not_supported, size: 100, color: Colors.red);
                  },
                ),
                const SizedBox(height: 25),
                // Titre SUBJECT
                const Text(
                  "SUBJECT",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),

            // Champ de texte et bouton START
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter your name",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Your Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bouton START
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final name = _nameController.text.trim();
                        if (name.isNotEmpty) {
                          // Redirection vers la page Quiz3
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DevOpsQuizPage(
                                quizId: widget.quizId,
                                userId: widget.userId,
                              ),
                            ),
                          );
                        } else {
                          // Affichage d'une alerte si le champ est vide
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please enter your name!",
                                style: TextStyle(fontSize: 16),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "START",
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

            const SizedBox(height: 30), // Espace supplémentaire
          ],
        ),
      ),
    );
  }
}
