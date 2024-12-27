import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'CR_Q3.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CreateQuizPage(),
  ));
}

class Category {
  final int id;
  final String title;
  final String description;

  Category({required this.id, required this.title, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
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
  List<Category> categories = [];
  Category? selectedCategory;
  bool isActive = true;
  html.File? file;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse('http://localhost:8080/categories');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> categoryData = jsonDecode(response.body);
      setState(() {
        categories = categoryData.map((e) => Category.fromJson(e)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch categories.')),
      );
    }
  }

  Future<void> _createQuiz() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        maxMarksController.text.isEmpty ||
        questionCountController.text.isEmpty ||
        int.tryParse(maxMarksController.text) == null ||
        int.tryParse(questionCountController.text) == null ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly.')),
      );
      return;
    }

    final quizData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'maxmarks': int.parse(maxMarksController.text),
      'numofquestions': int.parse(questionCountController.text),
      'active': isActive,
      'category': {
        'id': selectedCategory!.id,
        'title': selectedCategory!.title,
        'description': selectedCategory!.description,
      },
    };

    try {
      final url = Uri.parse('http://localhost:8080/quiz/create');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(quizData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final quizId = responseData['quizid'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetQuestionsPage(
              questionCount: int.parse(questionCountController.text),
              quizId: quizId,
              quizTitle: titleController.text,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create quiz.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error connecting to the server.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: const Text("Create a Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: maxMarksController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Max Marks"),
              ),
              TextField(
                controller: questionCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Number of Questions"),
              ),
              DropdownButton<Category>(
                value: selectedCategory,
                isExpanded: true,
                hint: const Text("Select a Category"),
                items: categories.map((category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.title),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedCategory = value),
              ),
              SwitchListTile(
                title: const Text("Active"),
                value: isActive,
                onChanged: (val) => setState(() => isActive = val),
              ),
              ElevatedButton(
                onPressed: _createQuiz,
                child: const Text("Create Quiz"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetQuestionsPage extends StatefulWidget {
  final int questionCount;
  final int quizId;
  final String quizTitle;

  SetQuestionsPage({
    required this.questionCount,
    required this.quizId,
    required this.quizTitle,
  });

  @override
  _SetQuestionsPageState createState() => _SetQuestionsPageState();
}

class _SetQuestionsPageState extends State<SetQuestionsPage> {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> answerControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  String? correctAnswer;
  int currentQuestionIndex = 1;

  void addAnswerField() {
    setState(() {
      if (answerControllers.length < 4) {
        answerControllers.add(TextEditingController());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Maximum of 4 options allowed.")),
        );
      }
    });
  }

  Future<void> saveQuestion() async {
    if (questionController.text.isEmpty ||
        answerControllers.any((c) => c.text.isEmpty) ||
        correctAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    final questionData = {
      "content": questionController.text,
      "option1": answerControllers[0].text,
      "option2": answerControllers[1].text,
      "option3": answerControllers.length > 2 ? answerControllers[2].text : null,
      "option4": answerControllers.length > 3 ? answerControllers[3].text : null,
      "answer": correctAnswer,
      "quiz": {"quizid": widget.quizId},
    };

    try {
      final url = Uri.parse('http://localhost:8080/question/create');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(questionData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Question saved successfully!")),
        );
        questionController.clear();
        answerControllers.forEach((controller) => controller.clear());
        setState(() {
          correctAnswer = null;
          if (currentQuestionIndex < widget.questionCount) {
            currentQuestionIndex++;
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>QuizTopicPage (
                  quizId: widget.quizId,
                  quizTitle: widget.quizTitle,
                ),
              ),
            );
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save the question.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error connecting to the server.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: Text("Question ${currentQuestionIndex} of ${widget.questionCount}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
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
                    Text(
                      "Question N° ${currentQuestionIndex}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: questionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter your question",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Answers:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...answerControllers.map((controller) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter an answer",
                          ),
                        ),
                      );
                    }),
                    TextButton.icon(
                      onPressed: addAnswerField,
                      icon: Icon(Icons.add, color: Colors.blue),
                      label: Text("Add an Answer"),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: correctAnswer,
                      isExpanded: true,
                      hint: const Text("Select the correct answer"),
                      items: answerControllers.map((controller) {
                        return DropdownMenuItem<String>(
                          value: controller.text,
                          child: Text(controller.text),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => correctAnswer = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveQuestion,
                child: const Text("Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CrQ3Page extends StatelessWidget {
//   final int quizId;
//   final String quizTitle;

//   CrQ3Page({required this.quizId, required this.quizTitle});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.lightBlue[200],
//         title: Text("Launch $quizTitle"),
//       ),
//       body: Center(
//         child: Text(
//           "Ready to launch Quiz ID: $quizId!",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
