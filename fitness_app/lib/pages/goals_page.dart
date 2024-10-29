import 'package:fitness_app/components/goal_tile.dart';
import 'package:fitness_app/components/my_drawer.dart';
import 'package:fitness_app/components/my_heat_map.dart';
import 'package:fitness_app/database/goal_database.dart';
import 'package:fitness_app/models/goal.dart';
import 'package:fitness_app/util/goal_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {

  @override
  void initState() {

    // read existing goals on app startup
    Provider.of<GoalDatabase>(context, listen: false).readGoals();

    super.initState();
  }

  // text controller
  final TextEditingController textController = TextEditingController();

  // create new goal
  void createNewGoal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Create a new goal',
          ),
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              // get the new goal name
              String newGoalName = textController.text;

              // save to db
              context.read<GoalDatabase>().addGoal(newGoalName);

              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // check goal on & off
  void checkGoalOnOff(bool? value, Goal goal) {
  // update goal completion status
  if (value != null) {
    context.read<GoalDatabase>().updateGoalCompletion(goal.id, value);
    }
  }

  // edit goal box
  void editGoalBox(Goal goal) {
    // set the controller's text to the goal's current name
    textController.text = goal.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              // get the new goal name
              String newGoalName = textController.text;

              // save to db
              context.read<GoalDatabase>().updateGoalName(goal.id, newGoalName);

              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controller
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      )
    );
  }

  // delete goal box
  void deleteGoalBox(Goal goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to delete?'),
        actions: [
          // delete button
          MaterialButton(
            onPressed: () {
              // delete from db
              context.read<GoalDatabase>().deleteGoal(goal.id);

              // pop box
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
                  'Set your own goals',
                  style: GoogleFonts.dmSerifText(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewGoal,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          // heat map
          _buildHeatMap(),

          // goal list
          _buildGoalList(),
        ],
      )
    );
  }

  // build heat map
  Widget _buildHeatMap() {
    // goal database
    final goalDatabase = context.watch<GoalDatabase>();

    // current goals
    List<Goal> currentGoals = goalDatabase.currentGoals;

    // return heat map UI
    return FutureBuilder(
      future: goalDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        // once the data is available -> build heatmap
        if(snapshot.hasData) {
          return MyHeatMap(
            datasets: prepHeatMapDataset(currentGoals),
            startDate: snapshot.data!,
          );
        }

        // handle case where no data is returned
        else {
          return Container();
        }
      }
      );
  }

  // build goal list
  Widget _buildGoalList() {
    // goal db
    final goalDatabase = context.watch<GoalDatabase>();

    // current goals
    List<Goal> currentGoals = goalDatabase.currentGoals;

    // return list of goals UI
    return ListView.builder(
      itemCount: currentGoals.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // get each individual goal
        final goal = currentGoals[index];

        // check if the goal is completed today
        bool isCompletedToday = isGoalCompletedToday(goal.completedDays);

        // return goal tile UI
        return GoalTile(
          text: goal.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkGoalOnOff(value, goal),
          editGoal: (context) => editGoalBox(goal),
          deleteGoal: (context) => deleteGoalBox(goal),
        );
      } 
    );
  }
}