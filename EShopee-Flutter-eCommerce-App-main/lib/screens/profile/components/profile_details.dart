import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/screens/change_display_picture/change_display_picture_screen.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/components/async_progress_dialog.dart';
import '../../../constants.dart';
import 'package:e_commerce_app_flutter/components/custom_suffix_icon.dart';
import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/screens/change_password/change_password_screen.dart';

class ProfileDetails extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<ProfileDetails> {
  bool isObscurePassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController currentDisplayNameController =
  TextEditingController();
  final TextEditingController currentPhoneNumberController =
  TextEditingController();

  //final TextEditingController newEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController currentEmailController = TextEditingController();

  @override
  void dispose() {
    //newDisplayNameController.dispose();
    currentDisplayNameController.dispose();
    currentPhoneNumberController.dispose();
    // newEmailController.dispose();
    passwordController.dispose();
    currentEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                FutureBuilder(
                  future: UserDatabaseHelper().displayPictureForCurrentUser,
                  builder: (context, snapshot) {
                    return Center(
                      child: Stack(
                        children: [
                          GestureDetector(
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 4, color: Colors.white),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.1))
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: snapshot.data != null ? NetworkImage(
                                        snapshot.data) : null,
                                  )),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeDisplayPictureScreen(),
                                  ));
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4,
                                    color: Colors.white,
                                  ),
                                  color: Colors.green,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                    );
                  },
                ),
                Form(
                  key: _formKey,
                  child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        buildCurrentDisplayNameField(),
                        buildCurrentPhoneNumberField(),
                      ]
                  ),
                ),
                      Padding(padding: EdgeInsets.only(left: 200),
                      child:
                        TextButton(
                          child: Text(
                            "Change password",
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: ()  {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePasswordScreen(),
                                ));
                          },
                        ),),
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

  Widget buildCurrentDisplayNameField() {
    return StreamBuilder<User>(
      stream: AuthentificationService().userChanges,
      builder: (context, snapshot) {
        String displayName;
        if (snapshot.hasData && snapshot.data != null)
          displayName = snapshot.data.displayName;
        final textField = TextFormField(
          controller: currentDisplayNameController,
          decoration: InputDecoration(
            hintText: displayName,
            labelText: "Current Display Name",
            //errorText:  'Value Can\'t Be Empty' ,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.person),
          ),
          //readOnly: true,
        );
        /*if (displayName != null)
          currentDisplayNameController.text = displayName;*/
        return Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: textField,
        );
      },
    );
  }

  Widget buildCurrentPhoneNumberField() {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserDatabaseHelper().currentUserDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        String currentPhone;
        if (snapshot.hasData && snapshot.data != null)
          currentPhone =
          (snapshot.data.data() as Map)[UserDatabaseHelper.PHONE_KEY];
        final textField = TextFormField(
          controller: currentPhoneNumberController,
          decoration: InputDecoration(
            hintText: currentPhone,
            labelText: "Current Phone Number",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.phone),
          ),
          //readOnly: true,
        );
        /*  if (currentPhone != null)
          currentPhoneNumberController.text = currentPhone;*/
        return Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: textField,
        );
      },
    );
  }

  Future<void> updatePhoneNumberButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool status = false;
      String snackbarMessage;
      try {
        if (currentPhoneNumberController.text.isNotEmpty) {
          status = await UserDatabaseHelper()
              .updatePhoneForCurrentUser(currentPhoneNumberController.text);
          if (status == true) {
            snackbarMessage = "Updated";
          } else {
            throw "Coulnd't update phone due to unknown reason";
          }
        }
        if (currentDisplayNameController.text.isNotEmpty) {
          await AuthentificationService()
              .updateCurrentUserDisplayName(currentDisplayNameController.text);
          status = await UserDatabaseHelper()
              .updateCurrentUserDetails(currentDisplayNameController.text);
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
