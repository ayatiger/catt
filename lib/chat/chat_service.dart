import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/chat.dart';


class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getOrCreateChat(String recipientId) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    final chats = await _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUser.uid)
        .get();

    for (var doc in chats.docs) {
      final chat = Chat.fromDocument(doc);
      if (chat.participants.contains(recipientId)) {
        return chat.id;
      }
    }

    final newChat = await _firestore.collection('chats').add({
      'participants': [currentUser.uid, recipientId],
      'lastMessage': '',
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
    });

    return newChat.id;
  }
}