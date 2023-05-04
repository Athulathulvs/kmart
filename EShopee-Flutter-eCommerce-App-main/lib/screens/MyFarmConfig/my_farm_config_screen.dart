import 'package:flutter/material.dart';
import 'components/body.dart';
import 'package:e_commerce_app_flutter/components/coustom_bottom_nav_bar_my_farm.dart';
import 'package:e_commerce_app_flutter/components/enums.dart';
import 'package:flutter/material.dart';

class MyFarmHomeConfig extends StatelessWidget {
  static String routeName = "/MyFarmConfig";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: MyFarmHomeConfigBody(),
      extendBody: true,
      bottomNavigationBar: CustomMyFarmBottomNavBar(selectedMenu: MyFarmMenuState.config),
    );
  }
}