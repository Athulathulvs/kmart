import 'package:e_commerce_app_flutter/wrappers/authentification_wrapper.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:e_commerce_app_flutter/routes.dart';
import 'theme.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme(),
        // We use routeName so that we dont need to remember the name
        initialRoute: AuthentificationWrapper.routeName,
        routes: routes,


/*
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: AuthentificationWrapper()
        //home: AuthentificationWrapper(),*/
        );
  }
}
