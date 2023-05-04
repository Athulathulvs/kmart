import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/components/coustom_bottom_nav_bar.dart';
import 'package:e_commerce_app_flutter/components/enums.dart';
import 'package:e_commerce_app_flutter/screens/home/components/home_screen_drawer.dart';


import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeScreenDrawer(),
      //appBar: AppBar(),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
