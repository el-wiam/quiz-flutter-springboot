import 'package:flutter/material.dart';
import 'Quiz2.dart'; // Importation de Quiz2.dart

class TopicPage extends StatelessWidget {
  final List<String> frames = [
    "DevOps - Débutant",
    "DevOps - Intermediaire",
    "Kubernetes",
    "Docker"
  ];

  final List<String> images = [
    "assets/QD1.png",
    "assets/QD2.png",
    "assets/QD3.png",
    "assets/QD4.png"
  ];

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
              // Action pour l'icône d'aide
            },
          ),
        ],
        centerTitle: true,
        title: Text(
          "DevOps",
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
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Nombre de colonnes
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1, // Taille des éléments
          ),
          itemCount: frames.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Redirection conditionnelle
                if (frames[index] == "DevOps - Débutant") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubjectPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Cette section n'est pas encore disponible : ${frames[index]}"),
                    ),
                  );
                }
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
                    // Image dans chaque cadre
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          images[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // Texte sous l'image
                    Text(
                      frames[index],
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
