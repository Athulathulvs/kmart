import 'Model.dart';
/*
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/

class FarmConfig extends Model{
  static const String IS_IRRIGATION_KEY = "is_irrigation_manual";
  static const String IS_MOTOR_KEY = "is_motor_manual";
  static const String MOI_THRESHOLD_KEY = "moi_threshoud";
  static const String LON_KEY = "lon";
  static const String LAT_KEY = "lat";
  static const String PLACE_NAME_KEY = "place_name";

  bool is_irrigation_manual;
  double moi_threshoud;
  bool motor_state ;
  String place_name;
  double lat;
  double lon;

  FarmConfig({ String id, this.is_irrigation_manual, this.moi_threshoud, this.motor_state ,this.lat, this.lon,this.place_name}) : super(id);

  factory FarmConfig.fromMap(Map<String, dynamic> map, {String id}) {
    return FarmConfig(
      id: id,
      motor_state: map[IS_MOTOR_KEY],
      is_irrigation_manual: map[IS_IRRIGATION_KEY],
      moi_threshoud: map[MOI_THRESHOLD_KEY],
      lat: map[LON_KEY],
      lon: map[LAT_KEY],
      place_name: map[PLACE_NAME_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      IS_MOTOR_KEY: motor_state,
      IS_IRRIGATION_KEY: is_irrigation_manual,
      MOI_THRESHOLD_KEY: moi_threshoud,
      LON_KEY : lon,
      LAT_KEY: lat,
      PLACE_NAME_KEY: place_name,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (is_irrigation_manual != null) map[IS_IRRIGATION_KEY] = is_irrigation_manual;
    if (moi_threshoud != null) map[MOI_THRESHOLD_KEY] = moi_threshoud;
    if (lon != null) map[LON_KEY] = lon;
    if (lat != null) map[LAT_KEY] = lat;
    if (place_name != null) map[PLACE_NAME_KEY] = place_name;
    return map;
  }
}

