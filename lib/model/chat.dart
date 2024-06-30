import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTimestamp;

  Chat({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTimestamp,
  });

  factory Chat.fromDocument(DocumentSnapshot doc) {
    return Chat(
      id: doc.id,
      participants: List<String>.from(doc['participants']),
      lastMessage: doc['lastMessage'],
      lastMessageTimestamp: (doc['lastMessageTimestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTimestamp,
    };
  }
}