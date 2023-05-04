import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import 'expandable_text.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: getProportionateScreenHeight(64),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text.rich(
                          TextSpan(
                              text: product.title,
                              style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: "\n${product.variant} ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: TextButton(
                            onPressed: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child:
                                        Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                "Certificate",
                                                style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 22,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(
                                                    16),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius
                                                      .all(
                                                    Radius.circular(30),
                                                  ),
                                                ),
                                                child: SizedBox(
                                                  child: product.certificate[0]
                                                      .toString() != null
                                                      ? Image.network(
                                                    product.certificate[0],
                                                    fit: BoxFit.contain,
                                                  )
                                                      : AssetImage(
                                                      'assets/images/glap.png'),
                                                ),
                                              ),
                                            ]
                                        )
                                    ),);
                                },
                              );
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0),
                                        side: BorderSide(
                                            color: Colors.orangeAccent)
                                    )
                                )
                            ),
                            child: Text(
                              "View certificate",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            )
                        ),
                      ),
                    ])),

            const SizedBox(height: 16),
            SizedBox(
              height: getProportionateScreenHeight(64),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text.rich(
                      TextSpan(
                        text: "\₹${product.discountPrice}   ",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                        children: [
                          TextSpan(
                            text: "\n\₹${product.originalPrice}",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: kTextColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Text.rich(
                      TextSpan(
                        text: "Quantity",
                        style: TextStyle(
                          //color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: "\n\ ${product.quantity.toString()} ${product
                                .quantityUnit}",
                            style: TextStyle(
                              // decoration: TextDecoration.lineThrough,
                              color: kTextColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(width: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: "Sold by ",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  TextSpan(
                    text: "${product.seller}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            /* ExpandableText(
              title: "Highlights",
              content: product.highlights,
            ),
            const SizedBox(height: 16),*/
            ExpandableText(
              title: "Description",
              content: product.description,
            ),

          ],
        ),
      ],
    );
  }
}
