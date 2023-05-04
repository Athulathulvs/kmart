import 'package:e_commerce_app_flutter/services/data_streams/data_stream.dart';
import 'package:e_commerce_app_flutter/services/database/order_database_helper.dart';

class OrderedManagementStream extends DataStream<List<String>> {
  @override
  void reload() {
    final orderedProductsFuture = OrderDatabaseHelper().usersOrderProductsList;
    orderedProductsFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}
