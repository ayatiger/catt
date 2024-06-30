import 'package:chat/database/database_utils.dart';
import 'package:chat/firebase_errors.dart';
import 'package:chat/ui/login/login_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  late LoginNavigator navigator;

  void loginFirebaseAuth(String email, String password) async {
    navigator.showLoading();
    try {
      // Attempt to sign in with the provided email and password
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve user data from your database
      var userObj = await DatabaseUtils.getUser(result.user?.uid ?? '');

      // Check if user data was successfully retrieved
      if (userObj == null) {
        // Hide loading indicator
        navigator.hideLoading();
        // Show error message
        navigator.showMessage('User data retrieval failed. Please try again.');
      } else {
        // Hide loading indicator
        navigator.hideLoading();
        // Show success message
        navigator.showMessage('Login Successfully');
        // Navigate to home screen with the user object
        navigator.navigateToHome(userObj);
      }
    } on FirebaseAuthException catch (e) {
      // Hide loading indicator
      navigator.hideLoading();

      // Handle specific FirebaseAuthException error codes
      if (e.code == FirebaseErrors.userNotFound) {
        navigator.showMessage('No user found for that email.');
      } else if (e.code == FirebaseErrors.wrongPassword) {
        navigator.showMessage('Wrong password provided for that user.');
      } else {
        // Handle other error codes or show a generic error message
        navigator.showMessage('An error occurred. Please try again.');
      }
    } catch (e) {
      // Hide loading indicator
      navigator.hideLoading();
      // Show a generic error message for any other exceptions
      navigator.showMessage('An unexpected error occurred. Please try again.');
    }
  }

}
