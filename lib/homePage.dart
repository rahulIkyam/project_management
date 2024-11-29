import 'package:flutter/material.dart';
import 'package:project_management/static_data/custom_appbar.dart';
import 'package:project_management/static_data/custom_drawer.dart';

import 'dashboard/dashboard_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      body: Row(
        children: [
          CustomDrawer(190, 0),
          VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(child: Center(child: DashboardScreen(),))
        ],
      ),
    );
  }
}
