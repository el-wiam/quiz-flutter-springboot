import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'CR_Q2.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CreateQuizPage(),
  ));
}

class CreateQuizPage extends StatefulWidget {
  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController maxMarksController = TextEditingController();
  final TextEditingController questionCountController = TextEditingController();
  final TextEditingController newCategoryController = TextEditingController();
  final TextEditingController categoryDescriptionController =
      TextEditingController();

  List<Category> categories = [];
  Category? selectedCategory;
  bool isActive = true;
  html.File? file;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final url = Uri.parse('http://localhost:8080/category/all');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          categories = data.map((json) => Category.fromJson(json)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load categories')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error connecting to the server')),
      );
    }
  }

  Future<void> _createQuiz() async {
    if (selectedCategory == null ||
        titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        maxMarksController.text.isEmpty ||
        questionCountController.text.isEmpty ||
        int.tryParse(maxMarksController.text) == null ||
        int.tryParse(questionCountController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly.')),
      );
      return;
    }

    final url = Uri.parse('http://localhost:8080/quiz/create');
    var formData = html.FormData();

    formData.append('title', titleController.text);
    formData.append('description', descriptionController.text);
    formData.append('maxmarks', maxMarksController.text);
    formData.append('numofquestions', questionCountController.text);
    formData.append('active', isActive.toString());
    formData.append('catid', selectedCategory!.id.toString());

    if (file != null) {
      formData.appendBlob('imagefile', file!);
    }

    try {
      var request = html.HttpRequest();
      request.open('POST', url.toString());
      request.send(formData);

      request.onLoadEnd.listen((event) {
        if (request.status == 200) {
          final responseData = json.decode(request.responseText ?? '{}');
          final quizId = responseData['quizid'];
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Quiz created successfully!")),
          );

          // Navigate to the next page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetQuestionsPage(
                questionCount: int.parse(questionCountController.text),
                quizId: quizId, quizTitle: titleController.text,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create quiz: ${request.responseText}')),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error connecting to the server.')),
      );
    }
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Category"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newCategoryController,
              decoration:
                  const InputDecoration(hintText: "Enter category name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: categoryDescriptionController,
              decoration: const InputDecoration(
                hintText: "Enter category description",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Add category logic
            },
            child: const Text("Add"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _pickFile() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isEmpty) return;
      setState(() {
        file = files[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        elevation: 0,
        title: const Text(
          "Create Your Quiz",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Quiz Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: titleController,
                      hintText: "Title",
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: descriptionController,
                      hintText: "Description",
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: maxMarksController,
                      hintText: "Maximum Marks",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: questionCountController,
                      hintText: "Number of Questions",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Category>(
                      value: selectedCategory,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Select a Category",
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Active"),
                        Switch(
                          value: isActive,
                          onChanged: (value) {
                            setState(() {
                              isActive = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Upload Image"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _createQuiz,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text(
                    "Submit Quiz",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Category {
  final int? id;
  final String name;
  final String description;

  Category({this.id, required this.name, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['catid'],
      name: json['title'],
      description: json['description'] ?? '',
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  CustomTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
        border: OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      keyboardType: keyboardType,
    );
  }
}
