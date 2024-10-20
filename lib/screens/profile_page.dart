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

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  String? selectedAvatar;
  File? _imageFile; // To store the selected image file
  late String username; // Initialize username
  late Map<String, dynamic> userData; // Initialize userData
  bool _isLoading = false; // Loading state

  // ImagePicker instance
  final ImagePicker _picker = ImagePicker();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward(); // Start the animation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (routeArgs == null) {
      username = 'Guest'; // Default value if no username is provided
      userData = {}; // Default empty map if no userData is provided
    } else {
      username = routeArgs['username'] as String; // Extract username
      userData =
          routeArgs['userData'] as Map<String, dynamic>; // Extract userData
      selectedAvatar =
          userData['avatar']; // Set the selected avatar from userData
    }
  }

  // Method to allow user to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Store the picked image file
        selectedAvatar = null; // Reset avatar when a custom image is selected
      });
    }
    setState(() {
      _isLoading = false; // Hide loading indicator
    });
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
          backgroundColor: const Color(0xFFB7A6E0),
          title: const Text(
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                            userData['avatar'] =
                                selectedAvatar; // Set selected avatar
                            _imageFile =
                                null; // Reset custom image when an avatar is selected
                          });
                          _saveAvatarToDatabase(
                              selectedAvatar!); // Save to database
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: selectedAvatar == avatarPath
                                ? Border.all(color: Colors.blue, width: 3)
                                : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(avatarPath),
                        ),
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImageFromGallery(); // Pick image from gallery
                  },
                  child: const Text(
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

  // Method to edit bio
  void _editBio() {
    final TextEditingController bioController =
        TextEditingController(text: userData['bio']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(
              0xFFB7A6E0), // Match the avatar selection dialog color
          title: const Text('Edit Bio', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: bioController,
            decoration: const InputDecoration(
                hintText: 'Enter your bio',
                hintStyle: TextStyle(color: Colors.white70)),
            maxLines: 3,
            style: const TextStyle(color: Colors.white), // Text color
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                String newBio = bioController.text;
                setState(() {
                  userData['bio'] = newBio; // Update local userData
                });
                await _saveBioToDatabase(newBio); // Save to database
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Method to save bio to the database
  Future<void> _saveBioToDatabase(String bio) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    try {
      // Update the user's bio in Firestore using the username
      await usersCollection
          .where('username', isEqualTo: username)
          .limit(1) // Limit to one user
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // Update the specific document with the new bio
          snapshot.docs.first.reference.update({'bio': bio});
        }
      });
    } catch (e) {
      print('Error updating bio: $e');
      _showErrorDialog(context, 'Error', 'Failed to update bio.');
    }
  }

  // Method to delete account
  Future<void> _deleteAccount(BuildContext context) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    // Show confirmation dialog before deleting the account
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Account',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'Are you sure you want to delete your account?',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel
            child: const Text('No', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm
            child: const Text('Yes', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });
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
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  // Function to show error dialog
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(color: Colors.black)),
        content: Text(message, style: const TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.black)),
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
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40), // Add space at the top
              FadeTransition(
                opacity: _animation,
                child: Text(
                  'Welcome, $username', // Use extracted username
                  style: const TextStyle(
                    fontSize: 36, // Increased font size for prominence
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center, // Center the text
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap:
                    _showAvatarSelectionDialog, // Open avatar selection or image picker
                child: CircleAvatar(
                  radius: 120, // Increased size for prominence
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!) // Display the selected image
                      : selectedAvatar != null
                          ? AssetImage(
                              selectedAvatar!) // Display selected avatar
                          : null,
                  child: _imageFile == null && selectedAvatar == null
                      ? const Icon(Icons.person,
                          size: 80, color: Colors.white70) // Default icon
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              // Display the user's bio content only
              Text(
                userData['bio'] ??
                    'No bio available', // Access bio from userData
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editBio, // Call edit bio function
                child: const Text('Edit Bio'),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildProfileButton(
                        label: 'Update Password',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/updatePassword',
                            arguments:
                                username, // Pass username to update password
                          );
                        },
                        icon: Icons.lock, // Icon for Update Password
                      ),
                      const SizedBox(height: 20),
                      _buildProfileButton(
                        label: 'Delete Account',
                        onPressed: () => _deleteAccount(
                            context), // Call delete account logic
                        color: Colors.red,
                        icon: Icons.delete, // Icon for Delete Account
                      ),
                      const SizedBox(height: 20),
                      _buildProfileButton(
                        label: 'Logout',
                        onPressed: () {
                          _logout(context); // Logout logic
                        },
                        icon: Icons.logout, // Icon for Logout
                        isSmall:
                            true, // Indicate that this button should be smaller
                      ),
                    ],
                  ),
                ),
              ),
              if (_isLoading) // Show loading indicator if loading
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build profile buttons with icons
  Widget _buildProfileButton({
    required String label,
    required VoidCallback onPressed,
    Color? color,
    required IconData icon,
    bool isSmall =
        false, // New parameter to indicate if the button should be smaller
  }) {
    return SizedBox(
      width: double.infinity, // Make button full width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFFB7A6E0), // Default color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(
            vertical:
                isSmall ? 12 : 16, // Smaller padding for the logout button
            horizontal: 30,
          ),
          elevation: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white), // Icon for the button
            const SizedBox(width: 10), // Space between icon and text
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
