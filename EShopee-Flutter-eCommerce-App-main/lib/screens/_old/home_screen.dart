import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
     /* drawer: HomeScreenDrawer(),*/
     /* bottomNavigationBar: SalomonBottomBar(
        currentIndex: 0,
       // onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.purple,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Likes"),
            selectedColor: Colors.pink,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text("Search"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),*/
     /* bottomNavigationBar: MotionTabBar(
        labels: [
          "Cart","Home","Settings"
        ],
        initialSelectedTab: "Home",
        tabIconColor: Colors.purple,
        tabSelectedColor: Colors.deepPurple,
        onTabItemSelected: (int value){
          print(value);
         *//* setState(() {
            _tabController.index = value;
          });*//*
        },
        icons: [
          Icons.shopping_cart,Icons.home,Icons.settings
        ],
        textStyle: TextStyle(color: Colors.black),
      ),*/
    );
  }
}
