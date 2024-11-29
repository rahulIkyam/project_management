import 'package:flutter/material.dart';

import '../utils/routes/routes_name.dart';
import 'colors.dart';
import 'custom_popup_dropdown.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {

  Color logYesTextColor = Colors.black;
  Color logNoTextColor = Colors.black;
  String logoutInitial="";
  List <CustomPopupMenuEntry<String>> logout =<CustomPopupMenuEntry<String>>[

    const CustomPopupMenuItem(height: 40,
      value: 'Logout',
      child: Center(child: Text('Logout',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14))),

    ),

  ];

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: 170,
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      centerTitle: true,
      elevation: 2,
      bottomOpacity: 20,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CustomPopupMenuButton(
            decoration: logoutDecoration(hintText:logoutInitial,),
            elevation: 4,
            hintText: '',
            tooltip: "",
            childWidth: 150,
            icon: const Icon(Icons.account_circle,color: Colors.black),
            offset: const Offset(1, 40),
            itemBuilder: (context) {
              return logout;
            },
            shape:  const RoundedRectangleBorder(
              side: BorderSide(color: mTextFieldBorder),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            onSelected: (String value) async{
              setState(() {
                logoutInitial = value;
                if(logoutInitial=="Logout"){
                  confirmLogout();
                }
              });

            },
          ),
        )
      ],
    );
  }

  void confirmLogout() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: 200,
                width: 300,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      margin:const EdgeInsets.only(top: 13.0,right: 8.0),
                      child:  Padding(
                        padding: const EdgeInsets.only(left: 20, right: 25),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Icon(
                              Icons.warning_rounded,
                              color: Colors.orange,
                              size: 50,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Center(
                              child: Text(
                                "Are You Sure",
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blue,
                                          style: BorderStyle.solid
                                      ),
                                      borderRadius: BorderRadius.circular(4)
                                  ),
                                  child: MouseRegion(
                                    onHover: (event) {
                                      setState((){
                                        logYesTextColor = Colors.white;
                                      });
                                    },
                                    onExit: (event) {
                                      setState((){
                                        logYesTextColor = Colors.black;
                                      });
                                    },
                                    child: MaterialButton(
                                        hoverColor: Colors.lightBlueAccent,
                                        onPressed: () async{
                                          print("+++++LogOut");
                                          Navigator.pushNamed(context, RoutesName.login);
                                          // Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),));
                                        }, child:  Text("Yes",style: TextStyle(color: logYesTextColor),)),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.red,
                                          style: BorderStyle.solid
                                      ),
                                      borderRadius: BorderRadius.circular(4)
                                  ),
                                  child: MouseRegion(
                                    onHover: (event) {
                                      setState((){
                                        logNoTextColor = Colors.white;
                                      });
                                    },
                                    onExit: (event) {
                                      setState((){
                                        logNoTextColor = Colors.black;
                                      });
                                    },
                                    child: MaterialButton(
                                        hoverColor: Colors.redAccent,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }, child:  Text("No",style: TextStyle(color: logNoTextColor),)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: InkWell(
                        child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: const Color.fromRGBO(204, 204, 204, 1),
                                ),
                                color: Colors.blue
                            ),
                            child: const Icon(
                              Icons.close_sharp,
                              color: Colors.white,
                            )
                        ),
                        onTap: () {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },),
        );
      },);
  }
  logoutDecoration({required String hintText, bool? error, bool ? isFocused,}) {
    return InputDecoration(
      hoverColor: mHoverColor,
      suffixIcon: const Icon(Icons.account_circle, color:Colors.black),
      // border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      border: InputBorder.none,
      constraints: const BoxConstraints(maxHeight: 35),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xB2000000)),
      counterText: '',
      contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
    );
  }
}
