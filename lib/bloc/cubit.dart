import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../chat/chat_screen.dart';
import '../chat/doctor_chat_list_screen.dart';
import '../provider/user_provider.dart';
import '../ui/home/home_screen.dart';
import '../widgets/call_widget.dart';
import '../widgets/profile_widget.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AuthInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  // int currentIndex2 = 0;
  dynamic currentValue;

  List<BottomNavigationBarItem> getTabs(BuildContext context) {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_filled),
        label: 'home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.phone,
        ),
        label: 'call',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline_outlined),
        label: 'profile',
      ),
    ];
  }

  List<Widget> screens = [
    const HomeScreen(),
    const CallWidget(),
    const ProfileWidget(),
    // const DoctorChatListScreen(),

  ];

  void changeBot(index, context) {
    // var userProvider = Provider.of<UserProvider>(context, listen: false).user;
    // log("userProvider"+userProvider!.userType.toString());
    // if(index==0&&userProvider.userType.toString()=='Doctor'){
    //   Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorChatListScreen()));
    // }
    currentIndex = index;
    emit(ChangeBotNavState());
  }
}
