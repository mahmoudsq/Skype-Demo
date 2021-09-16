

import 'package:flutter/widgets.dart';
import 'package:skypeclone/models/userModel.dart';
import 'package:skypeclone/resources/firebase_repository.dart';

class UserProvider with ChangeNotifier{
  UserModel _userModel;
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  UserModel get getUser => _userModel;

  void refreshUser() async{
    UserModel userModel = await _firebaseRepository.getUserDetails();
    _userModel = userModel;
    notifyListeners();
  }
}