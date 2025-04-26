import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/config/theme.dart';
import 'package:customer_app/providers/chat_message_provider.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:customer_app/widgets/headers/common_appbar.dart';
import 'package:customer_app/widgets/popup_menu_item.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final int conversationId;
  final int senderId;
  final String senderType;
  final int receiverId;
  final String receiverType;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.senderId,
    required this.senderType,
    required this.receiverId,
    required this.receiverType,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatMessageProvider>(
        context,
        listen: false,
      ).fetchMessages(widget.conversationId);
    });
  }

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile; // Update state with selected image
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  // Method to send the message along with the selected image
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty && _selectedImage == null)
      return; // Do nothing if both are empty

    // Send the message with or without an image
    Provider.of<ChatMessageProvider>(context, listen: false).sendMessage(
      conversationId: widget.conversationId,
      senderId: widget.senderId,
      senderType: widget.senderType,
      receiverId: widget.receiverId,
      receiverType: widget.receiverType,
      messageText: text,
      imageFile: _selectedImage != null ? File(_selectedImage!.path) : null,
    );

    // Clear message and reset selected image after sending
    _messageController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  // Method to delete the conversation
  void _deleteConversation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.white,
            title: Text(
              'Delete Conversation?',
              style: AppTextStyles.blackSubHeadingStyle().copyWith(
                fontSize: 20 * SizeConfig.widthScale,
              ),
            ),
            content: Text(
              'Are you sure you want to delete this conversation?',
              style: AppTextStyles.blackSubHeadingStyle().copyWith(
                fontSize: 16 * SizeConfig.widthScale,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.redw400Outfit().copyWith(
                    fontSize: 16 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Delete',
                  style: AppTextStyles.redw400Outfit().copyWith(
                    fontSize: 16 * SizeConfig.widthScale,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final success = await Provider.of<ChatMessageProvider>(
        context,
        listen: false,
      ).deleteConversation(widget.conversationId);

      if (success && mounted) {
        Navigator.pop(context);
      }
    }
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
          menuItems: [
            PopupMenuHelper.buildPopupMenuItem(
              0,
              'assets/icons/delete-icon.svg',
              'Delete',
              onTap: () {
                _deleteConversation();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                chatProvider.isLoadingMessages
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: chatProvider.messages.length,
                      itemBuilder: (context, index) {
                        final message = chatProvider.messages[index];
                        final isMe = message.senderId == widget.senderId;
                        final isImageMessage =
                            message.message?.contains('http://') ?? false;

                        return Align(
                          alignment:
                              isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  isMe
                                      ? AppTheme.primaryColor
                                      : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                                isImageMessage
                                    ? Image.network(
                                      message.message!,
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error),
                                    )
                                    : Text(
                                      message.message ?? '',
                                      style: TextStyle(
                                        color:
                                            isMe ? Colors.white : Colors.black,
                                      ),
                                    ),
                          ),
                        );
                      },
                    ),
          ),
          if (chatProvider.isSendingMessage)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (_selectedImage != null)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            clipBehavior: Clip.none,
                            children: [
                              Image.file(
                                File(_selectedImage!.path),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              // Cross Icon
                              Positioned(
                                top: -18,
                                right: -18,
                                child: IconButton(
                                  icon: Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.image, color: AppTheme.primaryColor),
                        onPressed: _pickImage,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send_rounded,
                          color: AppTheme.primaryColor,
                        ),
                        onPressed: _sendMessage,
                        splashRadius: 25,
                        iconSize: 28,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
