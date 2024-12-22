import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// void main() {
//   runApp(MaterialApp(
//     home: EditProfilePage(),
//   ));
// }

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _imageFile; // Variable pour stocker l'image sélectionnée
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // Fonction pour choisir une image
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Section supérieure avec titre
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Colors.blueGrey[300],
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
                            Icons.arrow_back, // Icône retour en arrière
                            color: Colors.blueGrey,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(
                                context); // Retour à la page précédente
                          },
                        ),
                      ),
                      // Titre "Edit Profile" centré
                      const Center(
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Photo de profil circulaire
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!) as ImageProvider
                      : AssetImage('assets/Profil.png'), // Image par défaut
                ),
                const SizedBox(height: 15),

                // Bouton pour télécharger l'image
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.upload, color: Colors.blueGrey),
                  label: const Text(
                    "Change Image",
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.grey,
                    elevation: 2,
                  ),
                ),
                const SizedBox(height: 30),

                // Champs de saisie
                CustomTextField(
                  controller: _emailController,
                  hintText: "Enter Email Address",
                  icon: Icons.close,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _usernameController,
                  hintText: "Enter Username",
                  icon: Icons.close,
                ),
                const SizedBox(height: 30),

                // Bouton Save Changes
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Logique après soumission
                    final email = _emailController.text;
                    final username = _usernameController.text;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Profile Updated!\nEmail: $email\nUsername: $username"),
                      ),
                    );
                  },
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 18, color: Colors.white),
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

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
        filled: true,
        fillColor: Colors.white,
        // suffixIcon: Icon(icon, color: Colors.redAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}
