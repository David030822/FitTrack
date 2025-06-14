import 'package:fitness_app/models/advice.dart';
import 'package:fitness_app/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'advice_detail_page.dart';

class AdvicePage extends StatefulWidget {
  const AdvicePage({super.key});

  @override
  State<AdvicePage> createState() => _AdvicePageState();
}

class _AdvicePageState extends State<AdvicePage> {
  List<Advice> _adviceList = []; // Load from API
  bool _isThinking = false;

  void _fetchAdvices() async {
    try {
      final advices = await ChatService.getAdvices();
      setState(() {
        _adviceList = advices;
      });
    } catch (e, st) {
      print("Failed to fetch conversations: $e\n$st");
    }
  }

  void _showAdviceInputDialog() {
    String userInput = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ask for Advice"),
        content: TextField(
          onChanged: (value) => userInput = value,
          decoration: const InputDecoration(hintText: "What would you like help with?"),
        ),
        actions: [
          MaterialButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          MaterialButton(
            child: const Text("Send"),
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isThinking = true);

              final advice = await ChatService.getAIAdvice(userInput);
              if (advice != null) {
                setState(() => _adviceList.add(advice));
              }

              _fetchAdvices();
              setState(() => _isThinking = false);
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // load all previous advices from DB
    _fetchAdvices();
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

  void _editTitle(BuildContext context, Advice advice) async {
    final controller = TextEditingController(text: advice.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Title"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Enter new title"),
        ),
        actions: [
          MaterialButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          MaterialButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text("Save")),
        ],
      ),
    );

    if (newTitle != null && newTitle.trim().isNotEmpty) {
      bool ok = await ChatService.updateAdviceTitle(advice.id, newTitle);

      if (ok) {
        // Reload conversations
        _fetchAdvices();

        showSuccess("Advice title updated successfully!");
      } else {
        showError("Failed to update advice title!");
      }
    }
  }

  void _deleteAdvice(BuildContext context, Advice advice) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Advice"),
        content: const Text("Are you sure you want to delete this advice?"),
        actions: [
          MaterialButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          MaterialButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (confirmed == true) {
      await ChatService.deleteAdvice(advice.id);
      _fetchAdvices(); // Refresh after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Advice")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAdviceInputDialog,
        label: const Text("Get Advice"),
        icon: const Icon(Icons.psychology),
        backgroundColor: Colors.deepOrange,
      ),
      body: _isThinking
      ? const Center(child: CircularProgressIndicator())
      : ListView.builder(
        itemCount: _adviceList.length,
        itemBuilder: (context, index) {
          final advice = _adviceList[index];
          return Slidable(
            key: ValueKey(advice.id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => _editTitle(context, advice),
                  backgroundColor: Colors.blue,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (_) => _deleteAdvice(context, advice),
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                title: Text(
                  advice.title.isEmpty ? "New Advice" : advice.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  advice.message.length > 50
                      ? "${advice.message.substring(0, 50)}..."
                      : advice.message,
                ),
                trailing: Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(advice.date.toLocal()),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdviceDetailPage(advice: advice),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}