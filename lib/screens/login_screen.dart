import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skypeclone/resources/firebase_repository.dart';
import 'package:skypeclone/screens/home_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skypeclone/utils/universal_variables.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Stack(
        children: [
          Center(child: loginButton(context)),
          isLoginPressed ? Center(child: CircularProgressIndicator(),)
              : Container()
        ],
      ),
    );
  }

  Widget loginButton(BuildContext context){
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
      child: FlatButton(
        padding: EdgeInsets.all(35),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,letterSpacing: 1),
        ),
        onPressed: () => performLogin(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
      ),
    );
  }

  void performLogin(BuildContext context){
    setState(() {
      isLoginPressed = true;
    });
    _repository.signIn().then((value) => {
      if(value != null)
        authenticationUser(value,context)
      else
        print('error')
    });
  }

  void authenticationUser(User user,BuildContext context){
    _repository.authenticateUser(user).then((value){
      setState(() {
        isLoginPressed = false;
      });
      if(value){
        _repository.addDataToDb(user).then((value){
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
        });
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
      }
    });
  }
}
