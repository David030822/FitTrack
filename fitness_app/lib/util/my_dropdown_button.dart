import 'dart:convert';
import 'package:fitness_app/responsive/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyDropdownButton extends StatefulWidget {
  final Function(int) onCategorySelected; // Callback function to pass selected category ID

  const MyDropdownButton({super.key, required this.onCategorySelected});

  @override
  State<MyDropdownButton> createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  Map<String, int> categoryMap = {};
  String? selectedCategory;
  bool isLoading = true;
  final String baseUrl = BASE_URL;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api/categories'));

    if (response.statusCode == 200) {
      List<dynamic> categories = jsonDecode(response.body);
      setState(() {
        categoryMap = {for (var category in categories) category['name']: category['id']};
        selectedCategory = categoryMap.keys.first;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : DropdownButton<String>(
            value: selectedCategory,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Color(0xFFF15C2A), fontSize: 20),
            underline: Container(height: 2, color: const Color(0xFFF15C2A)),
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue;
              });
              widget.onCategorySelected(categoryMap[newValue]!);
            },
            items: categoryMap.keys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
  }
}
