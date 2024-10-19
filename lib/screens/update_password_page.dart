import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class UpdatePasswordPage extends StatefulWidget {
  final String username;

  const UpdatePasswordPage({Key? key, required this.username}) : super(key: key);

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  Future<void> _updatePassword() async {
    Map<String, dynamic>? userData;

    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final querySnapshot = await usersCollection
          .where('username', isEqualTo: widget.username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        userData = userDoc.data(); // Assign userData from the document

        if (userData['password'] == _currentPasswordController.text) {
          // If current password matches, update to the new password.
          await userDoc.reference.update({
            'password': _newPasswordController.text,
          });

          _showDialog('Success', 'Password updated successfully!', userData['username'], userData);
        } else {
          _showDialog('Error', 'Current password is incorrect.', userData['username'], userData);
        }
      } else {
        _showDialog('Error', 'User not found.', null, null); // Handle case when user is not found
      }
    } catch (e) {
      print('Error updating password: $e');
      // Check if userData is not null before using it
      _showDialog('Error', 'Failed to update the password.', userData?['username'], userData);
    }
  }


  void _showDialog(String title, String message, username, userData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(color: Colors.black)),
        content: Text(message, style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/profile', arguments: {'username': username, 'userData': userData}),
            child: Text('OK', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: Text('Update Password', style: TextStyle(color: Colors.black)), // Change text color to black
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.black), // Change icon color to black
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 1.0),
                child: Image.asset('assets/logo_purple.png', height: 200),
              ),
              ClipRRect(
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
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Update ',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'your password',
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

                          // Current Password TextField
                          TextFormField(
                            controller: _currentPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Current Password',
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
                                return 'Please enter your current password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16), // Space between fields

                          // New Password TextField
                          TextFormField(
                            controller: _newPasswordController,
                            decoration: InputDecoration(
                              labelText: 'New Password',
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
                                return 'Please enter your new password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24), // Space between field and button

                          // Update Password button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _updatePassword(); // Call update password function
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Color(0xFFB7A6E0), // Button background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Update Password',
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
            ],
          ),
        ),
      ),
    );
  }
}