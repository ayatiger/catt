import 'dart:io';
import 'package:chat/model/my_user.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../bloc/cubit.dart';
import '../bloc/states.dart';
import '../constants/components.dart';
import '../constants/transitions.dart';
import '../network/local/cache_helper.dart';
import '../provider/user_provider.dart';
import '../ui/login/login_screen.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  File? image;

  File? myFile;
  MyUser?_user;
  void initState()
  {
    super.initState();
    loadImage();
  }
  String? imagePath;

  Future pickImage(ImageSource source, BuildContext context) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage == null) return;

      final savedImagePath = await saveImage(pickedImage.path);
      setState(() {
        image = File(savedImagePath);
        imagePath = savedImagePath;
        CacheHelper.saveData(key: 'image_path', value: savedImagePath);
      });
    } on PlatformException catch (e) {

    }
  }

  Future<String> saveImage(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final savedImagePath = '${directory.path}/$name';
    await File(imagePath).copy(savedImagePath);
    return savedImagePath;
  }
  void buildCameraDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Lottie.asset('assets/lotties/image.json'),
        backgroundColor: white,
        actions: [
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      pickImage(ImageSource.camera, context);
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Camera',
                    style: mainTextStyle(context),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      pickImage(ImageSource.gallery, context);
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Gallery',
                    style: mainTextStyle(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void loadImage() {
    final savedImagePath = CacheHelper.getData(key: 'image_path');
    if (savedImagePath != null) {
      setState(() {
        image = File(savedImagePath);
        imagePath = savedImagePath;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (image != null)
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.2),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: ClipOval(
                                            child: Image.file(
                                              image!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.2),
                                        child: Container(
                                          height: 120,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromRGBO(
                                                0, 0, 0, 0.2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 20),
                                Align(
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () {
                                      buildCameraDialog(context);
                                    },
                                    child: Text(
                                      'Change Photo',
                                      style: mainTextStyle(
                                        context,
                                        color: black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Provider.of<UserProvider>(context, listen: false).user!.userName.toString(),

                                  style: mainTextStyle(context),
                                ),
                                const Spacer(),
                                Text(
                                  Provider.of<UserProvider>(context, listen: false).user!.userType.toString(),

                                  // CacheHelper.getData(key: 'type') ?? 'doctor',
                                  style: mainTextStyle(context,
                                      color: defaultColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              CacheHelper.getData(key: 'email') ??
                                  'aya@gmail.com',
                              style: mainTextStyle(context),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    //CacheHelper.getData(key: 'disease') == "patient"? const SizedBox(height: 30):Text(''),
                    Provider.of<UserProvider>(context, listen: false).user!.userType.toString()=='Doctor' ?
                    Text(
                      '',
                      style: mainTextStyle(context),
                    ):
                    Text(
                      CacheHelper.getData(key: 'disease') ??
                          '',
                      style: mainTextStyle(context),
                    ),
                    const SizedBox(height: 30),
                    // Text(CacheHelper.getData(key: 'type')),
                    // CacheHelper.getData(key: 'type')=='patient'?TFF(
                    //   action: TextInputAction.send,
                    //   type: TextInputType.text,
                    //   isPrefix: false,
                    //   underlineBorder: false,
                    //   label: "Disease",
                    //   hint: "enter your disease",
                    // ):const SizedBox.shrink(),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          CustomPageRoute(
                            child: LoginScreen(),
                          ),
                        );CacheHelper.saveData(key:'isLogout',value:true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: defaultColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(
                          double.infinity,
                          screenHeight(context, .053),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}