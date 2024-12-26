import 'dart:developer';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../static_data/colors.dart';
import '../utils/routes/routes_name.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late double screenWidth;
  late double screenHeight;
  final userName = TextEditingController();
  final password = TextEditingController();
  final forgotEmail = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  bool showHidePassword=true;
  bool passWordColor = false;
  bool isLoading = false;
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  final _verticalScrollController1 = ScrollController();
  String userUid = "";
  void passwordHideAndViewFunc(){
    setState(() {
      showHidePassword = !showHidePassword;
    });
  }
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  Future firebaseGetUserUid(String userId)async{
    DocumentSnapshot ds = await fireStore.collection("users").doc(userId).get();
    userUid = ds['userUid'];
    return userUid;
  }

  Future<void> checkCredentials() async{
    try{
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final credential = await _auth.signInWithEmailAndPassword(
          email: userName.text,
          password: password.text
      );
      String userId = credential.user!.uid;
      String userUid = await firebaseGetUserUid(userId);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userUid", userUid);
      await prefs.setBool("isLoggedIn", true);
      await prefs.setString("loginTimestamp", DateTime.now().toIso8601String());
      if(credential.user != null){
        FirebaseFirestore.instance.collection("users").doc(credential.user?.uid);
      }
      if(mounted){
        Navigator.pushNamed(context, RoutesName.home);
      }

    }on FirebaseAuthException catch(e){
      setState(() {
        isLoading = false;
      });
      print('------- error -------');
      print(e.message);
      String errorMessage = "An error occurred. Please try again";
      switch (e.code) {
        case "user-not-found":
          errorMessage = "No user found for that email. Please enter a valid email.";
          break;
        case "wrong-password":
          errorMessage = "Wrong password. Try again or reset your password.";
          break;
        case "invalid-credential":
          errorMessage = "Invalid credentials provided. Please check your email and password.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        case 'user-disabled':
          errorMessage = "This user account has been disabled.";
          break;
        default:
          errorMessage = "Authentication failed. Please try again.";
      }
      showErrorDialog(errorMessage);
    }
  }

  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(Icons.error,color: Colors.red,),
              Text(errorMessage,style: const TextStyle(fontSize: 14),),
              const SizedBox(height: 10,),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      },);
  }

  Future<void> _handleLogin() async{
    final username = userName.text.trim();
    final pass = password.text.trim();
    if(username.isNotEmpty && pass.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      checkCredentials();
    }else{
      log("User Name and Password is required");
    }
  }
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    print('----- screen width -----');
    print(screenWidth);
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading ? const Center(child: CircularProgressIndicator(),) : AdaptiveScrollbar(
        underColor: Colors.blueGrey.withOpacity(0.3),
        sliderDefaultColor: Colors.grey.withOpacity(0.7),
        sliderActiveColor: Colors.grey,
        controller: _verticalScrollController,
        child: SingleChildScrollView(
          controller: _verticalScrollController,
          scrollDirection: Axis.vertical,
          child: Center(
            child: SizedBox(
              // width: screenWidth,
              child: screenWidth < 950 ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight*0.2,),
                  SizedBox(
                    width: screenWidth*0.5,
                    child: Image.asset("assets/images/task_image.jpg"),
                  ),
                  SizedBox(height: screenHeight*0.1,),
                  loginFields()

                ],
              ) :
              Column(
                children: [
                  SizedBox(height: screenHeight*0.2,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth*0.4,
                        child: Image.asset("assets/images/task_image.jpg"),
                      ),
                      SizedBox(width: screenWidth*0.1,),
                      loginFields()

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  decorationInput3(String hintString) {
    return  InputDecoration(

        label: Text(
          hintString,
          style: const TextStyle(color: imageColor1),
        ),
        counterText: '',labelStyle: const TextStyle(fontSize: 12),
        contentPadding:  const EdgeInsets.fromLTRB(12, 00, 0, 0),
        hintText: hintString,
        suffixIconColor: const Color(0xfff26442),
        disabledBorder:  const OutlineInputBorder(borderSide:  BorderSide(color:  Colors.white)),
        enabledBorder:const OutlineInputBorder(borderSide:  BorderSide(color: mTextFieldBorder)),
        focusedBorder:  const OutlineInputBorder(borderSide:  BorderSide(color:Color(0xff00004d))),
        border:   const OutlineInputBorder(borderSide:  BorderSide(color:Color(0xff00004d)))
    );
  }

  decorationInputPassword(String hintString, bool val, bool passWordHind,  passwordHideAndView, ) {
    return InputDecoration(
        label: Text(
          hintString,
          style: const TextStyle(color: imageColor1),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            passWordHind ? Icons.visibility : Icons.visibility_off,size: 20,
          ),
          onPressed: passwordHideAndView,
        ),suffixIconColor: val?const Color(0xff00004d):Colors.grey,
        // suffixIconColor:val?  const Color(0xff00004d):Colors.grey,
        counterText: "",
        contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
        hintText: hintString,labelStyle: const TextStyle(fontSize: 12,),

        disabledBorder:  const OutlineInputBorder(borderSide:  BorderSide(color:  Colors.white)),
        enabledBorder:const OutlineInputBorder(borderSide:  BorderSide(color: mTextFieldBorder)),
        focusedBorder:  const OutlineInputBorder(borderSide:  BorderSide(color: Color(0xff00004d))),
        border:   const OutlineInputBorder(borderSide:  BorderSide(color: Color(0xff00004d)))

    );
  }

  Widget loginFields(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Login to your account",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: imageColor)),
        const SizedBox(height: 20),
        const Text("Username",style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),),
        const SizedBox(height: 10),
        SizedBox(
          height: 30,
          width: 300,
          child: TextField(
            onChanged: (value) {},
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
            controller: userName,
            style: const TextStyle(fontSize: 12),
            decoration: decorationInput3("Enter user Email"),
          ),
        ),
        const SizedBox(height: 20),
        const Text("Password",style: TextStyle(fontWeight: FontWeight.bold, color: imageColor1),),
        const SizedBox(height: 10),
        SizedBox(
          height: 30,
          width: 300,
          child: TextField(
            obscureText: showHidePassword,
            enableSuggestions: false,
            autocorrect: false,
            controller: password,
            onEditingComplete: () {
              _handleLogin();
            },
            onChanged: (value){},
            style: const TextStyle(fontSize: 12),
            decoration: decorationInputPassword("Enter user Password",passWordColor, showHidePassword,passwordHideAndViewFunc),
            onSubmitted: (v)  async {},
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 300,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: imageColor,
          ),
          child: TextButton(
              onPressed: () async {
                if(userName.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter User Name")));
                }else if(password.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter Password")));
                }else{
                  _handleLogin();

                }
              }, child: const Text("Login",style:  TextStyle(color: Colors.white,),)),
        ),
      ],
    );
  }
}
