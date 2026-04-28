import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String userId;

  ChatScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Center(child: Text("User ID: $userId")),
    );
  }
}
