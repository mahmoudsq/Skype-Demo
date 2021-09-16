import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skypeclone/models/message.dart';
import 'package:skypeclone/models/userModel.dart';
import 'package:skypeclone/provider/image_upload_provider.dart';
import 'package:skypeclone/resources/firebase_methods.dart';

class FirebaseRepository{

  FirebaseMethods _firebaseMethods = FirebaseMethods();
  Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();
  Future<User> signIn() => _firebaseMethods.signIn();
  Future<UserModel> getUserDetails() => _firebaseMethods.getUserDetails();
  Future<bool> authenticateUser(User user) => _firebaseMethods.authenticateUser(user);
  Future<void> addDataToDb(User user) => _firebaseMethods.addDataToDb(user);
  Future<void> signOut() => _firebaseMethods.signOut();
  Future<List<UserModel>> fetchAllUsers(User currentUser) => _firebaseMethods.fetchAllUsers(currentUser);
  Future<void> addMessageToDb(Message message,UserModel sender,UserModel receiver) =>
      _firebaseMethods.addMessageToDb(message,sender,receiver);
  void uploadImage ({@required File image,@required String receiverId,@required String senderId,
  @required ImageUploadProvider imageUploadProvider}) =>
      _firebaseMethods.uploadImage(image,receiverId,senderId,imageUploadProvider);
}