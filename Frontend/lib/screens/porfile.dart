import 'package:flutter/material.dart';
import 'Menu.dart';
import 'Edit_profil.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        elevation: 0, // Enlève l'ombre de l'AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blueGrey[700]),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.blueGrey[700]),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MenuPage()), // Affiche MenuPage
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue[100],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    // child: Icon(Icons.help_outline, color: Colors.blueGrey[700]),
                  ),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    'assets/Profil.png', // Remplace par ton URL d'image
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Username",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // Redirection vers la page Edit Profile
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text("Edit Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueGrey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TabButton(label: "History"),
              TabButton(label: "Progress"),
              TabButton(label: "Participate"),
              const Icon(Icons.add, color: Colors.blueGrey),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  ImageTile(imagePath: 'assets/Q1.png'),
                  ImageTile(imagePath: 'assets/Q2.png'),
                  ImageTile(imagePath: 'assets/Q3.png'),
                  ImageTile(imagePath: 'assets/Q4.png'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String label;

  const TabButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () {},
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey[700],
          ),
        ),
      ),
    );
  }
}

class ImageTile extends StatelessWidget {
  final String imagePath;

  const ImageTile({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(imagePath), // Utilise AssetImage
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
