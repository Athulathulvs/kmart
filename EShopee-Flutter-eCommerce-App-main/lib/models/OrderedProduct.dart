import 'Model.dart';

class OrderproductList {
  String productUid;
  num orderQuantity;
  double orderPrice;
  String userId;
  OrderproductList({this.productUid,this.userId, this.orderQuantity,this.orderPrice});
}

class OrderedProduct extends Model {
  static const String PRODUCT_UID_KEY = "product_uid";
  static const String ORDER_DATE_KEY = "order_date";
  static const String ORDER_QUANTITY = "order_quantity";
  static const String ORDER_PRICE = "order_price";
  static const String ORDER_USER_ID = "order_userid";
  static const String ORDER_STATUS = "order_status";
  static const String ORDER_ADDRESS = "order_address";
  static const String ORDER_PAYMENT_ORDER_ID = "order_payment_order_id";
  static const String ORDER_PAYMENT_ID = "order_payment_id";

  String productUid;
  String orderDate;
  num orderQuantity;
  double orderPrice;
  String userId;
  String orderStatus;
  String orderPaymentId;
  String orderPaymentOrderId;
  OrderedProduct(
    String id, {
        this.productUid,
        this.orderDate,
        this.orderQuantity,
        this.orderPrice,
        this.userId,
        this.orderStatus,
        this.orderPaymentId,
        this.orderPaymentOrderId
      }) : super(id);

  factory OrderedProduct.fromMap(Map<String, dynamic> map, {String id}) {
    return OrderedProduct(
      id,
      productUid: map[PRODUCT_UID_KEY],
      orderDate: map[ORDER_DATE_KEY],
      orderQuantity: map[ORDER_QUANTITY],
      orderPrice: map[ORDER_PRICE],
      userId: map[ORDER_USER_ID],
      orderStatus: map[ORDER_STATUS],
      orderPaymentId: map[ORDER_PAYMENT_ID],
      orderPaymentOrderId: map[ORDER_PAYMENT_ORDER_ID],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      PRODUCT_UID_KEY: productUid,
      ORDER_DATE_KEY: orderDate,
      ORDER_QUANTITY: orderQuantity,
      ORDER_PRICE: orderPrice,
      ORDER_USER_ID: userId,
      ORDER_STATUS : orderStatus,
      ORDER_PAYMENT_ID: orderPaymentId,
      ORDER_PAYMENT_ORDER_ID: orderPaymentOrderId,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (productUid != null) map[PRODUCT_UID_KEY] = productUid;
    if (orderDate != null) map[ORDER_DATE_KEY] = orderDate;
    if (orderQuantity != null) map[ORDER_QUANTITY] = orderQuantity;
    if (orderPrice != null) map[ORDER_PRICE] = orderPrice;
    if (userId != null) map[ORDER_USER_ID] = userId;
    if (orderStatus != null) map[ORDER_STATUS] = orderStatus;
    if (orderPaymentId != null) map[ORDER_PAYMENT_ID] = orderPaymentId;
    if (orderPaymentOrderId != null) map[ORDER_PAYMENT_ORDER_ID] = orderPaymentOrderId;
    return map;
  }
}
