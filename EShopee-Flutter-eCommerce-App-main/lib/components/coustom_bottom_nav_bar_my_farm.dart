import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:e_commerce_app_flutter/screens/home/home_screen.dart';
import 'package:e_commerce_app_flutter/screens/profile/profile_screen.dart';
import 'package:e_commerce_app_flutter/screens/cart/cart_screen.dart';
import 'package:e_commerce_app_flutter/screens/order_management/orders_screen.dart';
import '../constants.dart';
import 'package:e_commerce_app_flutter/screens/MyFarmHome/my_farm_screen.dart';
import 'package:e_commerce_app_flutter/components/enums.dart';
import 'package:e_commerce_app_flutter/screens/graph_screen/price_graph_screen.dart';
import 'package:e_commerce_app_flutter/screens/MyFarmML/my_farm_Sugg_screen.dart';
import 'package:e_commerce_app_flutter/screens/MyFarmConfig/my_farm_config_screen.dart';

class CustomMyFarmBottomNavBar extends StatelessWidget {
  const CustomMyFarmBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MyFarmMenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return ClipRRect(
        borderRadius: const BorderRadius.only(
        topRight: Radius.circular(15),
    topLeft: Radius.circular(15),
    ),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            //color: Color(0xFFDADADA).withOpacity(0.15),
            color: Colors.blue.withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/FarmLand.svg",
                  color: MyFarmMenuState.MyFarmHome == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, MyFarmHomeScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Shop Icon.svg",
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, HomeScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/sugg-plant.svg",
                  color: MyFarmMenuState.suggestion == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, MyFarmHomeSuggesion.routeName);
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/config.svg",
                  color: MyFarmMenuState.config == selectedMenu
                      ? kPrimaryColor : inActiveIconColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, MyFarmHomeConfig.routeName);
                },
              ),
            ],
          ),
      ),
    ),
    );
  }
}
