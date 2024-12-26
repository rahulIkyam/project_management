import 'package:flutter/material.dart';

import '../utils/routes/routes_name.dart';
import 'colors.dart';

class CustomDrawer extends StatefulWidget {
  final double drawerWidth;
  final double selectedDestination;
  const CustomDrawer(
      this.drawerWidth,
      this.selectedDestination,
      {super.key}
      );

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  late double drawerWidth;
  late double selectedDestination;
  bool homeHovered = false;
  bool masterHovered = false;
  bool masterExpanded = false;
  bool masterColor = false;
  bool mileStoneHovered = false;
  bool mileStoneExpanded = false;
  bool mileStoneColor = false;
  bool createMasterHovered = false;
  bool userManagementHovered = false;
  bool userManagementExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    drawerWidth = widget.drawerWidth;
    selectedDestination = widget.selectedDestination;
    if(selectedDestination == 0){
      homeHovered = true;
      userManagementHovered = false;
      masterHovered = false;
    }
    if(selectedDestination == 1.1){
      masterHovered = false;
      masterExpanded = true;
      userManagementHovered = false;
    }
    if(selectedDestination == 1.2){
      masterHovered = false;
      masterExpanded = true;
      userManagementHovered = false;
    }
    if(selectedDestination == 2){
      userManagementHovered = true;
      homeHovered = false;
      masterHovered = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: drawerWidth,
      child: Scaffold(
        body: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            controller: ScrollController(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: <Widget>[
              drawerWidth == 60 ?
              InkWell(
                hoverColor: mHoverColor,
                onTap: () {
                  setState(() {
                    drawerWidth = 190;
                  });
                },
                child: SizedBox(
                  height: 40,
                  child: Icon(
                    Icons.apps_rounded,
                    color: selectedDestination == 0 ? Colors.blue : Colors.black54,
                  ),
                ),
              ) :
              MouseRegion(
                onHover: (event){
                  setState((){
                    homeHovered=true;
                  });
                },
                onExit: (event){
                  setState(() {
                    homeHovered=false;
                  });
                },
                child: Container(
                  color: homeHovered ? mHoverColor : Colors.transparent,
                  child: ListTileTheme(
                    contentPadding: const EdgeInsets.only(left: 0),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          selectedDestination = 0;
                        });
                        Navigator.pushNamed(context, RoutesName.home);
                        // Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => HomePage(),));
                      },
                      leading: const SizedBox(
                        width: 40,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(Icons.apps_rounded),
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          drawerWidth == 60 ? "" : "Home",
                          style: const TextStyle(fontSize: 17, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              drawerWidth == 60 ?
              InkWell(
                hoverColor: mHoverColor,
                onTap: (){
                  setState(() {
                    drawerWidth = 190;
                    // homeHovered = false;
                  });
                },
                child: SizedBox(
                  height: 40,
                  child: Icon(
                    Icons.person,
                    color: selectedDestination == 1.1 ? Colors.blue : Colors.black54,
                  ),
                ),
              ):
              MouseRegion(
                onHover: (event) {
                  setState(() {
                    if(masterExpanded == false){
                      masterHovered = true;
                    }
                  });
                },
                onExit: (event) {
                  setState(() {
                    masterHovered = false;
                  });
                },
                child: Container(
                  color: masterHovered ? mHoverColor : Colors.transparent,
                  child: ListTileTheme(
                      contentPadding: const EdgeInsets.only(left: 10),
                      child: Theme(
                          data: ThemeData().copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            onExpansionChanged: (value) {
                              if(value){
                                masterExpanded = true;
                                masterHovered = true;
                              }else{
                                masterExpanded = false;
                              }
                            },
                            initiallyExpanded: selectedDestination == 1.1,
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: drawerWidth == 60 ? Colors.transparent : Colors.black87,
                              ),
                            ),
                            title: Text(drawerWidth == 60 ? '' : "Master", style: const TextStyle(fontSize: 16)),
                            leading: const SizedBox(
                              width: 40, // Set a specific width here, adjust as needed
                              child: Icon(Icons.person,),
                            ),
                            children: [
                              MouseRegion(
                                onEnter: (event) {
                                  setState(() {
                                    masterColor = true;
                                  });
                                },
                                onExit: (event) {
                                  setState(() {
                                    masterColor = false;
                                  });
                                },
                                child: ListTile(
                                  hoverColor: mHoverColor,
                                  selectedTileColor: Colors.blue,
                                  selectedColor: Colors.black,
                                  title: Center(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Text(
                                            drawerWidth == 60 ? "" : "Create Master",
                                            style: TextStyle(color:selectedDestination==1.1?(masterColor==true? Colors.black:Colors.white):Colors.black)
                                        ),
                                      ),
                                    ),
                                  ),
                                  selected: selectedDestination == 1.1,
                                  onTap: () {
                                    setState(() {
                                      selectedDestination = 1.1;
                                    });
                                    Navigator.pushNamed(context, RoutesName.createProject);
                                    // Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => CreateMaster(),));
                                  },
                                ),
                              ),
                              MouseRegion(
                                onEnter: (event) {
                                  setState(() {
                                    masterColor = true;
                                  });
                                },
                                onExit: (event) {
                                  setState(() {
                                    masterColor = false;
                                  });
                                },
                                child: ListTile(
                                  hoverColor: mHoverColor,
                                  selectedTileColor: Colors.blue,
                                  selectedColor: Colors.black,
                                  title: Center(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Text(
                                            drawerWidth == 60 ? "" : "Milestone",
                                            style: TextStyle(color:selectedDestination==1.2?(masterColor==true? Colors.black:Colors.white):Colors.black)
                                        ),
                                      ),
                                    ),
                                  ),
                                  selected: selectedDestination == 1.2,
                                  onTap: () {
                                    setState(() {
                                      selectedDestination = 1.2;
                                    });
                                    Navigator.pushNamed(context, RoutesName.createMilestone);
                                    // Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => CreateMaster(),));
                                  },
                                ),
                              ),
                            ],
                          )
                      )
                  ),
                ),
              ),

              drawerWidth == 60 ?
              InkWell(
                hoverColor: mHoverColor,
                onTap: () {
                  setState(() {
                    drawerWidth = 190;
                  });
                },
                child: SizedBox(
                  height: 40,
                  child: Icon(
                    Icons.apps_rounded,
                    color: selectedDestination == 2 ? Colors.blue : Colors.black54,
                  ),
                ),
              ) :
              MouseRegion(
                onHover: (event){
                  setState((){
                    homeHovered=true;
                  });
                },
                onExit: (event){
                  setState(() {
                    homeHovered=false;
                  });
                },
                child: Container(
                  color: userManagementHovered ? mHoverColor : Colors.transparent,
                  child: ListTileTheme(
                    contentPadding: const EdgeInsets.only(left: 0),
                    child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.userManagement);
                        // Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => CreateUser(drawerWidth: drawerWidth, selectedDestination: 2),));
                      },
                      leading: const SizedBox(
                        width: 40,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(Icons.person),
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          drawerWidth == 60 ? "" : "User Management",
                          style: const TextStyle(fontSize: 17, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 30,
          width: 50,
          child: InkWell(
            onTap: () {
              setState(() {
                if (drawerWidth == 60) {
                  drawerWidth = 190;
                } else {
                  drawerWidth = 60;
                }
              });
            },
            child: Row(
              children: [
                drawerWidth == 190 ? const Expanded(
                    child: Row(
                      children: [
                        Spacer(),
                        Center(child: Text("minimize",style: TextStyle(color: Colors.black,fontSize: 11),)),
                        Spacer(),
                        Flexible(child: Icon(Icons.arrow_back_ios_new_rounded,size: 18,))
                      ],
                    )
                ) : const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Center(child: Icon(Icons.arrow_forward_ios_rounded,size: 18,)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
