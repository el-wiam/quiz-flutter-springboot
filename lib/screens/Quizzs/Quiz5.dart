import 'package:flutter/material.dart';


class LeaderboardPage extends StatelessWidget {
  // Liste statique pour les utilisateurs et leurs scores
  final List<Map<String, dynamic>> leaderboardData = [
    {"name": "user**", "score": 8, "position": 2, "image": "assets/user1.png"},
    {"name": "wiam", "score": 9, "position": 1, "image": "assets/user2.png"},
    {"name": "user*", "score": 7, "position": 3, "image": "assets/user3.png"},
    {"name": "user1", "score": 6, "position": 4, "image": "assets/user4.png"},
    {"name": "user2", "score": 6, "position": 5, "image": "assets/user5.png"},
  ];

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
          // Top 3 utilisateurs avec un style spécial
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTopUser(leaderboardData[0], 70, Colors.grey),
                _buildTopUser(leaderboardData[1], 90, Colors.amber), // Crowned winner
                _buildTopUser(leaderboardData[2], 70, Colors.brown),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Liste des autres utilisateurs
          Expanded(
            child: ListView.builder(
              itemCount: leaderboardData.length - 3,
              itemBuilder: (context, index) {
                final user = leaderboardData[index + 3];
                return _buildUserTile(user);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour les utilisateurs du Top 3
  Widget _buildTopUser(Map<String, dynamic> user, double size, Color borderColor) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 4),
          ),
          child: CircleAvatar(
            radius: size / 2,
            backgroundImage: AssetImage(user["image"]),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          user["name"],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          "${user["score"]}/10",
          style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
        ),
      ],
    );
  }

  // Widget pour les autres utilisateurs dans la liste
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
