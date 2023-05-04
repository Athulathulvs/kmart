/*
import 'package:e_commerce_app_flutter/services/data_streams/data_stream.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';

class OrderedProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final orderedProductsFuture = ProductDatabaseHelper().getGraphDetails();
    orderedProductsFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}
*/
