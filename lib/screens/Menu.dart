import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'Reset_Password.dart';
import 'Notification.dart';
import 'Edit_profil.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture with Help Icon
            Stack(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/Profil.png'),
                ),
                // Positioned(
                //   top: 0,
                //   right: 0,
                //   child: Icon(
                //     Icons.help_outline,
                //     color: Colors.blueGrey,
                //     size: 45,
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 25),

            // Username Text
            const Text(
              "Username",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 40),

            // Options List
            ProfileOption(
              icon: Icons.notifications, 
              label: "Notifications",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
            ),
            ProfileOption(
              icon: Icons.edit, 
              label: "Edit Profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),
            ProfileOption(
              icon: Icons.lock_reset,
              label: "Reset Password",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                );
              },
            ),
            ProfileOption(
              icon: Icons.logout,
              label: "Log Out",
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const ProfileOption({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Action à exécuter lors du clic
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.blueGrey,
              size: 26,
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
