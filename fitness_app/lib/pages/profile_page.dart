import 'package:fitness_app/components/my_button.dart';
import 'package:fitness_app/components/my_drawer.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/pages/friends_page.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
  bool _isLoading = false;
  final String baseUrl = "$BASE_URL/api/users";
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late int _followersCount;
  late int _followingCount;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: _user?.firstName ?? '');
    _lastNameController = TextEditingController(text: _user?.lastName ?? '');
    _usernameController = TextEditingController(text: _user?.username ?? '');
    _phoneController = TextEditingController(text: _user?.phoneNum ?? '');
    _followersCount = 0;
    _followingCount = 0;
    _loadUserData(); // Fetch fresh data
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

    final fetchedUser = await ApiService.getUserData(userId, token);
    if (fetchedUser != null) {
      setState(() {
        _user = fetchedUser; // Update user object
        _firstNameController.text = _user!.firstName;
        _lastNameController.text = _user!.lastName;
        _usernameController.text = _user!.username;
        _phoneController.text = _user!.phoneNum ?? 'Not set';
      });
    }

    _loadProfileStats(userId);

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

  Future<void> _loadProfileStats(int userId) async {
    try {
      _followingCount = await ApiService.getFollowing(userId).then((list) => list.length);
      _followersCount = await ApiService.getFollowers(userId).then((list) => list.length);
      setState(() {});
    } catch (e) {
      print("Error fetching profile stats: $e");
    }
  }

  Future<void> _fetchProfileImage() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1)); // Wait a bit for the server to update

    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      return;
    }

    // ✅ Fetch latest user data to get the updated profile image path
    await _loadUserData();
    
    // Only fetch if profileImagePath exists and is not empty.
    if (_user?.profileImagePath != null && _user!.profileImagePath!.isNotEmpty) {
      final imageUrl = "$BASE_URL${_user!.profileImagePath}";
      print("Fetching profile image from: $imageUrl");

      final url = Uri.parse(imageUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Process image response if needed.
      } else {
        print("Error fetching image: ${response.statusCode} - ${response.body}");
      }
    } else {
      print("No profile image to fetch.");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Upload the selected image
      await _uploadProfileImage(imageFile);
    }
  }

  Future<String?> _uploadProfileImage(File imageFile) async {
    setState(() {
      _isLoading = true; // ✅ Show loading indicator
    });

    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      return null;
    }

    var url = Uri.parse('$baseUrl/upload-profile-image?userId=$userId');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = "Bearer $token"; // Include auth header
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    print("Uploading profile image to: $url");

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print("Upload successful: ${response.body}");
      // ✅ Parse the new profile image path from API response
      final jsonResponse = jsonDecode(response.body);
      final newImagePath = jsonResponse["profilePhotoPath"];

      setState(() {
        _user!.profileImagePath = newImagePath; // ✅ Update image path instantly
        _isLoading = false; // ✅ Hide loading indicator
      });

      print("New profile image path: $newImagePath");

    } else {
      print("Error uploading image: ${response.statusCode} - ${response.body}");
    }
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
        String? uploadedImageUrl = await _uploadProfileImage(_image!);
        if (uploadedImageUrl != null) {
          profileImagePath = uploadedImageUrl;
        }
      }

      final updatedUser = {
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "username": _usernameController.text,
        "phoneNum": _phoneController.text.isNotEmpty ? _phoneController.text : "",
        "profileImagePath": profileImagePath,
      };

      var url = Uri.parse('$baseUrl/$userId');
      print("Sending PUT request to: $url with body: $updatedUser");

      var response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(updatedUser),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 204) {
        _showSuccessMessage("Profile updated successfully!");
        await _fetchProfileImage();  
        await _loadUserData();
      } else {
        throw Exception("Error updating profile: ${response.body}");
      }
    } catch (e) {
      print("Network error: $e");
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
              child: ClipOval(
                child: widget.user.profileImagePath != null && widget.user.profileImagePath!.isNotEmpty
                    ? Image.network(
                        "$BASE_URL${widget.user.profileImagePath}",
                        headers: const {"Accept": "image/jpeg"},
                        // File(widget.user.profileImagePath!),
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print("Error loading image: $error");
                          return const Icon(Icons.error);
                        },
                      )
                    : Image.asset(
                        'assets/images/default_profile.png', // Default profile picture
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Following: $_followingCount"),
              const SizedBox(width: 10),
              Text("Followers: $_followersCount"),
            ],
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
            title: 'Username',
            controller: _usernameController,
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
          MyButton(
            onTap: () {
              _saveProfileChanges();
            },
            text: 'Save changes',
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
