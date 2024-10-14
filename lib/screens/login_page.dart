import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        final userData = querySnapshot.docs.first.data() as Map<String,
            dynamic>;
        if (userData['password'] == _passwordController.text) {
          // Login successful, navigate to the next screen
          print('Login successful');
          Navigator.pushNamed(context, '/home');
        } else {
          // Incorrect password
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Login Failed',
                style: TextStyle(color: Colors.black), // Apply black color to title
              ),
              content: Text(
                'Incorrect Password.',
                style: TextStyle(color: Colors.black), // Apply black color to content
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.black), // Apply black color to button text
                  ),
                ),
              ],
            ),
          );
        }
      } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Login Failed',
                style: TextStyle(color: Colors.black), // Apply black color to title
              ),
              content: Text(
                'Invalid Credentials.',
                style: TextStyle(color: Colors.black), // Apply black color to content
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.black), // Apply black color to button text
                  ),
                ),
              ],
            ),
          );
        }
    } catch (e) {
      print('Error during login: $e');
      // Handle login errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                style: TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _login();
                  }
                },
                child: Text('Login'),
              ),

              SizedBox(height: 20), // Add some spacing

              // Signup Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}