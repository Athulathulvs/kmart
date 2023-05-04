import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/utils.dart';
import 'package:e_commerce_app_flutter/screens/sign_in/sign_in_screen.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';
import 'profile_details.dart';
import 'update_graph.dart';
import 'smartfarm_details.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final updataGraph = AuthentificationService().currentUser.uid == "GBj5oADlyqSe3BhhjhObASutvoz2" ? ProfileMenu(
      text: "Update Graph",
      icon: "assets/icons/graph2.svg",
      press: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) =>  PriceGraphForm()));
      },
    ) : SizedBox(height: 1);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {
            Navigator.push(context, MaterialPageRoute(
            builder: (context) =>  ProfileDetails())),
            },
          ),
          ProfileMenu(
            text: "Smart Farm",
            icon: "assets/icons/FarmLand.svg",
            press: () => {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>  SmartFarmDetails())),
            },
          ),
          updataGraph,
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: ()  async {
                final confirmation =
                await showConfirmationDialog(context, "Confirm Sign out ?");
                if (confirmation){
                  AuthentificationService().signOut();
                  Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName , (r) => false);
                }
              },
          ),
        ],
      ),
    );
  }
}
