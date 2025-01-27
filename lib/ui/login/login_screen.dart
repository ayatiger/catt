import 'dart:async';
import 'package:chat/constants/transitions.dart';
import 'package:chat/model/my_user.dart';
import 'package:chat/network/local/cache_helper.dart';
import 'package:chat/provider/user_provider.dart';
import 'package:chat/ui/login/login_navigator.dart';
import 'package:chat/ui/login/login_view_model.dart';
import 'package:chat/ui/register/register_screen.dart';
import 'package:chat/view/bottom_nav/bottom_nav_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat/utils.dart' as Utils;
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LoginNavigator {
  var formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  String type = '';
  LoginViewModel viewModel = LoginViewModel();
  TextEditingController emailController = TextEditingController(text: "admin@admin.com");
  TextEditingController passwordController = TextEditingController(text: "123456789");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Image.asset('assets/images/main_background.png', fit: BoxFit.fill, width: double.infinity),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              title: const Text(
                'Login',
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
            body: Form(
              key: formkey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      onChanged: (text) {
                        email = text;
                      },
                      //initialValue: "aya555@gmail.com",
                      validator: (text) {
                        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text!);
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter email';
                        }
                        if (!emailValid) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      onChanged: (text) {
                        password = text;
                      },
                      //initialValue: "123456789",
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter password';
                        }
                        if (text.length < 6) {
                          return 'Password must be at least 6 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          validateForm();
                        },
                        child: const Text('Login')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(RegisterScreen.routeName);
                        },
                        child: const Text('Create account')),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void validateForm() {
    //if (formkey.currentState?.validate() == true) {
    CacheHelper.saveData(key: 'email', value: emailController.text);
   CacheHelper.saveData(key: 'type', value: type);
    CacheHelper.saveData(key: 'name', value: name);
    // email = "admin@admin.com";
    // password = "123456789";

    viewModel.loginFirebaseAuth(emailController.text, passwordController.text);

    CacheHelper.saveData(key: 'isLogout', value: false);
    // }
  }

  @override
  void hideLoading() {
    // TODO: implement hideLoading
    Utils.hideLoading(context);
  }

  @override
  void showLoading() {
    // TODO: implement showLoading
    Utils.showLoading(context);
  }

  @override
  void showMessage(String message) {
    // TODO: implement showMessage
    Utils.showMessage(message, context, 'Ok', (context) {
      Navigator.pop(context);
    });
  }

  void navigateToHome(MyUser user) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.user = user;
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(CustomPageRoute(child: const AppLayout()));
    });
  }
}
