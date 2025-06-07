import 'package:fitness_app/components/my_drawer.dart';
import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:flutter/material.dart';

const String BASE_URL = 'http://192.168.0.142:5082';   // 1
// const String BASE_URL = 'http://192.168.0.226:5082';   // 2
// const String BASE_URL = 'https://20e0-217-73-170-83.ngrok-free.app';   // 3

var myDefaultBackgroundColor = Colors.grey[300];

var myAppBar = AppBar(
      backgroundColor: Colors.grey[800]
);

var myDrawer = const MyDrawer();

List<Workout> workouts = [
  Workout(
    id: 1,
    category: 'Cycling',
    distance: 13.6,
    calories: 200,
    startDate: DateTime(2024, 8, 31, 7, 30),  // August 31, 2024, 7:30 AM
    endDate: DateTime(2024, 8, 31, 8, 15),    // August 31, 2024, 8:15 AM
    duration: "",
    avgPace: ""
  ),
  Workout(
    id: 2,
    category: 'Gym',
    distance: 0.0,
    calories: 300,
    startDate: DateTime(2024, 8, 31, 14, 30),  // August 31, 2024, 2:30 PM
    endDate: DateTime(2024, 8, 31, 16, 15),    // August 31, 2024, 4:15 PM
    duration: "",
    avgPace: ""
  ),
  Workout(
    id: 3,
    category: 'Running',
    distance: 5.2,
    calories: 400,
    startDate: DateTime(2024, 9, 1, 6, 0),   // September 1, 2024, 6:00 AM
    endDate: DateTime(2024, 9, 1, 6, 45),    // September 1, 2024, 6:45 AM
    duration: "",
    avgPace: ""
  ),
  Workout(
    id: 4,
    category: 'Swimming',
    distance: 1.0,
    calories: 300,
    startDate: DateTime(2024, 9, 2, 12, 30), // September 2, 2024, 12:30 PM
    endDate: DateTime(2024, 9, 2, 13, 15),   // September 2, 2024, 1:15 PM
    duration: "",
    avgPace: ""
  ),
  Workout(
    id: 5,
    category: 'Hiking',
    distance: 8.7,
    calories: 350,
    startDate: DateTime(2024, 9, 3, 9, 0),   // September 3, 2024, 9:00 AM
    endDate: DateTime(2024, 9, 3, 11, 30),   // September 3, 2024, 11:30 AM
    duration: "",
    avgPace: ""
  ),
  Workout(
    id: 6,
    category: 'Yoga',
    distance: 0.0,
    calories: 150,
    startDate: DateTime(2024, 9, 4, 18, 0),  // September 4, 2024, 6:00 PM
    endDate: DateTime(2024, 9, 4, 19, 0),    // September 4, 2024, 7:00 PM
    duration: "",
    avgPace: ""
  ),
];

List<Workout> getWorkoutList() {
  return workouts;
}

List<User> users = [
  User(
    id: 1,
    firstName: 'David',
    lastName: 'Demeter',
    email: 'demeter.david@gmail.com',
    username: 'David',
    phoneNum: '0745805425',
    profileImagePath: 'assets/images/DavidBysCars.png'
  ),
  User(
    id: 2,
  firstName: 'Emma',
  lastName: 'Johnson',
  email: 'emma.johnson@gmail.com',
  username: 'Em',
  phoneNum: '0765481234',
  profileImagePath: '',
  ),
  User(
    id: 3,
    firstName: 'Liam',
    lastName: 'Smith',
    email: 'liam.smith@gmail.com',
    username: 'Liam',
    phoneNum: '0754123467',
    profileImagePath: '',
  ),
  User(
    id: 4,
    firstName: 'Sophia',
    lastName: 'Brown',
    email: 'sophia.brown@gmail.com',
    username: 'Sophie',
    phoneNum: '0773219876',
    profileImagePath: '',
  ),
  User(
    id: 5,
    firstName: 'Noah',
    lastName: 'Davis',
    email: 'noah.davis@gmail.com',
    username: 'Noah',
    phoneNum: '0723456789',
    profileImagePath: '',
  ),
  User(
    id: 6,
    firstName: 'Ava',
    lastName: 'Taylor',
    email: 'ava.taylor@gmail.com',
    username: 'Ava',
    phoneNum: '0734567890',
    profileImagePath: '',
  ),
];

List<User> getUserList(){
  return users;
}