import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/components/async_progress_dialog.dart';
import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/components/nothingtoshow_container.dart';
import 'package:e_commerce_app_flutter/components/product_cart_detail_card.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/models/CartItem.dart';
import 'package:e_commerce_app_flutter/models/OrderedProduct.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/product_details/product_details_screen.dart';
import 'package:e_commerce_app_flutter/services/data_streams/cart_items_stream.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/services/database/order_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:logger/logger.dart';
import '../../../utils.dart';
import 'dart:convert';
import 'dart:io';
import 'package:e_commerce_app_flutter/screens/cart/components/checkout_card.dart';
import 'package:e_commerce_app_flutter/screens/payment_screen/components/razor_credentials.dart' as razorCredentials;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final CartItemsStream cartItemsStream = CartItemsStream();
  PersistentBottomSheetController bottomSheetHandler;
  Razorpay _razorpay = Razorpay();
  double payAmount ;

  @override
  void initState() {
    HttpOverrides.global = MyHttpOverrides();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });
    super.initState();
    cartItemsStream.init();
  }

  @override
  void dispose() {
    _razorpay.clear();
    cartItemsStream.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    final amount = 0.0;
    print(response);
    checkoutButtonCallback(response.paymentId, response.orderId , payAmount);
    verifySignature(
      signature: response.signature,
      paymentId: response.paymentId,
      orderId: response.orderId,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    // Do something when payment fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message ?? ''),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
    // Do something when an external wallet is selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.walletName ?? ''),
      ),
    );
  }

  // create order
  void createOrder(double amount) async {
    String username = razorCredentials.keyId;
    String password = razorCredentials.keySecret;
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, dynamic> body = {
      "amount": amount * 100,
      "currency": "INR",
      "receipt": "Kisan Mart Recipt"
    };
    var res = await http.post(
      Uri.https(
          "api.razorpay.com", "v1/orders"), //https://api.razorpay.com/v1/orders
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      openGateway(jsonDecode(res.body)['id'],amount);
    }
    print(res.body);
  }

  openGateway(String orderId,double amount) {
    var options = {
      'key': razorCredentials.keyId,
      'amount': amount * 100, //in the smallest currency sub-unit.
      'name': 'Kisan Mart.',
      'order_id': orderId, // Generate order_id using Orders API
      'description': 'Fine T-Shirt',
      'timeout': 60 * 5, // in seconds // 5 minutes
      'prefill': {
        'contact': '9074985041',
        'email': 'avs807811@gmail.com',
      }
    };
    _razorpay.open(options);
    payAmount = amount;
  }

  verifySignature({String signature, String paymentId, String orderId,}) async {
    /*if(signature != null && )*/
    Map<String, dynamic> body = {
      'razorpay_signature': signature,
      'razorpay_payment_id': paymentId,
      'razorpay_order_id': orderId,
    };

    var parts = [];
    body.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');
    var res = await http.post(
      Uri.https(
        "10.0.2.2", // my ip address , localhost
        "razorpay_signature_verify.php",
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded", // urlencoded
      },
      body: formData,
    );
    print(res.body);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.body),
        ),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.body),
        ),
      );
    }
  }

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
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                    "Your Cart",
                    style: headingStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.61,
                    child: Center(
                      child: buildCartItemsList(),
                    ),
                  ),
                  DefaultButton(
                    text: "Check out",
                    press: () async {
                      bool allowed = AuthentificationService().currentUserVerified;
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
                      bottomSheetHandler = Scaffold.of(context).showBottomSheet(
                            (context) {
                          return CheckoutCard(
                            onCheckoutPressed: (amount){
                              createOrder(amount);
                            },
                          );
                        },
                      );
                      // paymentBody(context,300);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    cartItemsStream.reload();
    return Future<void>.value();
  }

  Widget buildCartItemsList() {
    return StreamBuilder<List<String>>(
      stream: cartItemsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> cartItemsId = snapshot.data;
          if (cartItemsId.length == 0) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_cart.svg",
                secondaryMessage: "Your cart is empty",
              ),
            );
          }

          return Column(
            children: [
              //SizedBox(height: getProportionateScreenHeight(20)),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  physics: BouncingScrollPhysics(),
                  itemCount: cartItemsId.length,
                  itemBuilder: (context, index) {
                    if (index >= cartItemsId.length) {
                      return SizedBox(height: getProportionateScreenHeight(80));
                    }
                    return buildCartItemDismissible(
                        context, cartItemsId[index], index);
                  },
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
             // SizedBox(height: getProportionateScreenHeight(10)),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        return Center(
          child: NothingToShowContainer(
            iconPath: "assets/icons/network_error.svg",
            primaryMessage: "Something went wrong",
            secondaryMessage: "Unable to connect to Database",
          ),
        );
      },
    );
  }


  void paymentBody(BuildContext context,double amount) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(23),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          return Container(
            height: MediaQuery
                .of(context)
                .size
                .height * .20,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(height: getProportionateScreenHeight(15)),
                    Text("    Proceed to Payment",
                      style: TextStyle(
                          fontSize: 20, color: Colors.black),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.grey,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                /*    Row(
                    children: [
                      Text(
                        "   Total amount : 5000",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),*/
                 SizedBox(height: getProportionateScreenHeight(10)),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Text(
                        "     Total amount : " + amount.toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      // child: SizedBox(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red),
                                  )
                              )
                          ),
                          child: Text(
                            "Pay",
                            style: TextStyle(fontSize: 20),
                          ),

                          onPressed: () async {
                            createOrder(amount);
                          },
                        ),
                      ),

                      //),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }

  Widget buildCartItemDismissible(
      BuildContext context, String cartItemId, int index) {
    return Dismissible(
      key: Key(cartItemId),
      direction: DismissDirection.startToEnd,
      dismissThresholds: {
        DismissDirection.startToEnd: 0.65,
      },
      background: buildDismissibleBackground(),
      child: buildCartItem(cartItemId, index),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final confirmation = await showConfirmationDialog(
            context,
            "Remove Product from Cart?",
          );
          if (confirmation) {
            if (direction == DismissDirection.startToEnd) {
              bool result = false;
              String snackbarMessage;
              try {
                result = await UserDatabaseHelper()
                    .removeProductFromCart(cartItemId);
                if (result == true) {
                  snackbarMessage = "Product removed from cart successfully";
                  await refreshPage();
                } else {
                  throw "Coulnd't remove product from cart due to unknown reason";
                }
              } on FirebaseException catch (e) {
                Logger().w("Firebase Exception: $e");
                snackbarMessage = "Something went wrong";
              } catch (e) {
                Logger().w("Unknown Exception: $e");
                snackbarMessage = "Something went wrong";
              } finally {
                Logger().i(snackbarMessage);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(snackbarMessage),
                  ),
                );
              }

              return result;
            }
          }
        }
        return false;
      },
      onDismissed: (direction) {},
    );
  }

  Widget buildCartItem(String cartItemId, int index) {
    num itemCount =0;
    return Container(
      padding: EdgeInsets.only(
        bottom: 4,
        top: 4,
        right: 4,
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: FutureBuilder<Product>(
        future: ProductDatabaseHelper().getProductWithID(cartItemId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Product product = snapshot.data;
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 8,
                  child: ProductShortDetailCard(
                    productId: product.id,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            productId: product.id,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FutureBuilder<CartItem>(
                    future: UserDatabaseHelper()
                        .getCartItemFromId(cartItemId),
                    builder: (context, snapshot) {
                      itemCount = 0;
                      if (snapshot.hasData) {
                        final cartItem = snapshot.data;
                        itemCount = cartItem.itemCount;
                      } else if (snapshot.hasError) {
                        final error = snapshot.error.toString();
                        Logger().e(error);
                      }

                     return TextField(
                        controller: TextEditingController(text: itemCount.toString()),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          //  border: OutlineInputBorder(
                          //    borderSide: BorderSide(color: Colors.black, width: 0.5),),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.only(left: 10),
                        ),
                        style: TextStyle(
                          color: kPrimaryColor,
                        ),
                       onSubmitted: (value) async {
                          print(value);
                          if (value.isEmpty) {
                            return FIELD_REQUIRED_MSG;
                          }
                          if(product.quantity > int.parse(value))
                            await quantityChangedCallback(cartItemId,int.parse(value));
                          else
                            return "";
                       },
                      );
                    },
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child:Text(product.quantityUnit.toString()),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: kTextColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.arrow_drop_up,
                            color: kTextColor,
                          ),
                          onTap: () async {
                            if(product.quantity > itemCount)
                              await arrowUpCallback(cartItemId);
                            else
                              return;
                          },
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: kTextColor,
                          ),
                          onTap: () async {
                            if(0 < itemCount)
                              await arrowDownCallback(cartItemId);
                            else
                              return;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            Logger().w(error.toString());
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          } else {
            return Center(
              child: Icon(
                Icons.error,
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildDismissibleBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkoutButtonCallback(String paymentId,String paymentOrderId, double amount) async {
    shutBottomSheet();

    final orderFuture = UserDatabaseHelper().emptyCart();
    orderFuture.then((orderedProductsUid) async {
      if (orderedProductsUid != null) {
        print(orderedProductsUid);
        final dateTime = DateTime.now();
        final formatedDateTime = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
        String uid = AuthentificationService().currentUser.uid;
        List<OrderedProduct> orderedProducts = List<OrderedProduct>();
        for (final doc in orderedProductsUid) {
          orderedProducts.add(new OrderedProduct(null,
            productUid: doc.productUid,
            orderDate: formatedDateTime,
            orderQuantity: doc.orderQuantity,
            userId: uid,
            orderStatus: "Order placed",
            orderPrice: (doc.orderPrice * doc.orderQuantity),
            orderPaymentId: paymentId,
            orderPaymentOrderId: paymentOrderId,
          ));
        }

        bool addedProductsToMyProducts = false;
        String snackbarmMessage;
        try {
          addedProductsToMyProducts = await OrderDatabaseHelper().addToMyOrders(orderedProducts);
          if (addedProductsToMyProducts) {
            snackbarmMessage = "Products ordered Successfully";
          } else {
            throw "Could not order products due to unknown issue";
          }
        } on FirebaseException catch (e) {
          Logger().e(e.toString());
          snackbarmMessage = e.toString();
        } catch (e) {
          Logger().e(e.toString());
          snackbarmMessage = e.toString();
        } finally {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(snackbarmMessage ?? "Something went wrong"),
            ),
          );
        }
      } else {
        throw "Something went wrong while clearing cart";
      }
      await showDialog(
        context: context,
        builder: (context) {
          return AsyncProgressDialog(
            orderFuture,
            message: Text("Placing the Order"),
          );
        },
      );
    }).catchError((e) {
      Logger().e(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    });
    await showDialog(
      context: context,
      builder: (context) {
        return AsyncProgressDialog(
          orderFuture,
          message: Text("Placing the Order"),
        );
      },
    );
    //Navigator.of(context).pop();
    await refreshPage();
  }

  void shutBottomSheet() {
    if (bottomSheetHandler != null) {
      bottomSheetHandler.close();
    }
  }

  Future<void> arrowUpCallback(String cartItemId) async {
    shutBottomSheet();
    final future = UserDatabaseHelper().increaseCartItemCount(cartItemId);
    future.then((status) async {
      if (status) {
        await refreshPage();
      } else {
        throw "Couldn't perform the operation due to some unknown issue";
      }
    }).catchError((e) {
      Logger().e(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
    });
    await showDialog(
      context: context,
      builder: (context) {
        return AsyncProgressDialog(
          future,
          message: Text("Please wait"),
        );
      },
    );
  }

  Future<void> quantityChangedCallback(String cartItemId,int qnty) async {
    shutBottomSheet();
    final future = UserDatabaseHelper().updateQuantityCartItemCount(cartItemId,qnty);
    future.then((status) async {
      if (!status) {
        throw "Couldn't perform the operation due to some unknown issue";
      }
    }).catchError((e) {
      Logger().e(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
    });
    await showDialog(
      context: context,
      builder: (context) {
        return AsyncProgressDialog(
          future,
          message: Text("Please wait"),
        );
      },
    );
  }

  Future<void> arrowDownCallback(String cartItemId) async {
    shutBottomSheet();
    final future = UserDatabaseHelper().decreaseCartItemCount(cartItemId);
    future.then((status) async {
      if (status) {
        await refreshPage();
      } else {
        throw "Couldn't perform the operation due to some unknown issue";
      }
    }).catchError((e) {
      Logger().e(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
    });
    await showDialog(
      context: context,
      builder: (context) {
        return AsyncProgressDialog(
          future,
          message: Text("Please wait"),
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
