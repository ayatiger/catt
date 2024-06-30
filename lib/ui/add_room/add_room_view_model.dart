import 'package:chat/database/database_utils.dart';
import 'package:chat/model/room.dart';
import 'package:chat/ui/add_room/add_room_navigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AddRoomViewModel extends ChangeNotifier {
  late AddRoomNavigator navigator;

  void addRoom(
      String roomTitle, String roomDescription, String categoryId) async {
    Room room = Room(
        roomId: "",
        title: roomTitle,
        description: roomDescription,
        categoryId: categoryId);
    try {
      navigator.showLoading();
      var createdRoom = await DatabaseUtils.addRoomToFirestore(room);
      navigator.hideLoading();
      navigator.showMessage("Room was added successfully");
      navigator.navigateToHome();
    }catch(e){
       navigator.hideLoading();
       navigator.showMessage(e.toString());
    }
  }
// Inside AddRoomViewModel class
  Future<void> createChatRoom(String userId, String doctorId) async {
    // Create a new chat room document in Firestore
    await FirebaseFirestore.instance.collection('chatRooms').add({
      'userIds': [userId, doctorId],
      'createdAt': DateTime.now(),
    });
  }

}
