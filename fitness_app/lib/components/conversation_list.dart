import 'package:fitness_app/components/drawer_tile.dart';
import 'package:fitness_app/models/conversation.dart';
import 'package:fitness_app/pages/chat_page.dart';
import 'package:fitness_app/pages/home_page.dart';
import 'package:fitness_app/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ConversationList extends StatefulWidget {
  final void Function(String conversationId) onSelectConversation;

  const ConversationList({
    super.key,
    required this.onSelectConversation,
  });

  @override
  State<ConversationList> createState() => ConversationListState();
}

class ConversationListState extends State<ConversationList> {
  List<Conversation> _conversations = [];

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  void _fetchConversations() async {
    try {
      final conversations = await ChatService.getConversations();
      setState(() {
        _conversations = conversations;
      });
    } catch (e, st) {
      print("Failed to fetch conversations: $e\n$st");
    }
  }

  void refresh() => _fetchConversations();

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

  void _editTitle(BuildContext context, Conversation convo) async {
    final controller = TextEditingController(text: convo.title);
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text("Save")),
        ],
      ),
    );

    if (newTitle != null && newTitle.trim().isNotEmpty) {
      bool ok = await ChatService.updateConversationTitle(convo.id, newTitle);

      if (ok) {
        // Reload conversations
        _fetchConversations();

        showSuccess("Chat title updated successfully!");
      } else {
        showError("Failed to update chat title!");
      }
    }
  }

  void _deleteConversation(BuildContext context, Conversation convo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Conversation"),
        content: const Text("Are you sure you want to delete this conversation?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (confirmed == true) {
      await ChatService.deleteConversation(convo.id);
      _fetchConversations(); // Refresh after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatPage())),
                icon: const Icon(Icons.add, size: 18),
                label: const Text("New Chat"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 12), // tighter spacing
                  textStyle: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final convo = _conversations[index];
                return Slidable(
                  key: ValueKey(convo.id),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => _editTitle(context, convo),
                        backgroundColor: Colors.blue,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (_) => _deleteConversation(context, convo),
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                    child: ListTile(
                    title: Text(convo.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(convo.lastUpdated.toLocal())),
                    onTap: () {
                      Navigator.of(context).pop(); // close drawer
                      widget.onSelectConversation(convo.id);
                    },
                  )
                );
              },
            ),
          ),
          DrawerTile(
            title: 'B A C K',
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}