import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/category_products/category_products_screen.dart';
import 'package:e_commerce_app_flutter/screens/product_details/product_details_screen.dart';

import 'package:e_commerce_app_flutter/services/data_streams/all_products_stream.dart';
import 'package:e_commerce_app_flutter/services/data_streams/favourite_products_stream.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'product_type_box.dart';
import 'products_section.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const String ICON_KEY = "icon";
const String TITLE_KEY = "title";
const String PRODUCT_TYPE_KEY = "product_type";

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final productCategories = <Map>[
   /* <String, dynamic>{
      ICON_KEY: "assets/icons/Electronics.svg",
      TITLE_KEY: "Electronics",
      PRODUCT_TYPE_KEY: ProductType.Electronics,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Books.svg",
      TITLE_KEY: "Books",
      PRODUCT_TYPE_KEY: ProductType.Books,
    },
    <String, dynamic>{
      ICON_KEY: "assets/icons/Fashion.svg",
      TITLE_KEY: "Fashion",
      PRODUCT_TYPE_KEY: ProductType.Fashion,
    },*/
    <String, dynamic>{
      ICON_KEY: "assets/icons/Groceries.svg",
      TITLE_KEY: "Spices",
      PRODUCT_TYPE_KEY: ProductType.Cardamon,
    },
   /* <String, dynamic>{
      ICON_KEY: "assets/icons/Art.svg",
      TITLE_KEY: "Art",
      PRODUCT_TYPE_KEY: ProductType.Art,
    },*/
    <String, dynamic>{
      ICON_KEY: "assets/icons/Others.svg",
      TITLE_KEY: "Others",
      PRODUCT_TYPE_KEY: ProductType.Others,
    },
  ];

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

  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: getProportionateScreenHeight(15)),
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
                SizedBox(height: getProportionateScreenHeight(15)),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      children: [
                        ...List.generate(
                          productCategories.length,
                          (index) {
                            return ProductTypeBox(
                              icon: productCategories[index][ICON_KEY],
                              title: productCategories[index][TITLE_KEY],
                              onPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoryProductsScreen(
                                      productType: productCategories[index]
                                          [PRODUCT_TYPE_KEY],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.43,
                  child: Column(
                      children: [
                    //Initialize the chart widget
                    SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        /*primaryXAxis: NumericAxis(
                            interactiveTooltip: InteractiveTooltip(
                              // Displays the x-axis tooltip
                                enable: true,
                                borderColor: Colors.red,
                                borderWidth: 2
                            )
                        ),*/
                        primaryYAxis: NumericAxis(
                            interactiveTooltip: InteractiveTooltip(
                              // Displays the y-axis tooltip
                                enable: true,
                                borderColor: Colors.red,
                                borderWidth: 2
                            )
                        ),
                        // Chart title
                        title: ChartTitle(text: 'Price Graph'),
                        // Enable legend
                        //legend: Legend(isVisible: true),
                        // Enable tooltip
                          zoomPanBehavior: ZoomPanBehavior(
                            //enablePinching: true,
                            zoomMode: ZoomMode.x,
                            enablePanning: true,
                          ),
                        tooltipBehavior: TooltipBehavior(enable: true,header:"Price"),
                        series: <ChartSeries<_SalesData, String>>[
                          LineSeries<_SalesData, String>(
                              dataSource: data,
                              //enableTooltip: true,
                              xValueMapper: (_SalesData sales, _) => sales.year,
                              yValueMapper: (_SalesData sales, _) => sales.sales,
                              //name: 'Sales',
                              // Enable data label
                              dataLabelSettings: DataLabelSettings(isVisible: true))
                        ]),
                    /*Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        //Initialize the spark charts widget
                        child: SfSparkLineChart.custom(
                          //Enable the trackball
                          trackball: SparkChartTrackball(
                              activationMode: SparkChartActivationMode.tap),
                          //Enable marker
                          marker: SparkChartMarker(
                              displayMode: SparkChartMarkerDisplayMode.all),
                          //Enable data label
                          labelDisplayMode: SparkChartLabelDisplayMode.all,
                          xValueMapper: (int index) => data[index].year,
                          yValueMapper: (int index) => data[index].sales,
                          dataCount: 5,
                        ),
                      ),
                    )*/
                  ])
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.8,
                  child: ProductsSection(
                    sectionTitle: "Explore All Products",
                    productsStreamController: allProductsStream,
                    emptyListMessage: "Looks like all Stores are closed",
                    onProductCardTapped: onProductCardTapped,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(80)),
              ],
            ),
          ),
        ),
      ),
    );
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
}
class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
