import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final querySnapshot = await usersCollection
          .where('email', isEqualTo: _emailController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (userData['password'] == _passwordController.text) {
          // Login successful, navigate to the next screen
          print('Login successful');
          Navigator.pushNamed(context, '/home');
        } else {
          // Incorrect password
          _showErrorDialog('Login Failed', 'Incorrect Password.');
        }
      } else {
        _showErrorDialog('Login Failed', 'Invalid Credentials.');
      }
    } catch (e) {
      print('Error during login: $e');
      // Handle login errors
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
      backgroundColor: Colors.transparent, // Make background transparent
      extendBodyBehindAppBar: true, // Extend body to behind the appbar
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0, // Remove shadow
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back arrow color to white
        ), // Make status bar icons light
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background3.png'), // Your background image
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Align buttons evenly
                      children: [
                        // Login button
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      _login(); // Your login logic here
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20), // Add spacing between the two buttons
                        // Sign Up button
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignupPage(),
                                      ),
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
