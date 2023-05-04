import 'package:flutter/material.dart';
import 'components/body.dart';
import 'package:e_commerce_app_flutter/components/coustom_bottom_nav_bar.dart';
import 'package:e_commerce_app_flutter/components/enums.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Profile"),
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.cart),
    );
  }
}
