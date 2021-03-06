
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:skypeclone/models/call.dart';
import 'package:skypeclone/models/userModel.dart';
import 'package:skypeclone/resources/call_methods.dart';
import 'package:skypeclone/screens/callscreens/call_screen.dart';

class CallUtils{
  static final CallMethods callMethods = CallMethods();

  static dial({UserModel from,UserModel to,context}) async{
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if(callMade){
      Navigator.push(context, MaterialPageRoute(builder: (context) => CallScreen(call: call),));
    }
  }
}