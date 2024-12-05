import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Column(
        children: [
          // Barre supérieure stylisée avec icône de retour
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.lightBlue[300],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Stack(
              children: [
                // Icône de retour en arrière
                Positioned(
                  top: 40, // Ajuste la position verticale
                  left: 20, // Ajuste la position horizontale
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Retour à la page précédente
                    },
                  ),
                ),
                // Texte Notifications au centre
                const Center(
                  child: Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Liste des notifications
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Nombre d'éléments dans la liste
              itemBuilder: (context, index) {
                return NotificationTile(
                  title: "Title ${index + 1}",
                  description: "Description for notification ${index + 1}",
                  time: "9:4${index} AM",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String description;
  final String time;

  const NotificationTile({
    required this.title,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(
            Icons.notifications_active,
            color: Colors.lightBlue,
            size: 36,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          trailing: Text(
            time,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
