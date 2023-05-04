import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/category_products/category_products_screen.dart';

import '../../../size_config.dart';

const String ICON_KEY = "icon";
const String TITLE_KEY = "title";
const String PRODUCT_TYPE_KEY = "product_type";

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    final productCategories = <Map>[

      <String, dynamic>{
        ICON_KEY: "assets/icons/Groceries.svg",
        TITLE_KEY: "Cardamom",
        PRODUCT_TYPE_KEY: ProductType.Cardamon,
      },
      <String, dynamic>{
        ICON_KEY: "assets/icons/pepper.svg",
        TITLE_KEY: "Pepper",
        PRODUCT_TYPE_KEY: ProductType.Pepper,
      },
      <String, dynamic>{
        ICON_KEY: "assets/icons/clover.svg",
        TITLE_KEY: "Grampu",
        PRODUCT_TYPE_KEY: ProductType.Grampu,
      },
      <String, dynamic>{
        ICON_KEY: "assets/icons/coffee-bean.svg",
        TITLE_KEY: "Coffee_bean",
        PRODUCT_TYPE_KEY: ProductType.Coffee_bean,
      },
      <String, dynamic>{
        ICON_KEY: "assets/icons/Others.svg",
        TITLE_KEY: "Others",
        PRODUCT_TYPE_KEY: ProductType.Others,
      },
    ];

    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          productCategories.length,
          (index) => CategoryCard(
            icon: productCategories[index][ICON_KEY],
            text: productCategories[index][TITLE_KEY],
            press: () {
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
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(55),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              height: getProportionateScreenWidth(55),
              width: getProportionateScreenWidth(55),
              decoration: BoxDecoration(
                color: Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(icon),
            ),
            SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenHeight(12),
                //fontWeight: FontWeight.w900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
           // Text(text, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
