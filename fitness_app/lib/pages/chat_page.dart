import 'package:fitness_app/components/chat_bubble.dart';
import 'package:fitness_app/components/conversation_list.dart';
import 'package:fitness_app/components/message_input.dart';
import 'package:fitness_app/components/typing_indicator.dart';
import 'package:fitness_app/models/message.dart';
import 'package:fitness_app/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> _messages = [];
  String? _conversationId;
  final _drawerKey = GlobalKey<ConversationListState>();
  bool _isLoading = false;
  bool _shouldAnimateLastAssistant = false;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Refresh drawer so it fetches conversations when ChatPage opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _drawerKey.currentState?.refresh();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _drawerKey.currentState?.refresh(); // run this each time the widget is rebuilt
  }

  void _loadConversation(String convoId) async {
    final convo = await ChatService.getConversation(convoId);

    setState(() {
      _conversationId = convo.id;
      _messages = convo.messages ?? [];
      _shouldAnimateLastAssistant = false; // ❌ disable animation
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage(String text) async {
    final convoId = _conversationId ?? '00000000-0000-0000-0000-000000000000';
    print("Sending message: $text (convoId = $convoId)");

    if (text.trim().isEmpty) return;

    setState(() {
      _isLoading = true; // 🔥 show loading
    });

    _scrollToBottom();

    try {
      final updatedConvo = await ChatService.sendMessage(convoId, text);
      print("Got updated conversation with ${updatedConvo.messages?.length ?? 0} messages");

      setState(() {
        _conversationId = updatedConvo.id;
        _messages = updatedConvo.messages ?? [];
        _shouldAnimateLastAssistant = true; // ✅ only animate this reply
        _isLoading = false; // ✅ hide loading
      });

      _drawerKey.currentState?.refresh();

      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } catch (e, st) {
      print("Failed to send message: $e\n$st");

      setState(() {
        _isLoading = false; // ❌ also hide on error
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send message: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ConversationList(
          key: _drawerKey,
          onSelectConversation: (id) => _loadConversation(id),
        ),
      ),
      appBar: AppBar(title: const Text("AI Assistant")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey),
                          SizedBox(height: 16),
                          Text("Start the conversation", style: TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_isLoading && index == _messages.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                                    SizedBox(width: 8),
                                    Text("Assistant is thinking..."),
                                  ],
                                ),
                              ),
                            );
                          }

                          final msg = _messages[index];
                          final isLast = index == _messages.length - 1;
                          final isAssistant = msg.sender == 'assistant';

                          final useTyping = isAssistant && isLast && _shouldAnimateLastAssistant;

                          // 🧼 reset flag so it won’t re-trigger after animation
                          if (useTyping) {
                            _shouldAnimateLastAssistant = false;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: MessageBubble(
                              content: msg.content,
                              isUser: msg.sender == 'user',
                              useTypingEffect: useTyping,
                            ),
                          );
                        },
                      ),
                    ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(20),
                child: MessageInput(onSend: _sendMessage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}