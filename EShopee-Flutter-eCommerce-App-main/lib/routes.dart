import 'package:flutter/widgets.dart';
import 'package:e_commerce_app_flutter/wrappers/authentification_wrapper.dart';
import 'package:e_commerce_app_flutter/screens/home/home_screen.dart';
import 'package:e_commerce_app_flutter/screens/sign_in/sign_in_screen.dart';
import 'package:e_commerce_app_flutter/screens/login_success/login_success_screen.dart';
//import 'package:e_commerce_app_flutter/screens/details/details_screen.dart';
import 'package:e_commerce_app_flutter/screens/profile/profile_screen.dart';
import 'package:e_commerce_app_flutter/screens/cart/cart_screen.dart';
import 'package:e_commerce_app_flutter/screens/order_management/orders_screen.dart';
import 'package:e_commerce_app_flutter/screens/graph_screen/price_graph_screen.dart';

import 'package:e_commerce_app_flutter/screens/MyFarmHome/my_farm_screen.dart';
import 'package:e_commerce_app_flutter/screens/MyFarmML/my_farm_Sugg_screen.dart';
import 'package:e_commerce_app_flutter/screens/MyFarmConfig/my_farm_config_screen.dart';


/*import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';*/

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  AuthentificationWrapper.routeName: (context) => AuthentificationWrapper(),
  SignInScreen.routeName: (context) => SignInScreen(),
  //ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
/*  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),*/
  HomeScreen.routeName: (context) => HomeScreen(),
  //DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  MyOrdersScreen.routeName: (context) => MyOrdersScreen(),
  GraphScreen.routeName : (context) => GraphScreen(),

  MyFarmHomeScreen.routeName: (context) => MyFarmHomeScreen(),
  MyFarmHomeSuggesion.routeName: (context) => MyFarmHomeSuggesion(),
  MyFarmHomeConfig.routeName: (context) => MyFarmHomeConfig(),

};
