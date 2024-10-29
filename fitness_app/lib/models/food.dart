import 'package:isar/isar.dart';

part 'food.g.dart';

@Collection()
class Food {
  // food id
  Id id = Isar.autoIncrement;

  // food name
  late String name;

  // food calories
  late double calories;

  // constructor
  Food(this.name, this.calories);
}