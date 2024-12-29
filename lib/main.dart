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
import 'screens/CR_Quizz/CR_Q3.dart';
import 'screens/CR_Quizz/CR_Q1.dart' as CRQ1;
import 'screens/CR_Quizz/CR_Q2.dart' as CRQ2;

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
        '/home': (context) => TopicsPage(userId: 0,),
        '/profile': (context) => ProfilePage(userId: 0,),
        '/menu': (context) => MenuPage(),
        '/resetPassword': (context) => ResetPasswordPage(),
        '/notification': (context) => NotificationPage(),
        '/EditProfil': (context) => EditProfilePage(),
        '/Quiz1': (context) => TopicPage(categoryId: 0, userId: 0,),
        '/Quiz2': (context) => SubjectPage(quizId: 0, userId: 0,),
        '/Quiz3': (context) => DevOpsQuizPage(quizId: 0, userId: 0,),
        '/Quiz4': (context) => QuizResultsPage(userId: 0, resultId: 0, quizId: 0,),
        '/Quiz5': (context) => LeaderboardPage(userId: 0, quizId: 0, resultId: 0,),
        '/CR_Q1': (context) => CRQ1.CreateQuizPage(), // Specify the alias
        '/CR_Q2': (context) => CRQ2.SetQuestionsPage(quizId: 3, questionCount: 0, quizTitle: '',),
        '/CR_Q3': (context) => QuizTopicPage(quizTitle: '', quizId: 0,),
      },
    );
  }
}
