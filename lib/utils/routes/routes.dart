import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_management/milestoe_screens/add_milestone.dart';
import 'package:project_management/project_creation/add_project.dart';
import 'package:project_management/utils/routes/routes_name.dart';

import '../../homePage.dart';
import '../../login_screen/login_screen.dart';
import '../../user_management/create_user.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
      case RoutesName.login:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        );
      case RoutesName.home:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
        );
      case RoutesName.createProject:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AddProject(),
        );
      case RoutesName.createMilestone:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AddMilestone(),
        );
      case RoutesName.userManagement:
        final args = settings.arguments as Map<String, dynamic>?;
        final drawerWidth = args?["drawerWidth"] ?? 190;
        final selectedDestination = args?["selectedDestination"] ?? 2;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>  CreateUser(
              drawerWidth: drawerWidth,
              selectedDestination: selectedDestination
          ),
        );
      default:
        return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
          return const Scaffold(
            body: Center(
              child: Text("No Routes Defined"),
            ),
          );
        },);

    }
  }
}