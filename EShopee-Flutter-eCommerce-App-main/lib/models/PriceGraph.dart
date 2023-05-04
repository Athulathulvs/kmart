import 'Model.dart';

class PriceGraphList {
  num priceDate;
  num priceValue;
  String productType;

  PriceGraphList({this.priceDate, this.priceValue, this.productType,});
}

class PriceGraph extends Model {
  static const String PRICE_DATE = "price_date";
  static const String PRICE_VALUE = "price_value";
  static const String PRODUCT_TYPE = "product_type";

  String priceDate;
  num priceValue;
  String productType;
  PriceGraph(
  String id, {
        this.priceDate,
        this.priceValue,
        this.productType,
  }): super(id);

  factory PriceGraph.fromMap(Map<String, dynamic> map, {String id}) {
    return PriceGraph(
      id,
      priceDate: map[PRICE_DATE],
      priceValue: map[PRICE_VALUE],
      productType: map[PRODUCT_TYPE],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      PRICE_DATE: priceDate,
      PRICE_VALUE: priceValue,
      PRODUCT_TYPE: productType,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (priceDate != null) map[PRICE_DATE] = priceDate;
    if (priceValue != null) map[PRICE_VALUE] = priceValue;
    if (productType != null) map[PRODUCT_TYPE] = productType;

    return map;
  }
}