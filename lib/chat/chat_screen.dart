import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/message.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String recipientId;
  static const String routeName = 'chats';

  ChatScreen({required this.chatId, required this.recipientId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();

  User? _user;
  late CollectionReference _messagesRef;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _messagesRef = _firestore.collection('chats').doc(widget.chatId).collection('messages');
  }

  Future<void> _sendMessage(String text) async {
    if (_user != null && text.isNotEmpty) {
      QuerySnapshot messages = await _firestore.collection('chats').doc(widget.chatId).collection('messages').get();

      final message = Message(
        id: messages.size + 1,
        senderId: _user!.uid,
        text: text,
        timestamp: DateTime.now(),
      );
      await _messagesRef.add(message.toMap());

      await _firestore.collection('chats').doc(widget.chatId).update({
        'lastMessage': text,
        'lastMessageTimestamp': DateTime.now(),
      });

      _controller.clear();
    }
  }

  Stream<List<Message>> _getMessages() {
    return _messagesRef.orderBy('id').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => Message.fromDocument(doc)).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final collectionRef =
                  FirebaseFirestore.instance.collection('chats').doc(widget.chatId).collection('messages');

              // Get all documents in the collection
              QuerySnapshot querySnapshot = await collectionRef.get();

              // Iterate over each document and delete it
              for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
                await docSnapshot.reference.delete();
              }

              print("All documents in the collection have been deleted.");

              // _messagesRef.orderBy('id').snapshots().map(
              //   (snapshot) {
              //     print("snapshot object");
              //     print(snapshot.docs);
              //   },
              // );
              // await FirebaseFirestore.instance.recursiveDelete(_firestore.collection('chats').doc(widget.chatId).collection("messages"));

              //await _firestore.collection('chats').doc(widget.chatId).collection("messages").listDocuments();
            },
            icon: Icon(
              Icons.delete,
            ),
          )
        ],
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          title: Text(message.text),
                          subtitle: Text(
                            DateFormat('h:mm a').format(message.timestamp),
                            style: TextStyle(
                              fontSize: 12.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: message.senderId == _user!.uid ? Icon(Icons.person) : null,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


//   Scaffold(
//   appBar: AppBar(
//     title: Text('Chat'),
//   ),
//   body: Column(
//     children: [
//       Expanded(
//         child: StreamBuilder<List<Message>>(
//           stream: _getMessages(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return Center(child: CircularProgressIndicator());
//             }
//             final messages = snapshot.data!;
//             return
//             ListView.builder(
//               reverse: true,
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final message = messages[index];
//                 return ListTile(
//                   title: Text(message.text),
//                   subtitle: Text(message.timestamp.toString()),
//                   trailing: message.senderId == _user!.uid ? Icon(Icons.person) : null,
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _controller,
//                 decoration: InputDecoration(
//                   hintText: 'Enter message...',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.send),
//               onPressed: () => _sendMessage(_controller.text),
//             ),
//           ],
//         ),
//       ),
//     ],
//   ),
// );