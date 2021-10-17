import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager with ChangeNotifier {
  bool _isLoggedIn = false;
  String _emailFormatted;

  AuthManager(bool isLoggedIn) {
    _isLoggedIn = isLoggedIn;
  }

  bool get isLoggedIn => _isLoggedIn;

  String get emailFormatted => _emailFormatted;

  set emailFormatted(String emailFormatted) {
    setEmail(emailFormatted);
    _emailFormatted = emailFormatted;
    debugPrint("here +" + _emailFormatted);
    notifyListeners();
  }

  setEmail(String emailFormatted) async {
    var preference = await SharedPreferences.getInstance();
    preference.setString("emailFormatted", emailFormatted);
  }

  loggedInTrue() async {
    _isLoggedIn = true;
    var preference = await SharedPreferences.getInstance();
    debugPrint("login " + _isLoggedIn.toString());
    preference.setBool("isLoggedIn", _isLoggedIn);
  }

  loggedInFalse() async {
    _isLoggedIn = false;
    var preference = await SharedPreferences.getInstance();
    debugPrint("login " + _isLoggedIn.toString());
    preference.setBool("isLoggedIn", _isLoggedIn);
  }
}
