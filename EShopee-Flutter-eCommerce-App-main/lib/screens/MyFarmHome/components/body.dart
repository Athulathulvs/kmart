import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_commerce_app_flutter/res/palette.dart';
import '../widgets/dashboard/humidity_chart.dart';
import '../widgets/dashboard/temperature_chart.dart';
import '../widgets/dashboard/moisture_chart.dart';
import 'package:flutter/services.dart';
import 'package:e_commerce_app_flutter/services/database/farm_data_helper.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/models/FarmData.dart';
import 'package:e_commerce_app_flutter/models/FarmConfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyFarmHomeBody extends StatefulWidget {
  static String routeName = "/home";
  //const MyFarmHomeScreen();

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<MyFarmHomeBody> {
  // late final Stream<QuerySnapshot<Map<String, dynamic>>> _plantDataStream;

  String farmDataJson ;
  String _errorMessage;

  ReadDataFromAPI() async {

    String jsonString ;
    try {
      String ClientId =  await FarmDataHelper().getCurentUserSmartFarmClientID;
      String api_domain =  await FarmDataHelper().getAPI;

      // var url = 'http://192.168.1.34/GetFarmData?clientID='+ClientId;
      var url = api_domain + '/GetFarmData?clientID='+ClientId;
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // assuming the JSON string is stored in a variable called jsonString
        print(response.body);
        jsonString = response.body.toString();
        //FarmData farmData = FarmData.fromJson(json);
        setState(() {
          farmDataJson = jsonString;
        });


      } else {
        // If the API returns an error response, throw an exception
        throw Exception('Failed to load data from API');
      }

    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });

    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Palette.blue_gray,
      statusBarIconBrightness: Brightness.light,
    ));
    ReadDataFromAPI();
    // _plantDataStream = FirebaseFirestore.instance
    //     .collection('plant')
    //     .where('timestamp',
    //         isGreaterThan:
    //             (DateTime.now().millisecondsSinceEpoch - 43200000) ~/ 1000)
    //     .orderBy('timestamp')
    //     // .limitToLast(200)
    //     .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refreshPage() {
    ReadDataFromAPI();
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.blue_gray,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshPage,
          child: farmDataJson == null && _errorMessage == null
              ? Center(child: CircularProgressIndicator())
              : _errorMessage != null ? Center(
            child: Text(_errorMessage),
          ) : FutureBuilder(
            future: FarmDataHelper().AllSensorDataOfCurrentUser(farmDataJson),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData) {
                final docs = snapshot.data;
                final farmData = docs[0];
                // {temperature: 21.89999962, humidity: 73, moisture: 89.18193054, light: 100, timestamp: 1641974084}
                final double temperature = farmData.temp as double;
                final double humidity = farmData.hum as double;
                final double moisture = farmData.moi as double;
                final num light = 0;
                final String lastUpdatedDateTime = farmData.timestamp as String;

                // final formatter = DateFormat.jm().add_yMMMMd();
                // String lastUpdatedDateTime = formatter.format(
                //   (DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)),
                // );

                return Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Text(
                        'Last updated on: $lastUpdatedDateTime',
                        style: TextStyle(
                          color: Palette.red_accent,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color:
                              //     Palette.green_accent.withOpacity(0.6),
                              //     borderRadius: BorderRadius.circular(10),
                              //   ),
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(16.0),
                              //     child: Column(
                              //       children: [
                              //         // Row(
                              //         //   mainAxisAlignment:
                              //         //   MainAxisAlignment.spaceBetween,
                              //         //   children: [
                              //         //     Text(
                              //         //       'Health',
                              //         //       style: TextStyle(
                              //         //         color: Colors.white,
                              //         //         fontFamily: 'Montserrat',
                              //         //         fontWeight: FontWeight.w400,
                              //         //         letterSpacing: 1,
                              //         //         fontSize: 24.0,
                              //         //       ),
                              //         //     ),
                              //         //     Text(
                              //         //       'Good',
                              //         //       style: TextStyle(
                              //         //         color: Colors.white,
                              //         //         fontFamily: 'Montserrat',
                              //         //         fontWeight: FontWeight.w700,
                              //         //         letterSpacing: 1,
                              //         //         fontSize: 24.0,
                              //         //       ),
                              //         //     ),
                              //         //   ],
                              //         // ),
                              //         // SizedBox(height: 8.0),
                              //         // Row(
                              //         //   crossAxisAlignment:
                              //         //   CrossAxisAlignment.start,
                              //         //   children: [
                              //         //     Icon(
                              //         //       Icons.info,
                              //         //       size: 26.0,
                              //         //       color: Colors.white,
                              //         //     ),
                              //         //     SizedBox(width: 4.0),
                              //         //     Expanded(
                              //         //       child: Text(
                              //         //         'The moisture content of the plant is alright',
                              //         //         style: TextStyle(
                              //         //           color: Colors.white,
                              //         //           fontFamily: 'Montserrat',
                              //         //           fontWeight: FontWeight.w500,
                              //         //           letterSpacing: 1,
                              //         //           fontSize: 14.0,
                              //         //         ),
                              //         //       ),
                              //         //     ),
                              //         //   ],
                              //         // ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              SizedBox(height: 16.0),
                              Text(
                                'Temperature',
                                style: TextStyle(
                                  color: Palette.blue_accent,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  fontSize: 30.0,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                temperature.toStringAsFixed(1) + '°C',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  fontSize: 50.0,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Humidity',
                                style: TextStyle(
                                  color: Palette.blue_accent,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  fontSize: 30.0,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                humidity.toString() + '%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  fontSize: 50.0,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Moisture',
                                style: TextStyle(
                                  color: Palette.blue_accent,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  fontSize: 30.0,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                moisture.toStringAsFixed(2) + '%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  fontSize: 50.0,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 85.0),
                              child: Image.asset(
                                'assets/images/plant_shadow.png',
                                height: 500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.0),
                      TemperatureChart(
                        docs: docs,
                      ),
                      SizedBox(height: 24.0),
                      MoistureChart(
                        docs: docs,
                      ),
                      SizedBox(height: 24.0),
                      HumidityChart(docs : docs),
                      SizedBox(height: 24.0),
                    ],
                  ),
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }
}