import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? selectedAvatar;
  File? _imageFile; // To store the selected image file

  // ImagePicker instance
  final ImagePicker _picker = ImagePicker();

  // Method to allow user to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Store the picked image file
        selectedAvatar = null; // Reset avatar when a custom image is selected
      });
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
          title: Text('Select Avatar',style: TextStyle(color: Colors.white),),
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
                            selectedAvatar = avatarPath; // Set selected avatar
                            _imageFile = null; // Reset custom image when an avatar is selected
                          });
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
                  child: Text('Upload from Gallery', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background3.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${widget.username}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
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
                                color: Colors.white.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/updatePassword',
                                arguments: widget.username,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Update Password',
                                style: TextStyle(
                                  color: Colors.white,
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
                            onPressed: () => _deleteAccount(context), // Replace with your delete account logic
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
                                color: Colors.white.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            onPressed: () {
                              _logout(context); // Replace with your logout logic
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white,
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
        ],
      ),
    );
  }

  // Dummy method for account deletion
  void _deleteAccount(BuildContext context) {
    print('Delete account triggered');
  }

  // Dummy method for logout
  void _logout(BuildContext context) {
    print('Logout triggered');
  }
}
