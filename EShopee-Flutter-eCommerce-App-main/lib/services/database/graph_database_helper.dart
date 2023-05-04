import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/models/PriceGraph.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:enum_to_string/enum_to_string.dart';

  class GraphDatabaseHelper {
    static const String PRICE_GRAPH_COLLECTION_NAME = "graph";

    GraphDatabaseHelper._privateConstructor();

    static GraphDatabaseHelper _instance =
    GraphDatabaseHelper._privateConstructor();

    factory GraphDatabaseHelper() {
      return _instance;
    }

    FirebaseFirestore _firebaseFirestore;

    FirebaseFirestore get firestore {
      if (_firebaseFirestore == null) {
        _firebaseFirestore = FirebaseFirestore.instance;
      }
      return _firebaseFirestore;
    }

    Future<bool> addGraphDetails(PriceGraph data) async {
      //String uid = AuthentificationService().currentUser.uid;
      final orderedProductsCollectionRef = firestore
          .collection(PRICE_GRAPH_COLLECTION_NAME);

        await orderedProductsCollectionRef.add(data.toMap());

      return true;
    }

    Future<List<PriceGraph>> getGraphDetails() async {
      //List<PriceGraphList> priceGraphList = List<PriceGraphList>();
      List<PriceGraph> priceGraphList = List<PriceGraph>();
      final docQuery = firestore
          .collection(PRICE_GRAPH_COLLECTION_NAME)
          .get().asStream();

      await for (final querySnapshot in docQuery) {
        for (final graphDoc in querySnapshot.docs) {
          PriceGraph priceGraph = PriceGraph.fromMap(
              graphDoc.data(), id: graphDoc.id);
          priceGraphList.add(priceGraph);
        }
      }
      return priceGraphList;
    }
  }
