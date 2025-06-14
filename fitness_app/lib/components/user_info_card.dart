import 'package:fitness_app/models/user.dart';
import 'package:fitness_app/pages/advice_page.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:flutter/material.dart';

class UserInfoCard extends StatefulWidget {
  final User user;
  final Function(User) onSave;

  const UserInfoCard({
    required this.user,
    required this.onSave,
    super.key,
  });

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  late bool isEditing;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController bodyFatController;
  late TextEditingController goalController;
  String? gender;

  @override
  void initState() {
    super.initState();
    isEditing = false;
    ageController = TextEditingController(text: widget.user.age.toString());
    heightController = TextEditingController(text: widget.user.height.toString());
    weightController = TextEditingController(text: widget.user.weight.toString());
    bodyFatController = TextEditingController(text: widget.user.bodyFat.toString());
    goalController = TextEditingController(text: widget.user.goal ?? '');
    gender = widget.user.gender;
  }

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    bodyFatController.dispose();
    goalController.dispose();
    super.dispose();
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _saveChanges() async {
    if (!isEditing) {
      // If we're not editing, switch to edit mode
      setState(() => isEditing = true);
      return;
    }

    final updatedUser = widget.user.copyWith(
      age: int.tryParse(ageController.text) ?? widget.user.age,
      height: double.tryParse(heightController.text) ?? widget.user.height,
      weight: double.tryParse(weightController.text) ?? widget.user.weight,
      bodyFat: double.tryParse(bodyFatController.text) ?? widget.user.bodyFat,
      goal: goalController.text,
      gender: gender,
    );

    final updatedData = {
      'age': updatedUser.age,
      'height': updatedUser.height,
      'weight': updatedUser.weight,
      'bodyFat': updatedUser.bodyFat,
      'gender': updatedUser.gender,
      'goal': updatedUser.goal,
    };

    final success = await ApiService.updateUserData(updatedData);

    if (success) {
      widget.onSave(updatedUser); // Pass it back to parent
      setState(() {
        // update UI locally
        ageController.text = updatedUser.age.toString();
        heightController.text = updatedUser.height.toString();
        weightController.text = updatedUser.weight.toString();
        bodyFatController.text = updatedUser.bodyFat.toString();
        goalController.text = updatedUser.goal ?? '';
        gender = updatedUser.gender;
        isEditing = false;
      });
      showSuccess('Profile updated successfully!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            isEditing
                ? _buildField("Age", ageController)
                : _buildRow("Age", widget.user.age.toString()),

            isEditing
                ? _buildGenderDropdown()
                : _buildRow("Gender", widget.user.gender ?? ''),

            isEditing
                ? _buildField("Height (cm)", heightController)
                : _buildRow("Height", "${widget.user.height} cm"),

            isEditing
                ? _buildField("Weight (kg)", weightController)
                : _buildRow("Weight", "${widget.user.weight} kg"),

            isEditing
                ? _buildField("Body fat", bodyFatController)
                : _buildRow("Body fat", widget.user.bodyFat.toString()),

            isEditing
                ? _buildField("Goal", goalController)
                : _buildRow("Goal", widget.user.goal ?? ''),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.edit),
                  label: Text(isEditing ? "Save" : "Edit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdvicePage()),
                    );
                  },
                  icon: const Icon(Icons.psychology),
                  label: const Text("AI Advice"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    final genders = ['Male', 'Female', 'Other'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: gender,
        decoration: InputDecoration(
          labelText: "Gender",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: genders
            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
            .toList(),
        onChanged: (val) => setState(() => gender = val),
      ),
    );
  }
}