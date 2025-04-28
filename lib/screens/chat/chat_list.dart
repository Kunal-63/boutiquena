import 'package:customer_app/screens/chat/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/providers/chat_message_provider.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:provider/provider.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatMessageProvider>(
        context,
        listen: false,
      ).fetchConversations(
        38,
        'user',
      ); // Replace with actual user_id and user_type
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatMessageProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: CommonAppBar(
          title: "Live Chat",
          menuPressed: () {},
          menuItems: [],
        ),
      ),
      body:
          chatProvider.isLoadingConversations
              ? const Center(child: CircularProgressIndicator())
              : chatProvider.conversations.isEmpty
              ? const Center(child: Text('No conversations available'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: chatProvider.conversations.length,
                itemBuilder: (context, index) {
                  final conversation = chatProvider.conversations[index];

                  return GestureDetector(
                    onTap: () {
                      // Navigate to the chat screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChatScreen(
                                conversationId: conversation.conversationId,
                                senderId: 38, // hardcoded sender id (your user)
                                senderType: 'user', // hardcoded sender type
                                receiverId: conversation.user2Id,
                                receiverType: conversation.user2Type,
                              ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(
                                0xFF1D2D50,
                              ), // Dark blue background
                              child: Text(
                                _getInitials(conversation.name),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                conversation.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return parts[0][0] + parts[1][0];
    } else if (parts.isNotEmpty) {
      return parts[0][0];
    } else {
      return '';
    }
  }
}
