import 'package:blogspot/Core/auth.dart';
import 'package:blogspot/Core/database.dart';
import 'package:flutter/widgets.dart';

import '../Models/userModel.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel();
  final Auth _authMethods = Auth();

  UserModel get getUser => _user;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
