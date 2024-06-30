import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/chat.dart';
import '../model/my_user.dart';
import 'chat_screen.dart';


class DoctorChatListScreen extends StatefulWidget {

  const DoctorChatListScreen({Key? key}) : super(key: key);
  @override
  State<DoctorChatListScreen> createState() => _DoctorChatListScreenState();
}

class _DoctorChatListScreenState extends State<DoctorChatListScreen> {
  // int _selectedIndex = 2; // To track the currently selected tab
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  Stream<List<Chat>> _getChats() {
    return _firestore.collection('chats')
        .where('participants', arrayContains: _user!.uid)
        .orderBy('lastMessageTimestamp', descending: true) // Order by timestamp descending
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Chat.fromDocument(doc)).toList());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Patient Chats")),
      body: StreamBuilder<List<Chat>>(
        stream: _getChats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final chats = snapshot.data!;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final otherParticipant = chat.participants.firstWhere((
                  uid) => uid != _user!.uid);

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users')
                    .doc(otherParticipant)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return Container();
                  }
                  final user = MyUser.fromDocument(userSnapshot.data!);
                  return Card(
                    child: ListTile(
                      title: Text(user.userName),
                      subtitle: Text(chat.lastMessage),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                chatId: chat.id, recipientId: user.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}