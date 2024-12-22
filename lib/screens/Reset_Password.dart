import 'package:flutter/material.dart';

// void main() {
//   runApp(MaterialApp(
//     home: ResetPasswordPage(),
//   ));
// }

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Section décorée avec photo
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Colors.lightBlue[300],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage('assets/Profil.png'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // Titre
                const Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 50),

                // Champ New Password
                CustomTextField(
                  controller: _newPasswordController,
                  hintText: "New Password",
                  icon: Icons.close,
                ),
                const SizedBox(height: 30),

                // Champ Confirm Password
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: "Confirm Password",
                  icon: Icons.close,
                ),
                const SizedBox(height: 50),

                // Bouton Submit
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    elevation: 8,
                  ),
                  onPressed: () {
                    // Validation des champs
                    final newPassword = _newPasswordController.text;
                    final confirmPassword = _confirmPasswordController.text;

                    if (newPassword.isEmpty || confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please fill in both password fields."),
                        ),
                      );
                    } else if (newPassword != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Passwords do not match."),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Password successfully reset!"),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
      obscureText: true, // Cache le mot de passe
      style: const TextStyle(fontSize: 18), // Taille du texte des champs
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 18, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Colors.blueGrey,
          size: 28, // Taille de l'icône
        ),
        // suffixIcon: Icon(
        //   icon,
        //   color: Colors.redAccent,
        //   size: 28, // Taille de l'icône
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
      ),
    );
  }
}
