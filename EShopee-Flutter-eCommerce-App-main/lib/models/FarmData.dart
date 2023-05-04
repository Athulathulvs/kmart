import 'Model.dart';
/*
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/

class FarmData extends Model{

  static const String TEMPERATURE_KEY = "temp";
  static const String HUMIDITY_KEY = "hum";
  static const String MOISTURE_KEY = "moi";
  static const String CLIENT_ID_KEY = "client_id";
  static const String TIMESTAMP_KEY = "timestamp";

  double temp;
  double hum;
  double moi;
  String timestamp;
  String client_id;

  FarmData({ String id, this.temp, this.hum, this.moi, this.client_id,this.timestamp}) : super(id);

  factory FarmData.fromMap(Map<String, dynamic> json, {String id}) {
    return FarmData(
      id: id,
      temp: json[TEMPERATURE_KEY],
      hum: json[HUMIDITY_KEY],
      moi: json[MOISTURE_KEY],
      client_id: json[CLIENT_ID_KEY],
      timestamp: json[TIMESTAMP_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      TEMPERATURE_KEY: temp,
      HUMIDITY_KEY: hum,
      MOISTURE_KEY: moi,
      CLIENT_ID_KEY: client_id,
      TIMESTAMP_KEY: timestamp,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (temp != null) map[TEMPERATURE_KEY] = temp;
    if (hum != null) map[HUMIDITY_KEY] = hum;
    if (moi != null) map[MOISTURE_KEY] = moi;
    if (client_id != null) map[CLIENT_ID_KEY] = client_id;
    if (timestamp != null) map[TIMESTAMP_KEY] = timestamp;
    return map;
  }
}

