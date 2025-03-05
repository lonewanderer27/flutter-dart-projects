import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warp_chats/models/thread.dart';
import 'package:warp_chats/screens/signin_screen.dart';
import 'package:warp_chats/widgets/thread_item.dart';

class Threads_Screen extends StatefulWidget {
  const Threads_Screen({super.key});

  @override
  State<Threads_Screen> createState() => _Threads_ScreenState();
}

class _Threads_ScreenState extends State<Threads_Screen> {
  @override
  void initState() {
    super.initState();
  }

  void _handleLogout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> myThreads = fs
        .collection('user_threads')
        .doc(fa.currentUser!.uid)
        .collection('threads')
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          title: Text('Warp Chats'),
          actions: [
            IconButton(
              onPressed: _handleLogout,
              icon: Icon(Icons.exit_to_app),
              color: Theme.of(context).colorScheme.primary,
            )
          ],
        ),
        body: StreamBuilder(
            stream: myThreads,
            builder: (ctx, threadsSnapshot) {
              if (threadsSnapshot.connectionState == ConnectionState.waiting) {
                // TODO: Return a Skeletonizer items loading
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!threadsSnapshot.hasData ||
                  threadsSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Hi there! Quite empty no?'),
                );
              }

              final loadedThreads = threadsSnapshot.data!.docs;

              return ListView.builder(
                  itemCount: loadedThreads.length,
                  itemBuilder: (ctx, index) {
                    // create a new Thread item

                    Thread thread = Thread(
                        id: loadedThreads[index].id,
                        name: loadedThreads[index].get('name'));

                    return ThreadItem(thread);
                  });
            }),
        floatingActionButton:
            FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)));
  }
}
