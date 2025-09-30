import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/pages/home_page.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:flutter/material.dart';

class CompleteProfileScreen extends StatefulWidget {
  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bodyFatController = TextEditingController();
  String? _selectedGender;
  String? _selectedGoal;
  late Future<User?> _userFuture;

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> goals = ['Lose Weight', 'Gain Muscle', 'Stay Fit'];

  Future<User?> fetchUser() async {
    return await ApiService.getUserData();
  }

  void _populateControllers(User user) {
    _ageController.text = user.age.toString();
    _heightController.text = user.height.toString();
    _weightController.text = user.weight.toString();
    _bodyFatController.text = user.bodyFat?.toString() ?? '';

    // Normalize and assign only if value exists in the list
    // final normalizedGender = _normalizeMatch(user.gender, genders);
    // final normalizedGoal = _normalizeMatch(user.goal, goals);

    // _selectedGender = normalizedGender;
    // _selectedGoal = normalizedGoal;
  }

  // String? _normalizeMatch(String? input, List<String> options) {
  //   if (input == null) return null;
  //   return options.firstWhere(
  //     (option) => option.toLowerCase() == input.toLowerCase(),
  //     orElse: () => '',
  //   );
  // }

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUser().then((user) {
      if (user != null) {
        _populateControllers(user);
      }
      return user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfc7905),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Complete Your Profile',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField('Age', _ageController),
                  _buildTextField('Height (cm)', _heightController),
                  _buildTextField('Weight (kg)', _weightController),
                  _buildTextField('Body fat', _bodyFatController),

                  _buildDropdown('Gender', _selectedGender, genders, (value) {
                    setState(() => _selectedGender = value);
                  }),

                  _buildDropdown('Fitness Goal', _selectedGoal, goals, (value) {
                    setState(() => _selectedGoal = value);
                  }),

                  const SizedBox(height: 30),

                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFfc7905),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await ApiService.updateUserData({
                              'age': int.parse(_ageController.text),
                              'height': double.parse(_heightController.text),
                              'weight': double.parse(_weightController.text),
                              'bodyFat': double.parse(_bodyFatController.text),
                              'gender': _selectedGender,
                              'goal': _selectedGoal,
                            });
                      
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const HomePage()),
                              );
                            }
                          }
                        },
                        child: const Text('Continue', style: TextStyle(fontSize: 18)),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage()),
                            );
                        },
                        child: const Text('Skip', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown(String label, String? selected, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selected,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        dropdownColor: Colors.deepOrange[300],
        iconEnabledColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        )).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Required' : null,
      ),
    );
  }
}