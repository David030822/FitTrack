import 'package:fitness_app/responsive/constants.dart';
import 'package:fitness_app/util/my_box.dart';
import 'package:fitness_app/util/my_tile.dart';
import 'package:flutter/material.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      backgroundColor: myDefaultBackgroundColor,
      body: Row(
        children: [
          // open drawer
          myDrawer,

          // rest of body
          Expanded(
            flex: 2,
            child: Column(
              children: [
                  // 4 boxes on the top
                  AspectRatio(
                    aspectRatio: 4,
                    child: SizedBox(
                      width: double.infinity,
                      child: GridView.builder(
                        itemCount: 4,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                        itemBuilder: (context, index) {
                          return const MyBox();
                        }
                      ),
                    ),
                  ),
              
                // tiles below
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return const MyTile();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(child: Container(color: Colors.pink[300])),
              ],
            ),
          ),
        ],
      )
    );
  }
}