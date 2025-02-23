import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/pages/friend_page.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FriendTile extends StatelessWidget {
  User friend;

  FriendTile({
    super.key,
    required this.friend,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FriendPage(user: friend),
            ),
          );
      },
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(friend.firstName + ' ' + friend.lastName),
        subtitle: Text(friend.email),
      ),
    );
  }
}