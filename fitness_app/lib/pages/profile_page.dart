import 'package:fitness_app/components/my_drawer.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/pages/friends_page.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart'; // For local storage
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image; 
  User? _user;
  bool? _isLoading;
  String? _profileImageUrl;
  final int userId = 29; // Replace with actual logged-in user ID
  final String baseUrl = "http://192.168.0.142:5082/api/users"; // Adjust as needed
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _phoneController = TextEditingController(text: widget.user.phoneNum ?? '');
    _fetchProfileImage(); // Load image from backend
  }

  Future<void> _loadUserData() async {
  try {
    setState(() {
      _isLoading = true;
    });

    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      throw Exception("Invalid user ID");
    }

    final user = await ApiService.getUserData(userId, token);
    if (user != null) {
      setState(() {
        _user = user;
        _firstNameController.text = user.firstName;
        _lastNameController.text = user.lastName;
        _phoneController.text = user.phoneNum ?? "";
        _emailController.text = user.email;
      });
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  Future<void> _fetchProfileImage() async {
    final url = Uri.parse('$baseUrl/$userId/profile-image');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _profileImageUrl = jsonResponse['imageUrl'];
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Upload the selected image
      String? uploadedImageUrl = await _uploadProfileImage(imageFile);
      if (uploadedImageUrl != null) {
        setState(() {
          _profileImageUrl = uploadedImageUrl; // Update UI with new image URL
        });
      }
    }
  }

  Future<String?> _uploadProfileImage(File imageFile) async {
    var url = Uri.parse('$baseUrl/upload-profile-image?userId=$userId');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);
      return jsonResponse['imageUrl']; // Backend should return the uploaded image URL
    }
    return null;
  }

  Future<void> _saveProfileChanges() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception("User is not logged in");
      }

      final userId = await AuthService.getUserIdFromToken(token);
      if (userId == null) {
        throw Exception("Invalid user ID");
      }

      String? profileImagePath = _user?.profileImagePath;

      if (_image != null) {
        profileImagePath = await _uploadProfileImage(_image!) ?? _user?.profileImagePath;
      }

      final updatedUser = {
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "phoneNum": _phoneController.text.isNotEmpty ? _phoneController.text : null,
        "email": _emailController.text,
        "profileImagePath": profileImagePath,
      };

      var url = Uri.parse('http://192.168.0.142:5082/api/users/$userId');
      var response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Sending Bearer token
        },
        body: jsonEncode(updatedUser),
      );

      if (response.statusCode == 204) {
        _showSuccessMessage("Profile updated successfully!");
        _loadUserData(); // Reload data after successful update
      } else {
        throw Exception("Error updating profile: ${response.body}");
      }
    } catch (e) {
      _showErrorMessage("Network error: $e");
    }
  }

  // Snackbar functions to show success/error messages
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: const MyDrawer(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Center(
            child: Text(
              'Profile Page',
              style: GoogleFonts.dmSerifText(
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 80,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? ClipOval(
                      child: Image.asset(
                        widget.user.profileImagePath ?? 'assets/default_profile.png',
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.person, size: 80),
            ),
          ),
          const SizedBox(height: 10),
          itemProfile(
            title: 'First Name',
            controller: _firstNameController,
            icon: CupertinoIcons.person,
            isEditable: true,
          ),
          const SizedBox(height: 10),
          itemProfile(
            title: 'Last Name',
            controller: _lastNameController,
            icon: CupertinoIcons.person,
            isEditable: true,
          ),
          const SizedBox(height: 10),
          itemProfile(
            title: 'Phone',
            controller: _phoneController,
            icon: CupertinoIcons.phone,
            isEditable: true,
          ),
          const SizedBox(height: 10),
          itemProfile(
            title: 'Email',
            subtitle: widget.user.email,
            icon: CupertinoIcons.mail,
            isEditable: false,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveProfileChanges,
            child: const Text("Save Changes"),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FriendsPage()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Go to Friends Page',
                  style: GoogleFonts.dmSerifText(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.inversePrimary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemProfile({required String title, String? subtitle, TextEditingController? controller, required IconData icon, bool isEditable = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.grey.withOpacity(.2),
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title),
        subtitle: isEditable
            ? TextField(
                controller: controller,
                decoration: const InputDecoration(border: InputBorder.none),
              )
            : Text(subtitle ?? "Not provided"),
        leading: Icon(icon),
        trailing: isEditable ? const Icon(Icons.edit, color: Colors.grey) : const Icon(Icons.arrow_forward, color: Colors.grey),
      ),
    );
  }
}
