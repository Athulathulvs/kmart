import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/OrderedProduct.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';

import '../../../size_config.dart';

class OrderDetailsDialog extends StatelessWidget {
  final OrderedProduct orderedProduct;

  OrderDetailsDialog({
    Key key,
    @required this.orderedProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Order Details",
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: UserDatabaseHelper().getUserDataStream(
                    orderedProduct.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map map = snapshot.data.data();
                    final uPhone = map[UserDatabaseHelper.PHONE_KEY];
                    final uName = map[UserDatabaseHelper.NAME];
                    final uEmail = map[UserDatabaseHelper.EMAIL];
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          CreateText("Order ID: ",orderedProduct.id),
                          SizedBox(height: 3,),
                          CreateText("Ordered on: ",orderedProduct.orderDate),
                          SizedBox(height: 3,),
                          CreateText("Amount paid: ",orderedProduct.orderPrice.toString()),
                          SizedBox(height: 3,),
                          CreateText("User Name: ",uName),
                          SizedBox(height: 3,),
                          CreateText("User Email: ",uEmail),
                          SizedBox(height: 3,),
                          CreateText("User Phone: ",uPhone),
                          SizedBox(height: 10,),
                          Center(
                            child: Text(
                            "Status: ${orderedProduct.orderStatus.toString()}",
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                          ),
                        ],
                      ),
                    );
                  }
                  else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Icon(Icons.error),
                    );
                  }
                }),
            /*   Center(
          child: Text(
            "line 1",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),*/
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }

  Widget CreateText(String heading, String content){
    return RichText(
      //softWrap:false,
      textScaleFactor: 1,
      text: new TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: new TextStyle(
          fontSize: 16.0,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
        children: <TextSpan>[
          new TextSpan(text: heading),
          new TextSpan(text: content, style: new TextStyle(fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

}
