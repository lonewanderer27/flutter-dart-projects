import 'package:flutter/material.dart';

class EmptyChat extends StatelessWidget {
  const EmptyChat({super.key, this.myself = false});
  final bool myself;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum,
            size: 50,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            myself ? 'Welcome to your notes' : 'Chat is empty',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Text(
            myself ? 'Send any message to save' : 'Be the one to break the ice',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
