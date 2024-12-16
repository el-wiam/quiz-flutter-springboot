import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home.dart';
import 'screens/porfile.dart';
import 'screens/Menu.dart';
import 'screens/Reset_Password.dart';
import 'screens/Notification.dart';
import 'screens/Edit_profil.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home':(context) => TopicsPage(),
        '/profile':(context) => ProfilePage(),
        '/menu':(context) => MenuPage(),
        '/resetPassword':(context) => ResetPasswordPage(),
        '/notification':(context) => NotificationPage(),
        '/EditProfil':(context) => EditProfilePage(),
      },
    );
  }
}
