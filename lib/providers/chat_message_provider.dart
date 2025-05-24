import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/api_service.dart';
import '../services/log_service.dart';

class ChatMessageProvider extends ChangeNotifier {
  bool isLoadingMessages = false;
  bool isSendingMessage = false;
  List<ChatMessage> messages = [];

  /// Fetch messages for a given vendorId
  Future<void> fetchMessages(int vendorId) async {
    isLoadingMessages = true;
    notifyListeners();

    try {
      final response = await ApiService.getWithAuth(
        'chat/messages/user/$vendorId',
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

  /// Send message (text or image)
  Future<bool> sendMessage({
    required int senderId,
    required String senderType,
    String? messageText,
    File? imageFile,
  }) async {
    isSendingMessage = true;
    notifyListeners();

    final body = {
      "sender_id": senderId.toString(),
      "sender_type": senderType,
      if (messageText != null) "message": messageText,
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
}
