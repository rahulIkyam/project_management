import 'dart:developer';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading ? const Center(child: CircularProgressIndicator(),) : Center(
        child: SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login to your account",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20, color: Colors.blue)),
              const SizedBox(height: 20),
              const Text("Username",style: TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 10),
              SizedBox(height: 30,
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
              const Text("Password",style: TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 10),
              SizedBox(height: 30,
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
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     InkWell(
              //       onTap: () {
              //         Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const FirebaseResetPassword(),));
              //       },
              //       child: const Text(
              //         "Forgot Password ?",
              //         style: TextStyle(
              //           fontSize: 12,
              //           // decoration: TextDecoration.underline,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              Container(
                width: 300,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.blue,
                ),
                child: TextButton(
                    onPressed: () async {

                      // Navigator.pushNamed(context, RoutesName.userManagement);
                      // Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const AddProject2(),));
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
          ),
        ),
      ),
    );
  }

  decorationInput3(String hintString) {
    return  InputDecoration(

        label: Text(
          hintString,
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
}
