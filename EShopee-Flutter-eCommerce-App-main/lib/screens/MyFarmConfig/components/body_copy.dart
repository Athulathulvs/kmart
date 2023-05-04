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
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_api_headers/google_api_headers.dart';
import 'dart:math';


// import 'package:google_maps_webservice/directions.dart';
// import 'package:google_maps_webservice/distance.dart';
// import 'package:google_maps_webservice/geocoding.dart';
// import 'package:google_maps_webservice/geolocation.dart';
// import 'package:google_maps_webservice/staticmap.dart';
// import 'package:google_maps_webservice/timezone.dart';

const kGoogleApiKey = "API key";
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class MyFarmHomeConfigBody extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyFarmHomeConfigBody> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController MoiThresholdController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _searchController = TextEditingController();
  //List<String> _suggestions = [];

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'API key');
  List<Prediction> _suggestions = [];

  FarmConfig farmConfig = new FarmConfig();

  bool _toggle_is_manual = true;
  bool _toggle_motorState = true;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  //Position position = new  Position();
  final apiKey = 'API key';
  LatLng _selectedLocation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _places.dispose();
    MoiThresholdController.dispose();
    super.dispose();
  }

  final customTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    accentColor: Colors.redAccent,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.00)),
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 12.50,
        horizontal: 10.00,
      ),
    ),
  );

  Future<void> _selectLocation() async {
    final prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      language: 'en',
      types: [],
      components: [Component(Component.country, 'us')],
    );

    if (prediction != null) {
      final details = await _places.getDetailsByPlaceId(prediction.placeId);

      setState(() {
        _selectedLocation = LatLng(
          details.result.geometry.location.lat,
          details.result.geometry.location.lng,
        );
      });
    }
  }

  // void _getCoordinates(String query) async {
  //   try {
  //     List<geo.Location> locations = await geo.locationFromAddress(query);
  //     if (locations.isNotEmpty) {
  //       position =  Position(latitude: locations[0].latitude, longitude: locations[0].longitude);
  //
  //     } else {
  //       print('No locations found');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  _fetchSuggestions(String input) async {
    if (input.isEmpty) {
      return;
    }

    // Call the Google Places API to fetch the location suggestions
    PlacesAutocompleteResponse response = await _places.autocomplete(
      input,
      language: 'en',
      types: ['(cities)'],
      components: [Component(Component.country, 'us')],
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

  // Future<void> _selectLocation(BuildContext context) async {
  //   bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!isLocationEnabled) {
  //     throw Exception('Location services are disabled.');
  //   }
  //   Prediction prediction = await PlacesAutocomplete.show(
  //     context: context,
  //     apiKey: apiKey,
  //     mode: Mode.overlay,
  //     language: "en",
  //   );
  //
  //   if (prediction == null) {
  //     return null;
  //   }
  //
  //   PlacesDetailsResponse place = await GoogleMapsPlaces(apiKey: apiKey)
  //       .getDetailsByPlaceId(prediction.placeId);
  //
  //   double latitude = place.result.geometry.location.lat;
  //   double longitude = place.result.geometry.location.lng;
  //   position =  Position(latitude: latitude, longitude: longitude);
  // }

  void onError(PlacesAutocompleteResponse response) {
    // homeScaffoldKey.currentState.showSnackBar(
       SnackBar(content: Text(response.errorMessage));
    // );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      onError: onError,
      mode: Mode.overlay,
      language: "en",
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "en")],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.blue_gray,
      body: Padding(
        //padding: const EdgeInsets.all(16.0),
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: Form(
          key: _formKey,
          child:
          // FutureBuilder(
          //     future: FarmDataHelper().AllSensorDataOfCurrentUser(""),
          //     builder: (context, snapshot) {
          //       return
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
                    // TextFormField(
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //   ),
                    //   controller: MoiThresholdController,
                    //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                    //   decoration: InputDecoration(
                    //     labelText: 'Moisture Threshold Value (%)',
                    //     labelStyle: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 16.0,
                    //     ),
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Please enter the Moisture Threshold Value';
                    //     }
                    //     final n = double.tryParse(value);
                    //     if (n == null  && n > 100) {
                    //       return 'Please enter a valid double value';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // Stack(
                    //   children: [
                    //     GoogleMap(
                    //       initialCameraPosition: CameraPosition(
                    //         target: LatLng(37.7749, -122.4194),
                    //         zoom: 12.0,
                    //       ),
                    //       markers: _selectedLocation == null
                    //           ? null
                    //           : Set<Marker>.of([
                    //         Marker(
                    //           markerId: MarkerId('selected_location'),
                    //           position: _selectedLocation,
                    //           infoWindow: InfoWindow(
                    //             title: 'Selected Location',
                    //           ),
                    //         ),
                    //       ]),
                    //     ),
                    //     Positioned(
                    //       top: 50.0,
                    //       left: 10.0,
                    //       right: 10.0,
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10.0),
                    //           color: Colors.white,
                    //         ),
                    //         child: TextField(
                    //           readOnly: true,
                    //           onTap: () {
                    //             _selectLocation();
                    //           },
                    //           decoration: InputDecoration(
                    //             border: InputBorder.none,
                    //             hintText: 'Search for a location',
                    //             contentPadding:
                    //             EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 16),
                    // TextField(
                    //   decoration: InputDecoration(
                    //     labelText: 'Location',
                    //     hintText: 'Enter a location',
                    //     prefixIcon: Icon(Icons.location_on),
                    //   ),
                    //   controller: _locationController,
                    // ),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Enter a location',
                      ),
                      onChanged: (value) {
                        // Call the function to fetch the suggestions based on the user input
                        //_fetchSuggestions(value);
                        _handlePressButton();

                      },
                    ),
                    // Expanded(
                    //   child: ListView.builder(
                    //     itemCount: _suggestions.length,
                    //     itemBuilder: (context, index) {
                    //       return ListTile(
                    //         title: Text(_suggestions[index].description),
                    //         onTap: () {
                    //           // When the user taps on a suggestion, update the TextField with the selected location
                    //           setState(() {
                    //             _locationController.text = _suggestions[index].description;
                    //           });
                    //         },
                    //       );
                    //     },
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // _checkLocationServicesEnabled();
                        // _requestPermission();
                        // _getCurrentLocation();
                        // Do something with the current location
                      },
                      child: Text('Use current location'),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 10, right: 7),
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
                      padding: EdgeInsets.only(left: 10, top: 0, right: 7),
                      child:
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Motor State"
                          ),
                          Switch(
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
                        updatePhoneNumberButtonCallback();
                      },
                    ),
                  ],
               // );
             // }
          ),
        ),
      ),
    );
  }

  // void _checkLocationServicesEnabled() async {
  //   _serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!_serviceEnabled) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //         title: Text('Location Services Disabled'),
  //         content: Text('Please enable location services to use this app.'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text('Enable'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               Geolocator.openLocationSettings();
  //             },
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

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

  // void _getCurrentLocation() async {
  //   if (_serviceEnabled && _permissionGranted == PermissionStatus.granted) {
  //     try {
  //       position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //       );
  //       setState(() {});
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }


  Future<void> updatePhoneNumberButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool status = false;
      String snackbarMessage;
      try {
        // if (smartFarmNameController.text.isNotEmpty) {
        //   status = await FarmDataHelper()
        //       .updatePhoneForCurrentUser(smartFarmNameController.text);
        //   if (status == true) {
        //     snackbarMessage = "Updated";
        //   } else {
        //     throw "Coulnd't update phone due to unknown reason";
        //   }
        // }
        if (MoiThresholdController.text.isNotEmpty) {

          farmConfig.is_irrigation_manual = _toggle_is_manual;
          farmConfig.motor_state = _toggle_motorState;
          farmConfig.moi_threshoud = double.tryParse(MoiThresholdController.text) ;
          status = await FarmDataHelper()
              .EditFarmConfig(farmConfig);
          if (status == true) {
            snackbarMessage = "Updated";
          } else {
            throw "Coulnd't update phone due to unknown reason";
          }

          // print("Display Name updated to ${currentDisplayNameController.text} ...");
          snackbarMessage = "Updated";
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

Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
  if (p != null) {
    // get detail (lat/lng)
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

   // scaffold.showSnackBar(
      SnackBar(content: Text("${p.description} - $lat/$lng"));
   // );
  }
}

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
class CustomSearchScaffold extends PlacesAutocompleteWidget {
  CustomSearchScaffold()
      : super(
    apiKey: kGoogleApiKey,
    sessionToken: Uuid().generateV4(),
    language: "en",
    components: [Component(Component.country, "uk")],
  );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        displayPrediction(p, searchScaffoldKey.currentState);
      },
      logo: Row(
        children: [FlutterLogo()],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
    return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
   // searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage));
    //);
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
    //  searchScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Got answer"));
    //  );
    }
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}

