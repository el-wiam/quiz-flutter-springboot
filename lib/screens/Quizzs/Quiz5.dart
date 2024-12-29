import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaderboardPage extends StatefulWidget {
  final int userId;
  final int quizId;
  final int resultId;

  LeaderboardPage({
    required this.userId,
    required this.quizId,
    required this.resultId,
  });

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> leaderboardData = []; 

  @override
  void initState() {
    super.initState();
    _fetchLeaderboardData();
  }

  // Fetch leaderboard data from the server
  Future<void> _fetchLeaderboardData() async {
    final response = await http.get(Uri.parse('http://localhost:8080/result/all'));

    if (response.statusCode == 200) {
      final List<dynamic> resultData = jsonDecode(response.body);
      
      // Filter results based on the current quizId and sort by correctanswers
      final filteredResults = resultData
          .where((result) => result['quizid'] == widget.quizId)
          .toList();
      
      // Add the current user's result to the leaderboard
      final currentUserResult = filteredResults.firstWhere(
        (result) => result['uid'] == widget.userId,
        orElse: () => null,
      );

      // If the user has taken the quiz, add them to the leaderboard
      if (currentUserResult != null) {
        leaderboardData.add({
          "name": "You",
          "score": currentUserResult['correctanswers'],
          "position": leaderboardData.length + 1,
          "image": "assets/user1.png", // Placeholder for user image
        });
      }

      // Add other users' results to the leaderboard
      filteredResults.forEach((result) {
        if (result['uid'] != widget.userId) {
          leaderboardData.add({
            "name": "User ${result['uid']}",
            "score": result['correctanswers'],
            "position": leaderboardData.length + 1,
            "image": "assets/user2.png", // Placeholder for user image
          });
        }
      });

      // Sort leaderboard by score in descending order
      leaderboardData.sort((a, b) => b['score'].compareTo(a['score']));

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load leaderboard data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Leaderboard",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Display leaderboard data
          Expanded(
            child: ListView.builder(
              itemCount: leaderboardData.length,
              itemBuilder: (context, index) {
                final user = leaderboardData[index];
                return _buildUserTile(user);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display a user tile
  Widget _buildUserTile(Map<String, dynamic> user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              "${user["position"]}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(width: 20),
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(user["image"]),
            ),
            const SizedBox(width: 20),
            Text(
              user["name"],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Text(
              "${user["score"]}/10",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
