import 'package:flutter/material.dart';

import 'package:e_commerce_app_flutter/screens/home/components/body.dart';
import 'package:e_commerce_app_flutter/screens/home/components/home_screen_drawer.dart';
//import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:e_commerce_app_flutter/screens/cart/cart_screen.dart';
import 'package:e_commerce_app_flutter/services/data_streams/all_products_stream.dart';
import 'package:e_commerce_app_flutter/services/data_streams/favourite_products_stream.dart';
import 'package:e_commerce_app_flutter/screens/profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({key}) : super(key: key);
  static const String routeName = "/home";
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyStatefulWidget(title: 'Ecommerce'),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({key, this.title}) : super(key: key);
  final String title;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}


class _MyStatefulWidgetState extends State<MyStatefulWidget> with TickerProviderStateMixin {

  TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 1,
      length: 3,
      vsync: this,

    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  final FavouriteProductsStream favouriteProductsStream = FavouriteProductsStream();
  final AllProductsStream allProductsStream = AllProductsStream();

  Future<void> refreshPage() {
    favouriteProductsStream.reload();
    allProductsStream.reload();
    return Future<void>.value();
  }

  List<Widget> _widgetOptions = <Widget>[
    CartScreen(),
    Body(),
    Body()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex == 0) {
          return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  "Warning",
                ),
                content: Text(
                    "Are you sir to exit?"
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pop(true);
                    },

                    child: Text(
                        "yes"
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                        "No"
                    ),
                  ),
                ],
              )
          );
        }
        setState(() {
          _selectedIndex = 0;
        });
        return false;
      },
      child: Scaffold(
        drawer: HomeScreenDrawer(),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Ecommerce",
            style: TextStyle(
              color: Colors.blue,
              fontFamily: "niel",
              fontSize: 20,
            ),

          ),
          actions: [
          /*  HomeHeader(
              onSearchSubmitted: (value) async {
                final query = value.toString();
                if (query.length <= 0) return;
                List<String> searchedProductsId;
                try {
                  searchedProductsId = await ProductDatabaseHelper()
                      .searchInProducts(query.toLowerCase());
                  if (searchedProductsId != null) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultScreen(
                          searchQuery: query,
                          searchResultProductsId: searchedProductsId,
                          searchIn: "All Products",
                        ),
                      ),
                    );
                    await refreshPage();
                  } else {
                    throw "Couldn't perform search due to some unknown reason";
                  }
                } catch (e) {
                  final error = e.toString();
                  Logger().e(error);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$error"),
                    ),
                  );
                }
              },
              onCartButtonPressed: () async {
                bool allowed =
                    AuthentificationService().currentUserVerified;
                if (!allowed) {
                  final reverify = await showConfirmationDialog(context,
                      "You haven't verified your email address. This action is only allowed for verified users.",
                      positiveResponse: "Resend verification email",
                      negativeResponse: "Go back");
                  if (reverify) {
                    final future = AuthentificationService()
                        .sendVerificationEmailToCurrentUser();
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AsyncProgressDialog(
                          future,
                          message: Text("Resending verification email"),
                        );
                      },
                    );
                  }
                  return;
                }
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ),
                );
                await refreshPage();
              },
            ),*/
            /*Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),*/

            // header
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            CartScreen(),
            Body(),
            ProfileScreen(),
          /*  Settings(),*/
          ],
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _tabController.index,
          onTap: (i) => setState(() =>   _tabController.index = i),
          margin: EdgeInsets.all(5),
          items: [
            /// Likes
            SalomonBottomBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text("cart"),
              selectedColor: Colors.pink,
            ),

            /// Home
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              selectedColor: Colors.purple,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
              selectedColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}

