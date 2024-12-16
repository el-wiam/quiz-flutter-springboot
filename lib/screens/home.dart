import 'package:flutter/material.dart';
import 'Quizzs/Quiz1.dart'; // Importation de Quiz1.dart

class TopicsPage extends StatelessWidget {
  final List<String> topics = [
    "DevOps",
    "Data Science",
    "Développement Web",
    "Développement Mobile",
    "Sécurité et réseau"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(116, 156, 164, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile'); // Navigate to profile page
          },
          child: Icon(Icons.person, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.cloud, color: Colors.white),
          ),
        ],
        title: Center(
          child: Text(
            "TOPICS",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.blue.shade50,
        child: Column(
          children: [
            // Barre de recherche
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search topics',
                  prefixIcon: Icon(Icons.menu),
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            // Liste des Topics
            Expanded(
              child: ListView.builder(
                itemCount: topics.length, // 5 topics
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (topics[index] == "DevOps") {
                        // Redirige vers la page Quiz1
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TopicPage()),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26.0, vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(116, 156, 164, 158)
                                  .withOpacity(0.5),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: 100, // Hauteur des éléments
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(116, 156, 164, 158),
                              child: Icon(
                                Icons.topic,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              topics[index], // Affiche le topic
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text(
                              "Explore ${topics[index]} resources and updates.",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
