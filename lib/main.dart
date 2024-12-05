import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home.dart';
import 'screens/porfile.dart';
import 'screens/Menu.dart';
import 'screens/Reset_Password.dart';
import 'screens/Notification.dart';
import 'screens/Edit_profil.dart';
import 'screens/Quizzs/Quiz1.dart';
import 'screens/Quizzs/Quiz2.dart';
import 'screens/Quizzs/Quiz3.dart';
import 'screens/Quizzs/Quiz4.dart';
import 'screens/Quizzs/Quiz5.dart';
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
        '/Quiz1':(context) => TopicPage(),
        '/Quiz2':(context) => SubjectPage(),
        '/Quiz3':(context) => DevOpsQuizPage(),
        '/Quiz4':(context) => QuizResultsPage(userName: "Fati", score: 9,totalQuestions: 10,),
        '/Quiz5':(context) => LeaderboardPage(),
      },
    );
  }
}
