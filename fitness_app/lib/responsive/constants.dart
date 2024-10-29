import 'package:fitness_app/components/my_drawer.dart';
import 'package:fitness_app/models/friend.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:flutter/material.dart';

var myDefaultBackgroundColor = Colors.grey[300];

var myAppBar = AppBar(
      backgroundColor: Colors.grey[800]
);

var myDrawer = const MyDrawer();

const List<String> workoutCategories = <String>[
  'Running', 'Cycling', 'Walking',
  'Hiking', 'Swimming', 'Yoga',
  ];

List<Workout> workouts = [
  Workout(
    category: 'Cycling',
    distance: 13.6,
    calories: 500,
    startDate: DateTime(2024, 8, 31, 7, 30),  // August 31, 2024, 7:30 AM
    endDate: DateTime(2024, 8, 31, 8, 15),    // August 31, 2024, 8:15 AM
  ),
  Workout(
    category: 'Running',
    distance: 5.2,
    calories: 400,
    startDate: DateTime(2024, 9, 1, 6, 0),   // September 1, 2024, 6:00 AM
    endDate: DateTime(2024, 9, 1, 6, 45),    // September 1, 2024, 6:45 AM
  ),
  Workout(
    category: 'Swimming',
    distance: 1.0,
    calories: 300,
    startDate: DateTime(2024, 9, 2, 12, 30), // September 2, 2024, 12:30 PM
    endDate: DateTime(2024, 9, 2, 13, 15),   // September 2, 2024, 1:15 PM
  ),
  Workout(
    category: 'Hiking',
    distance: 8.7,
    calories: 350,
    startDate: DateTime(2024, 9, 3, 9, 0),   // September 3, 2024, 9:00 AM
    endDate: DateTime(2024, 9, 3, 11, 30),   // September 3, 2024, 11:30 AM
  ),
  Workout(
    category: 'Yoga',
    distance: 0.0,
    calories: 150,
    startDate: DateTime(2024, 9, 4, 18, 0),  // September 4, 2024, 6:00 PM
    endDate: DateTime(2024, 9, 4, 19, 0),    // September 4, 2024, 7:00 PM
  ),
];

List<Workout> getWorkoutList() {
  return workouts;
}

List<Friend> friends = [
  Friend(
    name: 'Mitch',
    email: 'mitchkoko22@gmail.com'
  ),
  Friend(
    name: 'Sarah',
    email: 'sarahjones98@yahoo.com'
  ),
  Friend(
    name: 'David',
    email: 'davidbrown23@hotmail.com'
  ),
  Friend(
    name: 'Emily',
    email: 'emilysmith11@gmail.com'
  ),
  Friend(
    name: 'Alex',
    email: 'alexjohnson77@outlook.com'
  ),
];

List<Friend> getFriendList() {
  return friends;
}