import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warp_chats/models/chat.dart';
import 'package:warp_chats/screens/signin_screen.dart';

class ChatItem extends StatelessWidget {
  const ChatItem(this.chat, {super.key});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    bool me = chat.userId == fa.currentUser!.uid ? true : false;

    DateTime dateTimeToday = DateTime.now();
    String formattedDate = '';
    // if the date is still today, only output the time
    if (dateTimeToday.day == chat.createdAt.day) {
      formattedDate = DateFormat('jm').format(chat.createdAt);
    } else {
      // otherwise, include a "Yesterday" at the start
      formattedDate = 'Yesterday at $formattedDate';
    }

    return Expanded(
        child: Row(
      // if it's our chat, we display it to the right
      // if it's others, we display it to the left
      mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              crossAxisAlignment:
                  me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  chat.message,
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyLarge!.fontSize),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
