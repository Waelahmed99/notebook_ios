import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/models/enums.dart';
import 'package:notebook_provider/models/user.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;
  User user;

  // Get the private loading state.
  bool get isLoading => _isLoading;

  // Authenticate user with email and password
  /// [mode]: For determining whether the state is [Login] or [Signup]
  Future<String> authenticate(String email, String password,
      Authentication mode, BuildContext context) async {
    AuthResult result;
    _loadingState(true);
    if (mode == Authentication.Login) {
      try {
        result = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } catch (e) {
        _loadingState(false);
        return _parseError(e.code);
      }
    } else {
      try {
        result = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
      } catch (e) {
        _loadingState(false);
        return _parseError(e.code);
      }
    }

    // User authenticated successfully
    FirebaseUser firebaseUser = result.user;
    // Save user locally and in SharedPreferences.
    user = User(userId: firebaseUser.uid, userEmail: firebaseUser.email);
    _saveUser();
    // Provide the userId to the Firebase Provider.
    Provider.of<FirebaseModel>(context, listen: false).userId =
        firebaseUser.uid;
    _loadingState(false);
    return Values.OPERATION_SUCCESS;
  }

  // Save user's id and email in SharedPreferences.
  void _saveUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Values.USER_ID, user.userId);
    pref.setString(Values.USER_EMAIL, user.userEmail);
  }

  // Remove user's id and email from SharedPreferences.
  void _removeUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(Values.USER_EMAIL);
    pref.remove(Values.USER_ID);
  }

  // Check if the user is already signed in.
  Future<bool> isAuthenticated() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString(Values.USER_ID);
    String userEmail = pref.getString(Values.USER_EMAIL);
    // Save user locally if already signed in.
    if (userId != null) {
      user = User(userId: userId, userEmail: userEmail);
      return true;
    }
    return false;
  }

  // Sign user out.
  void signOut() async {
    _loadingState(true);
    await _firebaseAuth.signOut();
    _removeUser();
    _loadingState(false);
  }

  // Change the loading state.
  void _loadingState(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  // Decode firebase's error messages.
  String _parseError(String error) {
    switch (error) {
      case "ERROR_INVALID_EMAIL":
        return Values.AUTH_INVALID_EMAIL;
      case "ERROR_WRONG_PASSWORD":
        return Values.AUTH_WRONG_PASSWORD;
      case "ERROR_USER_NOT_FOUND":
        return Values.AUTH_USER_NOT_FOUND;
      case "ERROR_USER_DISABLED":
        return Values.AUTH_USER_DISABLED;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        return Values.AUTH_EMAIL_ALREADY_IN_USE;
      case "ERROR_TOO_MANY_REQUESTS":
        return Values.AUTH_TOO_MANY_REQUESTS;
      case "ERROR_OPERATION_NOT_ALLOWED":
        return Values.AUTH_OPERATION_NOT_ALLOWED;
      default:
        return Values.AUTH_UNEXPECTED_ERROR;
    }
  }
}
