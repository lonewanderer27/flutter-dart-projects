import 'package:flutter/material.dart';
import 'package:warp_chats/models/thread.dart';

class ThreadItem extends StatelessWidget {
  const ThreadItem(this.thread, {super.key});
  final Thread thread;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(thread.name),
    );
  }
}
