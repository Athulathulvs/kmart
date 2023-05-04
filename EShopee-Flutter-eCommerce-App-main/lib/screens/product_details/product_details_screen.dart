import 'package:e_commerce_app_flutter/screens/product_details/provider_models/ProductActions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';
import 'components/fab.dart';
import 'components/custom_app_bar.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  final bool deleted ;

  const ProductDetailsScreen({
    Key key,
    @required this.productId,
    this.deleted = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final floatingAction = deleted ? null : AddToCartFAB(productId: productId) ;
    return ChangeNotifierProvider(
      create: (context) => ProductActions(),
      child: Scaffold(
        backgroundColor: Color(0xFFF5F6F9),
        appBar:PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: CustomAppBar(),
        ),
        body: Body(
          productId: productId,
        ),
        floatingActionButton: floatingAction,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }
}
