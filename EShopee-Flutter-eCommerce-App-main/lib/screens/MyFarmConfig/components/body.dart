import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/res/palette.dart';
import 'package:e_commerce_app_flutter/components/default_button.dart';

import 'package:e_commerce_app_flutter/services/database/farm_data_helper.dart';
import 'package:e_commerce_app_flutter/models/FarmData.dart';
import 'package:e_commerce_app_flutter/models/FarmConfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
 import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_api_headers/google_api_headers.dart';
import 'dart:math';

class MyFarmHomeConfigBody extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyFarmHomeConfigBody> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController MoiThresholdController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyDimKqe9dIlROucyI10BTTSznTKBhxj-EY');
  List<Prediction> _suggestions = [];

  FarmConfig farmConfig = new FarmConfig();

  bool _toggle_is_manual = true;
  bool _toggle_motorState = true;

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;

  Position position = new  Position();

  bool initialLoad = true;
  Future<FarmConfig> fd ;
  String _placeName = '';
  String ClientId = '';
  String api_domain = '';

  @override
  void initState() {
    super.initState();
    ReadDataFromAPI();
    fd = FarmDataHelper().GetFarmConfig;

    //_searchController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _places.dispose();
    MoiThresholdController.dispose();
    super.dispose();
  }

  ReadDataFromAPI() async {
    String jsonString;
    try {
      ClientId = await FarmDataHelper().getCurentUserSmartFarmClientID;
      api_domain = await FarmDataHelper().getAPI;


      // var url = 'http://192.168.1.34/GetFarmData?clientID='+ClientId;
      var url = api_domain + '/GetFarmSettingStatus?clientID=' + ClientId;
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(response.body);
        jsonString = response.body.toString();

        bool res  = await FarmDataHelper().EditFarmConfigField(jsonDecode(jsonString)[0]['motor_state'] == 1 ? true : false);

        if(res == true) {
          setState(() {
            _toggle_motorState =
            jsonDecode(jsonString)[0]['motor_state'] == 1 ? true : false;
          });
        }

      }
      else {
        // If the API returns an error response, throw an exception
        print('Failed to load data from API');
      }
      // fd = FarmDataHelper().GetFarmConfig;
    }
    catch (e) {
      print(e.toString());
    }
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      position =  Position(latitude: lat, longitude: lng);
    }
  }

  _fetchSuggestions(String input) async {
    if (input.isEmpty) {
      return;
    }
    // Call the Google Places API to fetch the location suggestions
    PlacesAutocompleteResponse response = await _places.autocomplete(
      input,
      language: 'en',
      // types: ['(cities)'],
      types: [],
      components: [Component(Component.country, 'in')],
    );

    if (response.isOkay) {
      // Update the suggestions list with the fetched predictions
      setState(() {
        _suggestions = response.predictions;
      });
    } else {
      print('Failed to fetch suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false, // set it to false
      backgroundColor: Palette.blue_gray,
      body: Padding(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: Form(
          key: _formKey,
          child: FutureBuilder(
              future: fd,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  final docs = snapshot.data;
                  if(initialLoad == true){
                   // setState(() {
                    if(docs.place_name != null && docs.place_name.toString().isNotEmpty){
                      _placeName = docs.place_name;
                    }
                      _toggle_is_manual = docs.is_irrigation_manual;
                      _toggle_motorState = docs.motor_state;

                   // });
                    position = Position(latitude: docs.lat, longitude: docs.lon);
                    MoiThresholdController.text = docs.moi_threshoud.toString();
                  }
                  initialLoad = false;

                  final locName = _placeName.isEmpty ? 'Enter a location' : _placeName;

                  return
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.04),
                        Text(
                          "Smart Farm Configuration",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(28),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 50),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          controller: MoiThresholdController,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: InputDecoration(
                            hintText: docs.moi_threshoud.toString(),
                            labelText: 'Moisture Threshold Value (%)',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the Moisture Threshold Value';
                            }
                            final n = double.tryParse(value);
                            if (n == null && n > 100) {
                              return 'Please enter a valid double value';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Location',
                            hintText: locName,
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          controller: _searchController,
                          onChanged: (value) {
                            // Call the function to fetch the suggestions based on the user input
                            _fetchSuggestions(value);
                            //_handlePressButton();

                          },
                        ),
                        SizedBox(height: 5),
                        _suggestions.length == 0 ? SizedBox(height: 1) :
                        Expanded(
                          //child: SizedBox(
                          //  height: 200.0,
                          child: ListView.builder(
                            itemCount: _suggestions.length,
                            itemBuilder: (context, index) {
                              return Positioned(
                                top: 100.0,
                                left: 10.0,
                                right: 10.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                        _suggestions[index].description),
                                    onTap: () {
                                      // When the user taps on a suggestion, update the TextField with the selected location
                                      displayPrediction(_suggestions[index]);
                                      setState(() {
                                        _searchController.text =
                                            _suggestions[index].description;
                                        _placeName = _suggestions[index].description;
                                      });
                                      _suggestions = [];
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          //  ),
                        ),

                        // Positioned(
                        //   top: 100.0,
                        //   left: 10.0,
                        //   right: 10.0,
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       color: Colors.white,
                        //     ),
                        //     child:  Expanded(
                        //       child: ListView.builder(
                        //         itemCount: _suggestions.length,
                        //         itemBuilder: (context, index) {
                        //           return ListTile(
                        //             title: Text(_suggestions[index].description),
                        //             onTap: () {
                        //               // When the user taps on a suggestion, update the TextField with the selected location
                        //               setState(() {
                        //                 _searchController.text = _suggestions[index].description;
                        //               });
                        //             },
                        //           );
                        //         },
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Expanded(
                        //   child: ListView.builder(
                        //     itemCount: _suggestions.length,
                        //     itemBuilder: (context, index) {
                        //       return ListTile(
                        //         title: Text(_suggestions[index].description),
                        //         onTap: () {
                        //           // When the user taps on a suggestion, update the TextField with the selected location
                        //           setState(() {
                        //             _searchController.text = _suggestions[index].description;
                        //           });
                        //         },
                        //       );
                        //     },
                        //   ),
                        // ),
                        ElevatedButton(
                          onPressed: () async {
                            _checkLocationServicesEnabled();
                            _requestPermission();
                            //_selectLocation();
                            _getCurrentLocation();
                          },
                          child: Text('Use current location'),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.only(left: 10,
                              top: 10,
                              right: 7),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "Manual Irrigation"
                              ),
                              Switch(
                                value: _toggle_is_manual,
                                onChanged: (bool value) {
                                  setState(() {
                                    _toggle_is_manual = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.only(left: 10,
                              top: 0,
                              right: 7),
                          child:
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "Motor State"
                              ),
                              Switch(
                                // value: docs.motor_state,
                                value: _toggle_motorState,
                                onChanged: (bool value) {
                                  setState(() {
                                    _toggle_motorState = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                        DefaultButton(
                          text: "Save",
                          press: () async {
                            saveButtonCallback();
                          },
                        ),
                      ],
                    );
                }
                return Text('Something went wrong');
              }
          ),
        ),
      ),
    );
  }

  void _checkLocationServicesEnabled() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Location Services Disabled'),
          content: Text('Please enable location services to use this app.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
            ),
          ],
        ),
      );
    }
  }

  void _requestPermission() async {
    _permissionGranted = await Permission.location.request();
    if (_permissionGranted != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Location Permission Required'),
          content: Text('Please grant location permission to use this app.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Open Settings'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        ),
      );
    }
  }

  void _getCurrentLocation() async {
    if (_serviceEnabled && _permissionGranted == PermissionStatus.granted) {
      try {

       final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

       String loc = _getAddressFromLatLng(LatLng(pos.latitude, pos.longitude)).toString();
       _searchController.text =  loc;


        // setState(() {
        //   position = pos;
        // });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    final response = await _places.searchNearbyWithRadius(
      Location(lat : latLng.latitude, lng : latLng.longitude),
      50, // radius in meters
      //type: 'address',
    );

    if (response.status == "OK") {
      return '${response.results[0].name}}';
      //return '${response.results[0].name}, ${response.results[0].formattedAddress}, ${response.results[0].id}, ${response.results[0].placeId}';
      //return response.results[0].formattedAddress;
    } else {
      debugPrint('Failed to get place name');
      return '';
    }
  }

  // Future<String> _getAddressFromLatLng(Position pos) async {
  //   Placemark place;
  //   await placemarkFromCoordinates(
  //       pos.latitude, pos.longitude)
  //       .then((List<Placemark> placemarks) {
  //     place = placemarks[0];
  //
  //     setState(() {
  //       position = pos;
  //       _searchController.text = '${place.locality}, ${place.thoroughfare}, ${place.administrativeArea}, ${place.postalCode}';
  //       _suggestions = [];
  //     });
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  //   return '${place.locality}, ${place.thoroughfare}, ${place.administrativeArea}, ${place.postalCode}';
  // }

  Future<bool> makeFormDataPostRequest() async {
    String snackbarMessage;
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse(api_domain+'/UpdateFarmSetting'));
      final headers = {'Content-Type': 'multipart/form-data'};
      request.headers.addAll(headers);
      request.fields.addAll({
        'motorState': _toggle_motorState.toString(),
        'irrigationType': _toggle_is_manual.toString(),
        'moistureThreshold': MoiThresholdController.text,
        'clientID': ClientId
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String js = await response.stream.bytesToString();
        print(js);
        if(jsonDecode(js)['returnCode'] == 1)
          return true;
        else
          return false;
          //snackbarMessage = 'Failed to load data from API';

      }
      else {
        print(response.reasonPhrase);
        snackbarMessage = 'Failed to load data from API';
        throw Exception('Failed to load data from API');
      }
    }
    catch (e) {
      print('Error: ${e.toString()}');
      snackbarMessage = 'Failed to load data from API';
      Logger().i(snackbarMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMessage),
        ),
      );
      return false;
    }
  }


  Future<void> saveButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool status = false;
      String snackbarMessage;
      try {
        if (MoiThresholdController.text.isNotEmpty) {
          if (position.latitude == null || position.latitude <= 0 ||
              position.longitude == null || position.longitude <= 0) {
            snackbarMessage = "Something went wrong";
          } else {
            farmConfig.is_irrigation_manual = _toggle_is_manual;
            farmConfig.motor_state = _toggle_motorState;
            farmConfig.moi_threshoud = double.tryParse(MoiThresholdController.text);
            farmConfig.lon = position.longitude;
            farmConfig.lat = position.latitude;
            farmConfig.place_name = _placeName;

            if(await makeFormDataPostRequest() == true){
              status = await FarmDataHelper().EditFarmConfig(farmConfig);
              if (status == true) {
                snackbarMessage = "Updated";
              } else {
                throw "Coulnd't update phone due to unknown reason";
              }

              // print("Display Name updated to ${currentDisplayNameController.text} ...");
              snackbarMessage = "Updated";
            }
          }
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = "Something went wrong";
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = "Something went wrong";
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
  }
}




