import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'QRcode.dart';
import 'porfile.dart';
import './Quizzs/Quiz1.dart';  // Import the new page to display quizzes

class TopicsPage extends StatefulWidget {
  final int userId;

  TopicsPage({required this.userId});

  @override
  _TopicsPageState createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  List<String> topics = [];
  List<String> filteredTopics = [];
  List<int> categoryIds = []; // List to hold category IDs
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    searchController.addListener(_filterCategories);
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse('http://localhost:8080/category/all'));

    if (response.statusCode == 200) {
      final List<dynamic> categories = jsonDecode(response.body);
      setState(() {
        // Safely extract category IDs ensuring non-null
        topics = categories.map((cat) => cat['title'].toString()).toList();
        categoryIds = categories.map<int>((cat) {
          final catId = cat['catid'];
          return catId != null ? catId as int : -1;  // If catId is null, set to -1 or handle as necessary
        }).toList();
        filteredTopics = List.from(topics);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load categories')));
    }
  }

  void _filterCategories() {
    setState(() {
      filteredTopics = topics
          .where((topic) => topic.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> _showCategoryDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Enter category title'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Enter category description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                final title = titleController.text;
                final description = descriptionController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  final response = await http.post(
                    Uri.parse('http://localhost:8080/category/create'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      'title': title,
                      'description': description,
                    }),
                  );

                  if (response.statusCode == 200) {
                    _fetchCategories();
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add category')));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 102, 222, 246),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(userId: widget.userId),
              ),
            );
          },
          child: Icon(Icons.person, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.qr_code, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScanPage()),
                );
              },
            ),
          ),
        ],
        title: Center(
          child: Text(
            "TOPICS",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
        ),
      ),
      body: Container(
        color: Colors.blue.shade50,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search topics',
                  prefixIcon: Icon(Icons.menu),
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTopics.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (categoryIds[index] != -1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TopicPage(categoryId: categoryIds[index] , userId: widget.userId), // Pass category ID to next page
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid category ID")));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(116, 156, 164, 158).withOpacity(0.5),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: 100,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color.fromARGB(116, 156, 164, 158),
                              child: Icon(Icons.topic, color: Colors.white),
                            ),
                            title: Text(
                              filteredTopics[index],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text(
                              "Explore ${filteredTopics[index]} resources and updates.",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _showCategoryDialog(context),
              child: Text('Add Category'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(96, 125, 139, 1),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
