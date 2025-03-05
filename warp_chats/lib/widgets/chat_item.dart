import 'package:flutter/material.dart';
import 'package:warp_chats/models/chat.dart';
import 'package:warp_chats/screens/signin_screen.dart';

class ChatItem extends StatelessWidget {
  const ChatItem(this.chat, {super.key});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    bool me = chat.userId == fa.currentUser!.uid ? true : false;

    return Expanded(
        child: Row(
      // if it's our chat, we display it to the right
      // if it's others, we display it to the left
      mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment:
                  me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(chat.message),
                Text(chat.createdAt.toLocal().toString())
              ],
            ),
          ),
        )
      ],
    ));
  }
}
