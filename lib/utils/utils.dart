import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../static_data/colors.dart';

class Utils{


  static snackBar(String message, BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  static void fieldFocusChange(
      BuildContext context,
      FocusNode current,
      FocusNode nextFocus,
      ){
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static customerFieldDecoration( {required TextEditingController controller, required String hintText, bool? error}) {
    return  InputDecoration(
      constraints: BoxConstraints(maxHeight: error==true ? 50:30),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 11),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }

  static dateDecoration({required String hintText}) {
    return InputDecoration(
      constraints: const BoxConstraints(maxHeight: 30),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1.0), // Adjusted thickness
      ),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 11),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 8, 10, 10),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: mTextFieldBorder, width: 1.0), // Adjusted thickness
      ),
      errorBorder:  const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffC62828), width: 1.0), // Adjusted thickness
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color:  Color(0xffC62828), width: 1.0), // Adjusted thickness
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1.0), // Adjusted thickness
      ),
    );
  }

  static textFieldDecoration({required String hintText}) {
    return  InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color:  Colors.blue)),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 11),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 8, 10, 10),
      enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    );
  }

}