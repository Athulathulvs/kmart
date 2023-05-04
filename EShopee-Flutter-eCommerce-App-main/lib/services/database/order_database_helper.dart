import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/Address.dart';
import 'package:e_commerce_app_flutter/models/CartItem.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/models/OrderedProduct.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';

class OrderDatabaseHelper {

  static const String ORDERS_COLLECTION_NAME = "orders";

  OrderDatabaseHelper._privateConstructor();
  static OrderDatabaseHelper _instance = OrderDatabaseHelper._privateConstructor();
  factory OrderDatabaseHelper() {
    return _instance;
  }

  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<bool> addToMyOrders(List<OrderedProduct> orders) async {
    //String uid = AuthentificationService().currentUser.uid;
    final orderedProductsCollectionRef = firestore
        .collection(ORDERS_COLLECTION_NAME);
    for (final order in orders) {
      await orderedProductsCollectionRef.add(order.toMap());
    }
    return true;
  }

  Future<List<String>> get orderedProductsList async {
    String uid = AuthentificationService().currentUser.uid;
    List orderedProductsId = List<String>();
    final orderedProductsSnapshot = await firestore
        .collection(ORDERS_COLLECTION_NAME)
        .where(OrderedProduct.ORDER_USER_ID,isEqualTo: uid)
        .orderBy(OrderedProduct.ORDER_DATE_KEY, descending: true)
        .get();

    for (final doc in orderedProductsSnapshot.docs) {
      orderedProductsId.add(doc.id);
    }
    return orderedProductsId;
  }

  Future<OrderedProduct> getOrderedProductFromId(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final doc = await firestore
        .collection(ORDERS_COLLECTION_NAME)
        .doc(id)
        .get();
    final orderedProduct = OrderedProduct.fromMap(doc.data(), id: doc.id);
    return orderedProduct;
  }


  Future<List<String>> get usersOrderProductsList async {
    String uid = AuthentificationService().currentUser.uid;
    final productsCollectionReference =
    firestore.collection(ProductDatabaseHelper.PRODUCTS_COLLECTION_NAME);
    final querySnapshot = await productsCollectionReference
        .where(Product.OWNER_KEY, isEqualTo: uid)
        .get();

    List usersProducts = List<String>();
    querySnapshot.docs.forEach((doc) {
      usersProducts.add(doc.id);
    });

    final ordersSnapshot = await firestore
        .collection(ORDERS_COLLECTION_NAME)
        .where(OrderedProduct.PRODUCT_UID_KEY,whereIn: usersProducts)
        .orderBy(OrderedProduct.ORDER_DATE_KEY, descending: true)
        .get();

    List orderesId = List<String>();
    for (final doc in ordersSnapshot.docs) {
      orderesId.add(doc.id);
    }
    return orderesId;
  }
}