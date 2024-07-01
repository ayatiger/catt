import 'package:chat/chat/chat_screen.dart';
import 'package:chat/chat/chat_service.dart';
import 'package:chat/model/my_user.dart';
import 'package:flutter/material.dart';

class RoomScreen extends StatefulWidget {
  // final String chatId;
  // final String recipientId;
  //required this.recipientId
  final MyUser doctor;
  static const String routeName = 'room_screen';

  //const RoomScreen({super.key});
  RoomScreen({required this.doctor});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(widget.doctor.imageUrl.toString()),
            Text(
              "Full Name",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(widget.doctor.firstName.toString()),
                Text(widget.doctor.lastName.toString()),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "address",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.doctor.address.toString()),
            SizedBox(
              height: 10,
            ),
            Text(
              "rate",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.doctor.rate.toString()),
            SizedBox(
              height: 10,
            ),
            Text(
              "email",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.doctor.email.toString()),
            SizedBox(
              height: 10,
            ),
            Text(
              "specialization",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.doctor.specialization.toString()),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final ChatService _chatService = ChatService();

                      String chatId = await _chatService.getOrCreateChat(widget.doctor.id);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatId: chatId,
                            recipientId: widget.doctor.id,
                          ),
                        ),
                      );
                    },
                    child: Text("chat"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
