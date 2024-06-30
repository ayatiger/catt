// // class Message {
// //   static const String collectionName = 'message';
// //   String id;
// //   String roomId;
// //   String content;
// //   String senderId;
// //   String senderName;
// //   int dateTime;
// //
// //   Message({
// //     this.id = '',
// //     required this.roomId,
// //     required this.content,
// //     required this.senderId,
// //     required this.senderName,
// //     required this.dateTime,
// //   });
// //
// //   Message.fromJson(Map<String, dynamic> json)
// //       : this(
// //     id: json['id'] as String,
// //     roomId: json['room_id'] as String,
// //     content: json['content'] as String,
// //     senderId: json['senderId'] as String,
// //     senderName: json['senderName'] as String,
// //     dateTime: json['date_time'] as int,
// //   );
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'id': id,
// //       'room_id': roomId,
// //       'content': content,
// //       'senderId': senderId,
// //       'senderName': senderName,
// //       'date_time': dateTime,
// //     };
// //   }
// // }
//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Message {
//   static const String collectionName = 'message';
//   final String text;
//   final String userId;
//   final DateTime createdAt;
//
//   Message({
//     required this.text,
//     required this.userId,
//     required this.createdAt,
//   });
//
//   factory Message.fromMap(Map<String, dynamic> map) {
//     return Message(
//       text: map['text'] ?? '',
//       userId: map['userId'] ?? '',
//       createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//     );
//   }
//
//
//
//   Map<String, dynamic> toJson() {
//     return {
//       'text': text,
//       'userId': userId,
//       'cratedAt': createdAt,
//     };
//   }
//
//
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String text;
  final DateTime timestamp;
  final String imageUrl;

  Message({
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.imageUrl = '',
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      senderId: doc['senderId'],
      text: doc['text'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
      imageUrl: doc['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
    };
  }
}