import 'dart:io';
import 'dart:convert';

import 'package:customer_app/models/conversation.dart';
import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/api_service.dart';
import '../services/log_service.dart';

class ChatMessageProvider extends ChangeNotifier {
  bool isLoadingMessages = false;
  bool isSendingMessage = false;
  bool isLoadingConversations = false;
  List<ChatMessage> messages = [];
  List<Conversation> conversations = [];

  Future<void> fetchMessages(int conversationId) async {
    isLoadingMessages = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth(
        'chat/messages/$conversationId',
      );

      if (response != null && response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];

        messages = data.map((msg) => ChatMessage.fromJson(msg)).toList();
      } else {
        LogService.error("Failed to fetch messages: ${response?.statusCode}");
      }
    } catch (e) {
      LogService.error("Error fetching messages: $e");
    } finally {
      isLoadingMessages = false;
      notifyListeners();
    }
  }

  Future<bool> sendMessage({
    required int conversationId,
    required int senderId,
    required String senderType,
    required int receiverId,
    required String receiverType,
    required String messageText,
    File? imageFile,
  }) async {
    isSendingMessage = true;
    notifyListeners();

    final body = {
      "conversation_id": conversationId, // no .toString()
      "sender_id": senderId,
      "sender_type": senderType,
      "receiver_id": receiverId,
      "receiver_type": receiverType,
      "message": messageText,
    };

    try {
      final response = await ApiService.postWithAuth(
        'chat/messages',
        body,
        files: imageFile != null ? {'image': imageFile} : null,
      );

      if (response != null && response['success'] == true) {
        messages.add(ChatMessage.fromJson(response['data']));
        notifyListeners();
        return true;
      } else {
        LogService.error("Failed to send message: ${response?['message']}");
      }
    } catch (e) {
      LogService.error("Error sending message: $e");
    } finally {
      isSendingMessage = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> deleteConversation(int conversationId) async {
    try {
      final response = await ApiService.deleteWithAuth(
        'chat/conversations/$conversationId',
      );

      if (response != null && response.statusCode == 200) {
        LogService.info("Conversation deleted successfully.");
        return true;
      } else {
        LogService.error(
          "Failed to delete conversation: ${response?.statusCode}",
        );
      }
    } catch (e) {
      LogService.error("Error deleting conversation: $e");
    }
    return false;
  }

  Future<void> fetchConversations(int userId, String userType) async {
    final body = {'user_id': userId, 'user_type': userType};

    isLoadingConversations = true;
    notifyListeners();

    try {
      final response = await ApiService.postWithAuth(
        'get-conversation-list',
        body,
      );

      if (response != null && response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        conversations =
            data.map((item) {
              return Conversation.fromJson(item);
            }).toList();
      } else {
        LogService.error(
          "Failed to fetch conversations: ${response?['message']}",
        );
      }
    } catch (e) {
      LogService.error("Error fetching conversations: $e");
    } finally {
      isLoadingConversations = false;
      notifyListeners();
    }
  }
}
