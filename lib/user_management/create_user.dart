import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:project_management/utils/routes/routes_name.dart';
import 'package:project_management/utils/utils.dart';

import '../static_data/colors.dart';
import '../static_data/custom_appbar.dart';
import '../static_data/custom_drawer.dart';


class CreateUser extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const CreateUser({
    required this.drawerWidth,
    required this.selectedDestination,
    super.key
  });

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  final _horizontalScrollController = ScrollController();
  final _verticalScrollController = ScrollController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: Row(
        children: [
          CustomDrawer(widget.drawerWidth, widget.selectedDestination),
          const VerticalDivider(width: 1,thickness: 1),
          Expanded(
              child: Scaffold(
                backgroundColor: const Color(0xffF0F4F8),
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(88.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: AppBar(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      surfaceTintColor: Colors.white,
                      shadowColor: Colors.black,
                      title: const Text("Create User",style: TextStyle(color: Colors.black)),
                      centerTitle: true,
                      leading: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.keyboard_backspace_outlined, color: Colors.black),
                      ),
                      actions: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: MaterialButton(
                                height: 40,
                                color: Colors.blue,
                                onPressed: () async{
                                  Map newUser={
                                    "userName": nameController.text,
                                    "email":emailController.text,
                                    "phone" : phoneController.text,
                                    "initialPassword": "85E4s;~!<_L%",
                                    "active": true,
                                  };
                                  print('-- new user ----');
                                  print(newUser);
                                  await registerWithEmailAndPassword(newUser, context);
                                },
                                child: const Text("Save",style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                body: loading ? const Center(child: CircularProgressIndicator(),) :
                AdaptiveScrollbar(
                  underColor: Colors.blueGrey.withOpacity(0.3),
                  sliderDefaultColor: Colors.grey.withOpacity(0.7),
                  sliderActiveColor: Colors.grey,
                  controller: _verticalScrollController,
                  child: SingleChildScrollView(
                    controller: _verticalScrollController,
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
                              child: SingleChildScrollView(
                                controller: _horizontalScrollController,
                                scrollDirection: Axis.horizontal,
                                child: Card(
                                  color: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: BorderSide(
                                        color: mTextFieldBorder.withOpacity(0.8),
                                        width: 1
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 42,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 20,),
                                              child: Row(children: [Text("User Details",style: TextStyle(fontWeight: FontWeight.bold),),],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 1,
                                        width: 420,
                                        color: mTextFieldBorder,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(left: 60,top: 20,right: 60,bottom: 20),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("User Name",style: TextStyle(fontSize: 14)),
                                                    const SizedBox(height: 6,),
                                                    SizedBox(
                                                      height: 40,
                                                      width: 300,
                                                      child: TextFormField(
                                                        autofocus: true,
                                                        controller: nameController,
                                                        style: const TextStyle(fontSize: 12),
                                                        decoration: textFieldDecoration(hintText: 'Enter Name'),
                                                        onChanged: (value){
                                                          nameController.value=TextEditingValue(
                                                            text:capitalizeFirstWord(value),
                                                            selection: nameController.selection,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("Mobile Number",style: TextStyle(fontSize: 14)),
                                                    const SizedBox(height: 6,),
                                                    SizedBox(
                                                      height: 40,
                                                      width: 300,
                                                      child: TextFormField(
                                                        style: const TextStyle(fontSize: 12),
                                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                        keyboardType: TextInputType.number,
                                                        maxLength: 10,
                                                        controller: phoneController,
                                                        decoration: textFieldDecoration(hintText: 'Enter Mobile Number'),),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("Email",style: TextStyle(fontSize: 14)),
                                                    const SizedBox(height: 6,),
                                                    SizedBox(
                                                      height: 40,
                                                      width: 300,
                                                      child:  TextFormField(
                                                        style: const TextStyle(fontSize: 12),
                                                        inputFormatters: [LowerCaseTextFormatter()],
                                                        textCapitalization: TextCapitalization.characters,
                                                        textInputAction: TextInputAction.next,
                                                        controller: emailController,
                                                        decoration: textFieldDecoration(hintText: 'Enter Email'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12,),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  String capitalizeFirstWord(String value){
    if(value.isNotEmpty){
      var result =value[0].toUpperCase();
      for(int i=1;i<value.length;i++){
        if(value[i-1]=='1'){
          result=result+value[i].toUpperCase();
        }
        else{
          result=result+value[i];
        }
      }
      return result;
    }
    return "";
  }

  textFieldDecoration({required String hintText, bool? error}) {
    return  InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 12),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }

  Future registerWithEmailAndPassword(Map newUser, BuildContext context) async {
    loading = true;
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: newUser['email'],
        password: newUser['initialPassword'],
      );
      print('-- credential --');
      print(credential);

      await FirebaseAuth.instance.sendPasswordResetEmail(email: newUser['email']);

      await FirebaseFirestore.instance.collection("users").doc(credential.user!.uid).set({
        "userName": newUser['userName'],
        "email": newUser['email'],
        "initialPassword": newUser['initialPassword'],
        "userUid": credential.user!.uid,
        "phone": newUser['phone'],
      });
      if(mounted){
        Utils.snackBar("User Created", context);
      }
      loading = false;
      if(mounted){
        Navigator.pushNamed(context, RoutesName.home);
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('------ e code ------');
        print(e.code);
        loading = false;
        if (e.code == "email-already-in-use") {
          Utils.snackBar("Email is already in use", context);
        } else if (e.code == "weak-password") {
          Utils.snackBar("Password is too weak. Please choose a stronger password.", context);
        } else if (e.code == "invalid-email") {
          Utils.snackBar("Invalid email address", context);
        } else {
          Utils.snackBar("Error: ${e.message}", context);
        }
      } else {
        Utils.snackBar("An unexpected error occurred. Please try again later.", context);
      }
    }
  }


}

class LowerCaseTextFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.toLowerCase(),selection: newValue.selection);
  }
}
