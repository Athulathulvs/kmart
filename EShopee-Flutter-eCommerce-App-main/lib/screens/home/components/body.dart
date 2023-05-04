import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/services/data_streams/all_products_stream.dart';
import 'package:e_commerce_app_flutter/services/data_streams/favourite_products_stream.dart';
import 'package:e_commerce_app_flutter/screens/product_details/product_details_screen.dart';
import 'package:e_commerce_app_flutter/screens/search_result/search_result_screen.dart';
import 'products_section.dart';
import '../../../size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'package:e_commerce_app_flutter/screens/_old/components/home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:logger/logger.dart';


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final FavouriteProductsStream favouriteProductsStream =
  FavouriteProductsStream();
  final AllProductsStream allProductsStream = AllProductsStream();

  @override
  void initState() {
    super.initState();
    favouriteProductsStream.init();
    allProductsStream.init();
  }

  @override
  void dispose() {
    favouriteProductsStream.dispose();
    allProductsStream.dispose();
    super.dispose();
  }


  Future<void> refreshPage() {
    favouriteProductsStream.reload();
    allProductsStream.reload();
    return Future<void>.value();
  }

  void onProductCardTapped(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productId: productId),
      ),
    ).then((_) async {
      await refreshPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              HomeHeader(
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
                          builder: (context) =>
                              SearchResultScreen(
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
              ),
              SizedBox(height: getProportionateScreenWidth(10)),
              DiscountBanner(),
             // SizedBox(height: getProportionateScreenHeight(20)),
              Categories(),
              //SpecialOffers(),
              SizedBox(height: getProportionateScreenHeight(20)),
              SizedBox(
                height: SizeConfig.screenHeight * 0.5,
                child: ProductsSection(
                  sectionTitle: "Products You Like",
                  productsStreamController: favouriteProductsStream,
                  emptyListMessage: "Add Product to Favourites",
                  onProductCardTapped: onProductCardTapped,
                ),
              ),
              SizedBox(height: getProportionateScreenWidth(30)),
              //PopularProducts(),
              SizedBox(
                height: SizeConfig.screenHeight * 0.8,
                child: ProductsSection(
                  sectionTitle: "Explore All Products",
                  productsStreamController: allProductsStream,
                  emptyListMessage: "Looks like all Stores are closed",
                  onProductCardTapped: onProductCardTapped,
                ),
              ),
              SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        ),
      ),
    );
  }
}
