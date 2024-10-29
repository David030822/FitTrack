import 'package:fitness_app/components/friend_tile.dart';
import 'package:fitness_app/components/my_drawer.dart';
import 'package:fitness_app/models/friend.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: Column(
          children: [
            Text(
              'Your friends will appear here',
              style: GoogleFonts.dmSerifText(
                fontSize: 24,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            Expanded(
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                // get friend from friend list/db
                Friend friend = getFriendList()[index];

                return FriendTile(friend: friend);
              },
            ),
          ),
          ],
        ),
      ),
    );
  }
}