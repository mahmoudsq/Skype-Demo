import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skypeclone/constants/strings.dart';
import 'package:skypeclone/models/message.dart';
import 'package:skypeclone/models/userModel.dart';
import 'package:skypeclone/provider/image_upload_provider.dart';
import 'package:skypeclone/utils/utilities.dart';

class FirebaseMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollection = firestore.collection(USERS_COLLECTION);
  Reference _reference;
  UserModel userModel = UserModel();
  Future<User> getCurrentUser() async{
    User currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<UserModel> getUserDetails() async{
    User currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot = await _userCollection.doc(currentUser.uid).get();
    return UserModel.fromMap(documentSnapshot.data());
  }

  Future<User> signIn() async{
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication = await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken
    );
    UserCredential user = await _auth.signInWithCredential(credential);
    return user.user;
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore.collection(USERS_COLLECTION).where(
        EMAIL_FIELD, isEqualTo: user.email).get();
    final List<DocumentSnapshot> docs = result.docs;
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(User currentUser) async{
    String username = Utils.getUsername(currentUser.email);
    userModel = UserModel(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoURL,
      username: username
    );
    firestore.collection(USERS_COLLECTION).doc(currentUser.uid).set(userModel.toMap(userModel));
  }

  Future<void> signOut() async{
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<UserModel>> fetchAllUsers(User currentUser)async{
    List<UserModel> userList = List<UserModel>();
    QuerySnapshot querySnapshot = await firestore.collection(USERS_COLLECTION).get();
    for(var i = 0; i < querySnapshot.docs.length; i++){
      if(querySnapshot.docs[i].id != currentUser.uid){
        userList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(Message message,UserModel sender,UserModel receiver) async{
    var map = message.toMap();
    await firestore.collection(MESSAGES_COLLECTION).doc(message.senderId)
        .collection(message.receiverId).add(map);
    return await firestore.collection(MESSAGES_COLLECTION).doc(message.receiverId)
        .collection(message.senderId).add(map);
  }

  Future<String> uploadImageToStorage(File image) async{
    try{
      _reference = FirebaseStorage.instance.ref().child('${DateTime.now().microsecondsSinceEpoch}');
      UploadTask _uploadTask =  _reference.putFile(image);
      var url = await _reference.getDownloadURL();
      return url;
    }catch(e){
      print(e);
      return null;
    }
  }

  void setImgaeMsg(String url,String receiverId, String senderId) async{
    Message _message = Message.imageMessage(
      message: "Image",
      receiverId: receiverId,
      senderId: senderId,
      timestamp: Timestamp.now(),
      photoUrl: url,
      type: "image"
    );
    var map = _message.toImageMap();
    await firestore.collection(MESSAGES_COLLECTION).doc(_message.senderId)
        .collection(_message.receiverId).add(map);
    await firestore.collection(MESSAGES_COLLECTION).doc(_message.receiverId)
        .collection(_message.senderId).add(map);
  }

  void uploadImage(File image, String receiverId, String senderId,
      ImageUploadProvider imageUploadProvider)async{
    imageUploadProvider.setToLoading();
    String url = await uploadImageToStorage(image);
    imageUploadProvider.setToIdle();
    setImgaeMsg(url,receiverId,senderId);
  }
}