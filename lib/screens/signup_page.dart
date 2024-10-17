import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Check if username already exists
        final usersCollection = FirebaseFirestore.instance.collection('users');
        final querySnapshot = await usersCollection
            .where('username', isEqualTo: _usernameController.text.trim())
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Username already exists
          _showErrorDialog('Sign Up Failed', 'Username already exists.');
        } else {
          // Create new user document
          await usersCollection.add({
            'username': _usernameController.text.trim(),
            'password': _passwordController.text.trim(),
          });

          // Sign up successful - navigate to the login page
          print('Sign up successful');
          Navigator.pop(context); // Go back to the login page
        }
      } catch (e) {
        print('Error during signup: $e');
        _showErrorDialog('Sign Up Failed', 'An unexpected error occurred.');
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      extendBodyBehindAppBar: false, // Prevent body from extending behind app bar
      appBar: AppBar(
        title: Text('Sign Up', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center( // Center the form horizontally
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25), // Rounded corners
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Background blur
            child: Container(
              width: 350, // Adjust the width of the form
              padding: EdgeInsets.all(20), // Add padding inside the form
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5), // Slightly transparent background
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: RichText( // Use RichText to style parts of the text
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Register ', // Bold "Register"
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'your account', // Normal "your account"
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Space between title and fields

                    // Username TextField
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person, color: Color(0xFFB7A6E0)),
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Password TextField
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Color(0xFFB7A6E0)),
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Confirm Password TextField
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock, color: Color(0xFFB7A6E0)),
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),

                    // Sign Up button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signup,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Color(0xFFB7A6E0), // Button background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}