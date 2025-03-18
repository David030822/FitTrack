import 'package:fitness_app/models/user.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
  
      body: ListView(
         children:[
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center (
                child: Text(
                'Friend page',
                  style: GoogleFonts.dmSerifText(
                  fontSize: 48,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
          
          CircleAvatar(
            radius: 80,
            backgroundImage: _getImageProvider(widget.user.profileImagePath!),
            child: _getImageProvider(widget.user.profileImagePath!) == null
                ? Icon(
                    Icons.person,
                    size: 80,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  )
                : null,
          ),

          const SizedBox(height: 10),
          itemProfile('Name', '${widget.user.firstName} ${widget.user.lastName}' , CupertinoIcons.person),
          const SizedBox(height: 10),
          itemProfile('Phone', widget.user.phoneNum!, CupertinoIcons.phone),
          const SizedBox(height: 10),
          itemProfile('Email', widget.user.email, CupertinoIcons.mail),
          const SizedBox(height: 10),
          ],
        ),
      );
    }

    ImageProvider<Object>? _getImageProvider(String path) {
      try {
        return path.isNotEmpty ? AssetImage(path) : null;
      } catch (e) {
        return null;
      }
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