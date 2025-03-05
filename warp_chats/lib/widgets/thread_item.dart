import 'package:flutter/material.dart';
import 'package:warp_chats/models/thread.dart';
import 'package:warp_chats/screens/thread_screen.dart';

class ThreadItem extends StatelessWidget {
  const ThreadItem(this.thread, {super.key});
  final Thread thread;

  @override
  Widget build(BuildContext context) {
    void handleTap() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => ThreadScreen(thread)));
    }

    return ListTile(
      title: Text(thread.name),
      onTap: handleTap,
    );
  }
}
