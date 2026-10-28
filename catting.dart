
import 'package:flutter/material.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;

  ChatMessage({
    required this.text,
    required this.isMe,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  final List<ChatMessage> messages = [
    ChatMessage(
      text: 'Hi! Welcome to my chat app.',
      isMe: false,
    ),
    ChatMessage(
      text: 'Hello! How are you?',
      isMe: true,
    ),
  ];

  void sendMessage() {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(text: text, isMe: true),
      );
    });

    controller.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.chat,
                color: Colors.teal,
              ),
            ),
            SizedBox(width: 12),
            Text('My Chat App'),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                return Align(
                  alignment: message.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth:
                          MediaQuery.of(context).size.width *
                              0.75,
                    ),
                    decoration: BoxDecoration(
                      color: message.isMe
                          ? Colors.teal
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isMe
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                  color: Colors.teal,
                  iconSize: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
