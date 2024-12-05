import 'package:flutter/material.dart';
import 'Quiz5.dart';
class QuizResultsPage extends StatelessWidget {
  final String userName; // Nom de l'utilisateur
  final int score; // Score de l'utilisateur
  final int totalQuestions; // Nombre total de questions

  QuizResultsPage({
    required this.userName,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blueGrey),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
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
                // Photo de profil
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/Profil.png'),
                ),
                const SizedBox(height: 10),

                // Nom de l'utilisateur
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 15),

                // Message de félicitations
                const Text(
                  "CONGRATULATIONS!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),

                // Texte "Your score"
                const Text(
                  "Your score",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // Icône et score
                Image.asset(
                  'assets/Congrats.png',
                  height: 80,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.emoji_events,
                    size: 80,
                    // color: Colors.teal,
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

                // Barre de progression
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: score / totalQuestions,
                    backgroundColor: Colors.grey[300],
                    color: Colors.teal,
                    minHeight: 12,
                  ),
                ),
                const SizedBox(height: 30),

                // Bouton Next
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Ajoutez votre logique de redirection ici
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderboardPage()),);
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
