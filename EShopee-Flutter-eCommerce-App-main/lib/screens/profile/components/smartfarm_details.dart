import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/services/database/farm_data_helper.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SmartFarmDetails extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<SmartFarmDetails> {
  bool isObscurePassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController smartFarmClientIdController =
  TextEditingController();
  final TextEditingController smartFarmNameController =
  TextEditingController();


  @override
  void dispose() {
    //newDisplayNameController.dispose();
    smartFarmClientIdController.dispose();
    smartFarmNameController.dispose();
    // newEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Farm"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.04),
                        Text(
                          "Smart Farm",
                          style: headingStyle,
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.1),
                        currentSmartFarmClientIdField(),
                        //currentSmartFarmName(),
                      ]
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel",
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 2,
                              color: Colors.black,
                            )),
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))

                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            updatePhoneNumberButtonCallback();
                          }, child: Text("save", style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.white,

                      ),),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))
                          ))
                    ]
                )

              ],
            )),
      ),
    );
  }

  Widget currentSmartFarmClientIdField() {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserDatabaseHelper().currentUserDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        String smartFarmclientId;
        if (snapshot.hasData && snapshot.data != null)
          smartFarmclientId = (snapshot.data.data() as Map)[UserDatabaseHelper.SMART_FARM_CLIENT_ID];
        final textField = TextFormField(
          controller: smartFarmClientIdController,
          decoration: InputDecoration(
            hintText: smartFarmclientId,
            labelText: "Current Smart Farm Client ID",
            //errorText:  'Value Can\'t Be Empty' ,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.add_business_rounded),
          ),
          //readOnly: true,
        );
        return Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: textField,
        );
      },
    );
  }

  // Widget currentSmartFarmName() {
  //   return StreamBuilder<DocumentSnapshot>(
  //     stream: UserDatabaseHelper().currentUserDataStream,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         final error = snapshot.error;
  //         Logger().w(error.toString());
  //       }
  //       String currentPhone;
  //       if (snapshot.hasData && snapshot.data != null)
  //         currentPhone =
  //         (snapshot.data.data() as Map)[FarmDataHelper.PHONE_KEY];
  //       final textField = TextFormField(
  //         controller: smartFarmNameController,
  //         decoration: InputDecoration(
  //           hintText: currentPhone,
  //           labelText: "Current Phone Number",
  //           floatingLabelBehavior: FloatingLabelBehavior.always,
  //           suffixIcon: Icon(Icons.phone),
  //         ),
  //         //readOnly: true,
  //       );
  //       /*  if (currentPhone != null)
  //         currentPhoneNumberController.text = currentPhone;*/
  //       return Padding(
  //         padding: EdgeInsets.only(bottom: 30),
  //         child: textField,
  //       );
  //     },
  //   );
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
        if (smartFarmClientIdController.text.isNotEmpty) {
          status = await FarmDataHelper()
              .updateCurrentUserSmartFarmDetails(smartFarmClientIdController.text);
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
