import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/FarmData.dart';
import 'package:e_commerce_app_flutter/models/FarmConfig.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'dart:convert';

class FarmDataHelper {
  static const String SMART_FARM_CONFIG_COLLECTION_NAME = "smart";
  static const String SMART_FARM_API_COLLECTION_NAME = "WebApi";

  static const String SMART_FARM_API_DOC_ID_NAME = "api-01";

  //static const String SMART_FARM_CLIENT_ID = "smart_farm_client_id";

  static const String DOMAIN_KEY = "domain";

  static const String IRRIGATION_KEY = "is_irrigation_manual";
  static const String MOTOR_STATE_KEY = "is_motor_manual";
  static const String MOISTURE_THRESHOLD_KEY = "moi_threshoud";

  FarmDataHelper._privateConstructor();
  static FarmDataHelper _instance =
  FarmDataHelper._privateConstructor();
  factory FarmDataHelper() {
    return _instance;
  }

  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<String> get getCurentUserSmartFarmClientID async {
    String clientId;
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
    await firestore.collection(UserDatabaseHelper.USERS_COLLECTION_NAME).doc(uid).get();
    clientId =  userDocSnapshot.data()[UserDatabaseHelper.SMART_FARM_CLIENT_ID];
    return clientId;
  }

  Future<String> get getAPI async {
    String domain;
    final userDocSnapshot =
    await firestore.collection(SMART_FARM_API_COLLECTION_NAME).doc(SMART_FARM_API_DOC_ID_NAME).get();
    domain =  userDocSnapshot.data()[DOMAIN_KEY];
    return domain;
  }

  Future<bool> updateCurrentUserSmartFarmDetails(String clientid) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot =
    firestore.collection(UserDatabaseHelper.USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({UserDatabaseHelper.SMART_FARM_CLIENT_ID: clientid});
    return true;
  }

  Future<FarmData> FarmDataOfCurrentUser(String jsondata) async {
    final uid = AuthentificationService().currentUser.uid;
     Map<String, dynamic> map = jsonDecode(jsondata)[0];
    final farmData = FarmData.fromMap(map, id: uid);
    return farmData;
  }

  Future<List<FarmData>> AllSensorDataOfCurrentUser(String jsondata) async {
    final List<dynamic> jsonList = json.decode(jsondata);
    final List<FarmData> allfarmdata = jsonList
        .map((json) => FarmData.fromMap(json))
        .toList();
    return allfarmdata;
  }

  Future<FarmConfig> get GetFarmConfig async{
    String uid = AuthentificationService().currentUser.uid;

    final userDocSnapshot = await firestore.collection(UserDatabaseHelper.USERS_COLLECTION_NAME).doc(uid).get();

    if (userDocSnapshot.exists) {
      return FarmConfig.fromMap(userDocSnapshot.data()[UserDatabaseHelper.SMART_FARM_CONFIG], id: userDocSnapshot.id);
    }
    return null;
  }

  Future<bool> EditFarmConfigField(bool farmConfigFieldValue) async {
    String uid = AuthentificationService().currentUser.uid;

    final userDocSnapshot =
    firestore.collection(UserDatabaseHelper.USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({UserDatabaseHelper.SMART_FARM_CONFIG+".is_motor_manual": farmConfigFieldValue});
    return true;
  }


  Future<bool> EditFarmConfig(FarmConfig farmConfig) async {
    String uid = AuthentificationService().currentUser.uid;

    final userDocSnapshot =
    firestore.collection(UserDatabaseHelper.USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({UserDatabaseHelper.SMART_FARM_CONFIG: farmConfig.toMap()});
    return true;
  }
}
