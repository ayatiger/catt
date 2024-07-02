import 'dart:async';
import 'dart:developer';
import 'package:chat/constants/components.dart';
import 'package:chat/constants/transitions.dart';
import 'package:chat/ui/home/review_screen.dart';
import 'package:chat/ui/login/login_view_model.dart';
import 'package:chat/ui/room_screen/room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../chat/chat_screen.dart';
import '../../chat/chat_service.dart';
import '../../chat/doctor_chat_list_screen.dart';
import '../../constants/colors.dart';
import '../../model/my_user.dart';
import '../../provider/user_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedIndex; // To track the currently selected tab
  MyUser? _user;
  bool _isOnline = true;
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _fetchUser();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isOnline = result != ConnectivityResult.none;
      });

      if (_isOnline && _selectedIndex == null) {
        _fetchUser();
      }
    });
  }

  void _fetchUser() {
    if (_retryTimer != null) {
      _retryTimer!.cancel();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        _user = Provider.of<UserProvider>(context, listen: false).user;
        if (_user != null) {
          log(_user!.userName.toString());
          log(_user!.userType.toString());
          setState(() {
            _selectedIndex = _user!.userType.toString() == 'Doctor' ? 1 : 0;
          });
        } else {
          _retryFetchUser();
        }
      } catch (e) {
        _retryFetchUser();
      }
    });
  }

  void _retryFetchUser() {
    _retryTimer = Timer(Duration(seconds: 10), () {
      if (_selectedIndex == null) {
        _fetchUser();
      }
    });
  }

  @override
  void dispose() {
    if (_retryTimer != null) {
      _retryTimer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('HP App'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isOnline) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('HP App'),
        ),
        body: Center(
          child: Text('You are offline. Please check your internet connection.'),
        ),
      );
    }

    return Scaffold(body: (userObj!.userType.toString() == "Doctor") ? DoctorChatListScreen() : HomeScreenContent()

        // (userObj!.userType.toString() == "Doctor") ?  :,
        );
  }
}

class HomeScreenContent extends StatefulWidget {
  HomeScreenContent({Key? key}) : super(key: key);

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Map<String,Map<String,dynamic>> doctorsMap={
  //   'Hanafy':{
  //     'name': 'Dr. Mahmood Hanafy',
  //     'rate': 4.5,
  //     'address': '123 Main St, City',
  //     'imageUrl': 'assets/images/hanafy.jpg',
  //     'specialization': 'Audiologist',},
  //   'Ahmed':{
  //     'name': 'Dr. Hadeer Ahmed',
  //     'rate': 4.8,
  //     'address': '456 Elm St, Town',
  //     'imageUrl': 'assets/images/hadeer.jpg',
  //     'specialization': 'Allergist',
  //   },
  //   'Mandor':{
  //     'name': 'Dr. Mohamed Mandor',
  //     'rate': 4.3,
  //     'address': '789 Oak St, Village',
  //     'imageUrl': 'assets/images/mondor.jpg',
  //     'specialization': 'Andrologist',
  //   },
  //   'Said':{
  //     'name': 'Dr. Mohamed Said',
  //     'rate': 4.7,
  //     'address': '101 Pine St, Town',
  //     'imageUrl': 'assets/images/mohamed said.jpg',
  //     'specialization': 'Anesthesiologist',
  //   },
  //   'Tantawy':{
  //     'name': 'Dr. Eman Tantawy',
  //     'rate': 4.6,
  //     'address': '234 Cedar St, City',
  //     'imageUrl': 'assets/images/eman.jpg',
  //     'specialization': 'Cardiologist',
  //   },
  //   'Hussein':{
  //     'name': 'Dr. Mohamed Hussein',
  //     'rate': 4.9,
  //     'address': '567 Maple St, Village',
  //     'imageUrl': 'assets/images/hussien.jpg',
  //     'specialization': 'Neurologist',
  //   },
  //   'Lotfy':{
  //     'name': 'Dr. Ahmed Lotfy',
  //     'rate': 4.4,
  //     'address': '890 Birch St, City',
  //     'imageUrl': 'assets/images/lotfy.jpg',
  //     'specialization': 'Dentist',
  //   },
  //   'Fawzy':{
  //     'name': 'Dr. Ahmed Fawzy',
  //     'rate': 4.2,
  //     'address': '432 Oak St, Town',
  //     'imageUrl': 'assets/images/ahmed fawzy.jpg',
  //     'specialization': 'Dermatologist',
  //   },
  // };

  Stream<List<MyUser>> _getDoctors() {
    return _firestore
        .collection('users')
        .where('userType', isEqualTo: 'Doctor')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MyUser.fromDocument(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Doctor List")),
      body: StreamBuilder<List<MyUser>>(
        stream: _getDoctors(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final doctors = snapshot.data!;
          // for (var entry in doctors) {
          //  log("name:"+entry.lastName.toString());
          //  // log("entry"+entry.toString());
          // }
          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];

              return DoctorCard(
                address: doctor.address.toString(),
                imageUrl: doctor.imageUrl.toString(),
                name: "${doctor.firstName.toString()} ${doctor.lastName.toString()} ",
                rate: double.parse(doctor.rate.toString()),
                total_rate: double.parse(doctor.countRate.toString()),
                specialization: doctor.specialization.toString(),
                // doctor.specialization.toString(),
                docId: doctor.id,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomScreen(
                        doctor: doctor,
                      ),
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

class DoctorCard extends StatefulWidget {
  // final Doctor doctor;
  final String name;
  double rate;
  final double total_rate;
  final String address;
  final String imageUrl;
  final String specialization;
  final String docId;
  void Function()? onTap;
  DoctorCard({
    super.key,
    required this.name,
    required this.rate,
    required this.total_rate,
    required this.address,
    required this.imageUrl,
    required this.specialization,
    required this.docId,
    required this.onTap,
  });

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  final ChatService _chatService = ChatService();
  @override
  Widget build(BuildContext context) {
    // double rate = double.parse(widget.docId);
    // double total_rate = widget.total_rate * 5;
    // double avareg_rate = (rate / total_rate) * 5;

    if (widget.rate != 0) {
      double avareg_rate = ((widget.rate) / (widget.total_rate * 5)) * 5;
      widget.rate = avareg_rate;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: widget.onTap,

          //  () async {
          //   String chatId = await _chatService.getOrCreateChat(widget.docId);

          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => RoomScreen(
          //         chatId: chatId,
          //         recipientId: widget.docId,
          //       ),
          //     ),
          //   );

          //   // Navigator.push(
          //   //   context,
          //   //   MaterialPageRoute(
          //   //     builder: (context) => ChatScreen(
          //   //       chatId: chatId,
          //   //       recipientId: widget.docId,
          //   //     ),
          //   //   ),
          //   // );
          // },
          child: ListTile(
            leading: ClipOval(
                child: Image(
              height: 60,
              width: 60,
              fit: BoxFit.fill,
              image: AssetImage(
                widget.imageUrl,
              ),
            )),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.name,
                    style: mainTextStyle(context),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CustomPageRoute(
                          child: ReviewScreen(
                            docId: widget.docId.toString(),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'Rate',
                          style: mainTextStyle(context, color: defaultColor),
                        ),
                        const Icon(
                          Icons.star_border_purple500_outlined,
                          color: Colors.deepOrangeAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rate: ${widget.rate.toStringAsFixed(1)}',
                  style: midTextStyle(context, grey),
                ),
                // Text(
                //   'Rate: ${widget.total_rate.toStringAsFixed(1)}',
                //   style: midTextStyle(context, grey),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Address: ${widget.address}',
                    style: midTextStyle(context, grey),
                  ),
                ),
                Text(
                  'Specialization: ${widget.specialization}',
                  style: midTextStyle(context, grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
