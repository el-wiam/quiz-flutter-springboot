import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  dynamic
      _profileImage; // Can handle both File (mobile) and network paths (web)
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _profileImage = kIsWeb ? pickedFile.path : File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final url = Uri.parse('http://localhost:8080/user/create');

    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['username'] = _usernameController.text;
      request.fields['password'] = _passwordController.text;
      request.fields['firstname'] = _firstnameController.text;
      request.fields['lastname'] = _lastnameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['phone'] = _phoneController.text;

      // Only add profile image if it's not null
      if (_profileImage != null && !kIsWeb) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile',
          (_profileImage as File).path,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registered successfully!')),
        );
        Navigator.pop(context);
      } else {
        var responseData = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $responseData')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during registration: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightBlue[50],
                    ),
                    child: Image.asset(
                      'assets/quiz1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Input Fields
                  _buildTextField("First Name", _firstnameController, false),
                  const SizedBox(height: 10),
                  _buildTextField("Last Name", _lastnameController, false),
                  const SizedBox(height: 10),
                  _buildTextField("Email Address", _emailController, false),
                  const SizedBox(height: 10),
                  _buildTextField("Phone", _phoneController, false),
                  const SizedBox(height: 10),
                  _buildTextField("Username", _usernameController, false),
                  const SizedBox(height: 10),
                  _buildTextField("Password", _passwordController, true),
                  const SizedBox(height: 10),
                  _buildTextField(
                      "Confirm Password", _confirmPasswordController, true),
                  const SizedBox(height: 10),

                  // Profile Image Picker
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.image),
                          label: const Text("Upload Profile Image"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (_profileImage != null)
                        kIsWeb
                            ? Image.network(
                                _profileImage,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                _profileImage as File,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                      else
                        Image.asset(
                          'assets/Profil.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      backgroundColor: Colors.blueGrey,
                    ),
                    child: const Text("Sign up"),
                  ),
                  const SizedBox(height: 20),

                  // Navigate to Login
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "I have an account",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String labelText, TextEditingController controller, bool obscureText) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(obscureText ? Icons.lock : Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        if (labelText == "Confirm Password" &&
            value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
