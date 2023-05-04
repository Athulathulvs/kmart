import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/res/palette.dart';
import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/services/database/farm_data_helper.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:e_commerce_app_flutter/models/FarmData.dart';
import 'package:e_commerce_app_flutter/models/FarmConfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../size_config.dart';

class MyFarmSugg extends StatefulWidget {
  @override
  _MyFarmSuggState createState() => _MyFarmSuggState();
}



class _MyFarmSuggState extends State<MyFarmSugg> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController NitoController = TextEditingController();
  final TextEditingController PhosController = TextEditingController();
  final TextEditingController PotaController = TextEditingController();
  final TextEditingController PHController = TextEditingController();

  String JsonString;
  String _errorMessage;
  List<String>  _suggestions = [];

  Future<void> makeFormDataPostRequest() async {

    List<String>  _sugg = [];

    String ClientId =  await FarmDataHelper().getCurentUserSmartFarmClientID;
    String api_domain =  await FarmDataHelper().getAPI;

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse(api_domain +'/crop-predict'));
      final headers = {'Content-Type': 'multipart/form-data'};
      request.headers.addAll(headers);
      request.fields.addAll({
        'nitrogen': NitoController.text,
        'phosphorous': PhosController.text,
        'pottasium': PotaController.text,
        'ph': PHController.text,
        'rainfall': '300',
        'suggesionCount': '5'
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String js = await response.stream.bytesToString();
        print(js);
        _sugg = jsonDecode(js)['data'].cast<String>();
        setState(() {
         _suggestions = _sugg;
        });
      }
      else {
        print(response.reasonPhrase);
        throw Exception('Failed to load data from API');
      }
    }
    catch (e) {
      print('Error: ${e.toString()}');
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.blue_gray,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              Text(
                "Crop Suggestion",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: NitoController,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: 'Nitrogen',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the nitrogen value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  //_name = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: PhosController,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: 'Phosphorus',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter phosphorus value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  //_email = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: PotaController,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: 'Potassium',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter potassium value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  //_password = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: PHController,
                style: TextStyle(
                  color: Colors.white,
                  //fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  labelText: 'PH',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter PH value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  //_confirmPassword = value;
                },
              ),
              SizedBox(height: 32),
              DefaultButton(
                text: "Get Suggestion",
              press: () async {
                makeFormDataPostRequest();
              },
              ),
              SizedBox(height:10),
              _suggestions.length == 0 ?  SizedBox(height: 1) :
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
                              _suggestions[index]),
                          // onTap: () {
                          //   // When the user taps on a suggestion, update the TextField with the selected location
                          //   displayPrediction(_suggestions[index]);
                          //   setState(() {
                          //     _searchController.text =
                          //         _suggestions[index].description;
                          //   });
                          //
                          //   _suggestions = [];
                          // },
                        ),
                      ),
                    );
                  },
                ),
                //  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
