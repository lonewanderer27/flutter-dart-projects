import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warp_chats/models/chat.dart';
import 'package:warp_chats/models/thread.dart';
import 'package:warp_chats/screens/signin_screen.dart';
import 'package:warp_chats/widgets/chat_item.dart';

class ThreadScreen extends StatefulWidget {
  const ThreadScreen(this.thread, {super.key});
  final Thread thread;

  @override
  State<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitMessage() async {
    final message = _messageController.text;

    // return if the message is empty
    if (message.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // add the new message
    fs.collection('threads').doc(widget.thread.id).collection('chats').add({
      'message': message,
      'createdAt': DateTime.now().toIso8601String().toString(),
      'userId': fa.currentUser!.uid
    });

    // reset our text input
    _messageController.clear();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // fetch all the chats
    Stream<QuerySnapshot> chats = fs
        .collection('threads')
        .doc(widget.thread.id)
        .collection('chats')
        .orderBy('createdAt', descending: false)
        .snapshots();

    // fetch all the users in this thread
    Stream<QuerySnapshot> users = fs
        .collection('threads')
        .doc(widget.thread.id)
        .collection('users')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.thread.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                initialData: chats,
                stream: chats,
                builder: (ctx, chatsSnapshot) {
                  if (chatsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    // TODO: Return a Skeletonizer items loading
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!chatsSnapshot.hasData ||
                      chatsSnapshot.data!.docs.isEmpty) {
                    // TODO: Animated empty emoji
                    return const Center(
                      child: Text(''),
                    );
                  }

                  final loadedChats = chatsSnapshot.data!.docs;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: loadedChats.length,
                        itemBuilder: (ctx, index) {
                          // create a new chat item

                          Chat chat = Chat(
                              id: loadedChats[index].id,
                              createdAt: DateTime.parse(
                                  loadedChats[index].get('createdAt')),
                              message: loadedChats[index].get('message'),
                              userId: loadedChats[index].get('userId'),
                              // TODO: Replace with actual username
                              userName: 'user 🤩');

                          return ChatItem(chat);
                        }),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Expanded(
                child: Row(
              children: [
                Expanded(
                    child: TextField(
                  readOnly: _isLoading,
                  controller: _messageController,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  decoration: InputDecoration(label: Text('Send a message...')),
                )),
                IconButton.filled(
                    onPressed: _isLoading ? null : _submitMessage,
                    icon: Icon(Icons.send))
              ],
            )),
          )
        ],
      ),
    );
  }
}
