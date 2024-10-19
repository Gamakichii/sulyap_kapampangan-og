import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? selectedAvatar;
  File? _imageFile; // To store the selected image file
  late String username; // Initialize username
  late Map<String, dynamic> userData; // Initialize userData

  // ImagePicker instance
  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (routeArgs == null) {
      // Handle the case where no user data is provided
      username = 'Guest'; // Default value if no username is provided
      userData = {}; // Default empty map if no userData is provided
    } else {
      username = routeArgs['username'] as String; // Extract username
      userData = routeArgs['userData'] as Map<String, dynamic>; // Extract userData
      selectedAvatar = userData['avatar']; // Set the selected avatar from userData
    }
  }

  // Method to allow user to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Store the picked image file
        selectedAvatar = null; // Reset avatar when a custom image is selected
      });
      // Here you would upload the image to your backend and update userData with the new avatar URL
      // For example:
      // _uploadImageAndSaveUrl(_imageFile!);
    }
  }

  // List of available avatar image paths
  final List<String> avatarPaths = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
    'assets/avatars/avatar5.png',
    'assets/avatars/avatar6.png',
    'assets/avatars/avatar7.png',
    'assets/avatars/avatar8.png',
    'assets/avatars/avatar9.png',
  ];

  // Function to show avatar selection dialog
  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFFB7A6E0),
          title: Text(
            'Select Avatar',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            height: 370, // Adjust the height as needed
            width: double.maxFinite,
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of avatars per row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: avatarPaths.length,
                    itemBuilder: (context, index) {
                      final avatarPath = avatarPaths[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAvatar = avatarPath;
                            userData['avatar'] = selectedAvatar; // Set selected avatar
                            _imageFile = null; // Reset custom image when an avatar is selected
                          });
                          _saveAvatarToDatabase(selectedAvatar!); // Save to database
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Image.asset(avatarPath),
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImageFromGallery(); // Pick image from gallery
                  },
                  child: Text(
                    'Upload from Gallery',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to save selected avatar to the database
  Future<void> _saveAvatarToDatabase(String avatarPath) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    try {
      // Update the user's avatar in Firestore using the username
      await usersCollection
          .where('username', isEqualTo: username)
          .limit(1) // Limit to one user
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // Update the specific document with the new avatar
          snapshot.docs.first.reference.update({'avatar': avatarPath});
        }
      });
    } catch (e) {
      print('Error updating avatar: $e');
      _showErrorDialog(context, 'Error', 'Failed to update avatar.');
    }
  }

  // Method to delete account
  Future<void> _deleteAccount(BuildContext context) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    // Show confirmation dialog before deleting the account
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: TextStyle(color: Colors.black),
        ),
        content: Text(
          'Are you sure you want to delete your account?',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel
            child: Text('No', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm
            child: Text('Yes', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Find the user by username and delete the document
        final querySnapshot = await usersCollection
            .where('username', isEqualTo: username) // Use extracted username
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          await querySnapshot.docs.first.reference.delete();

          // Navigate back to the login page after deletion
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
                (route) => false, // Remove all routes from the stack
          );
        }
      } catch (e) {
        print('Error deleting account: $e');
        _showErrorDialog(context, 'Error', 'Failed to delete the account.');
      }
    }
  }

  // Function to show error dialog
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(color: Colors.black)),
        content: Text(message, style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  // Logout method
  void _logout(BuildContext context) {
    // Clear any user session or authentication state here
    // Navigate to login screen
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false, // Remove all routes from the stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed background color to white
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $username', // Use extracted username
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _showAvatarSelectionDialog, // Open avatar selection or image picker
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!) // Display the selected image
                        : selectedAvatar != null
                        ? AssetImage(selectedAvatar!) // Display selected avatar
                        : null,
                    child: _imageFile == null && selectedAvatar == null
                        ? Icon(Icons.person, size: 50, color: Colors.white) // Default icon
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: BorderSide(
                            color: Colors.black.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/updatePassword',
                            arguments: username, // Pass username to update password
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Update Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: BorderSide(
                            color: Colors.red.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        onPressed: () => _deleteAccount(context), // Call delete account logic
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Delete Account',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: BorderSide(
                            color: Colors.black.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        onPressed: () {
                          _logout(context); // Logout logic
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
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