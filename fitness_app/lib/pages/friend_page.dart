import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:fitness_app/util/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendPage extends StatefulWidget {
  final User user;
  const FriendPage({super.key, required this.user});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  bool _isFollowing = false;
  bool _isLoading = true;
  late int _followersCount;
  late int _followingCount;

  @override
  void initState() {
    super.initState();
    _followersCount = 0;
    _followingCount = 0;
    _checkFollowingStatus();
  }

  Future<void> _loadProfileStats(int profileUserId) async {
    try {
      _followingCount = await ApiService.getFollowing(profileUserId).then((list) => list.length);
      _followersCount = await ApiService.getFollowers(profileUserId).then((list) => list.length);
      setState(() {});
    } catch (e) {
      print("Error fetching profile stats: $e");
    }
  }

  void _checkFollowingStatus() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception("User is not logged in");
      }
      final userId = await AuthService.getUserIdFromToken(token);
      if (userId == null) {
        throw Exception("Invalid user ID"); 
      }

      _loadProfileStats(widget.user.id);

      bool isFollowing = await ApiService.isFollowing(userId, widget.user.id);
      setState(() {
        _isFollowing = isFollowing;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking following status: $e')),
      );
    }
  }

  void _followUser() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception("User is not logged in");
      }
      final userId = await AuthService.getUserIdFromToken(token);
      if (userId == null) {
        throw Exception("Invalid user ID");
      }

      await ApiService.addFollowing(userId, widget.user.id);
      setState(() {
        _isFollowing = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User followed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _unfollowUser() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception("User is not logged in");
      }
      final userId = await AuthService.getUserIdFromToken(token);
      if (userId == null) {
        throw Exception("Invalid user ID");
      }

      await ApiService.deleteFollowing(userId, widget.user.id);
      setState(() {
        _isFollowing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User unfollowed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
  
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
         child:
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center (
                    child: Text(
                    'User profile page',
                      style: GoogleFonts.dmSerifText(
                      fontSize: 36,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CircleAvatar(
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
              const SizedBox(height: 10),
              if (!_isLoading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: CustomButton(
                        color: Theme.of(context).colorScheme.tertiary,
                        textColor: Theme.of(context).colorScheme.outline,
                        onPressed: _isFollowing ? _unfollowUser : _followUser,
                        label: _isFollowing ? 'Unfollow' : '+ Follow',
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Following: $_followingCount"),
                    const SizedBox(width: 10),
                    Text("Followers: $_followersCount"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              itemProfile('Name', '${widget.user.firstName} ${widget.user.lastName}', CupertinoIcons.person),
              itemProfile('Phone', widget.user.phoneNum ?? 'Not set', CupertinoIcons.phone),
              itemProfile('Email', widget.user.email, CupertinoIcons.mail),
              itemProfile('Username', widget.user.username, CupertinoIcons.flame),
            ],
          ),
        ),
      );
    }

    Widget itemProfile(String title, String subtitle, IconData iconData){
       return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0,5),
                  color: Colors.grey.withOpacity(.2),
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            leading: Icon(iconData),
            trailing: const Icon(Icons.arrow_forward,color: Colors.grey),     
          ),
        ),
      );
    }
}