// import 'package:chat/chat/chat_navigator.dart';
// import 'package:chat/database/database_utils.dart';
// import 'package:chat/model/message.dart';
// import 'package:chat/model/my_user.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../model/room.dart';
//
// class ChatScreenViewModel extends ChangeNotifier {
//   late ChatNavigator navigator;
//
//   late MyUser currentUser;
//
//   late Room room;
//
//   late Stream<QuerySnapshot<Message>> streamMessage;
//
//
//   Stream<List<Message>> getMessages(String roomId) {
//     return FirebaseFirestore.instance
//         .collection('messages')
//         .where('roomId', isEqualTo: roomId)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//         .map((doc) => Message.fromMap(doc.data()))
//         .toList());
//   }
//
//
//   //   return FirebaseFirestore.instance
//   //       .collection(Room.collectionName)
//   //       .doc(roomId)
//   //       .collection(Message.collectionName)
//   //       .withConverter<Message>(
//   //           fromFirestore: ((snapshot, options) =>
//   //               Message.fromJson(snapshot.data()!)),
//   //           toFirestore: (message, options) => message.toJson());
//
//
//   void listenForUpdateMessages() {
//     streamMessage = DatabaseUtils.getMessagesFromFireStore(room.roomId);
//   }
//
//
//   // Future<void> sendMessage(String content) async {
//   // await FirebaseFirestore.instance.collection('messages').add({
//   // 'text': content,
//   // 'roomId': room.roomId,
//   // 'userId': currentUser.id,
//   // 'createdAt': DateTime.now(),
//   // });
//   // }
//   //
// void sendMessage(String content) async {
//   Message message = Message(
//       userId: currentUser.id,
//       text: content,
//       createdAt:DateTime.now(),
//     senderId: '',
//     timestamp: null,
//
//   );
//   try {
//     var res = await DatabaseUtils.insertMessage(message);
//     // clear message
//     navigator.clearMessage();
//   } catch (error) {
//     navigator.showMessage(error.toString());
//   }
// }
//
//
// }
