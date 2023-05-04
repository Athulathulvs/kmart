import 'package:e_commerce_app_flutter/components/async_progress_dialog.dart';
import 'package:e_commerce_app_flutter/components/custom_suffix_icon.dart';
import 'package:e_commerce_app_flutter/components/default_button.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:e_commerce_app_flutter/services/authentification/authentification_service.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:e_commerce_app_flutter/services/database/graph_database_helper.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
  import 'package:enum_to_string/enum_to_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_flutter/models/PriceGraph.dart';

const List<String> listp = <String>['One', 'Two', 'Three', 'Four'];


class PriceGraphForm extends StatefulWidget {
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<PriceGraphForm> {
  final _formKey = GlobalKey<FormState>();
  ProductType _productType;
  Type vv;
  final TextEditingController currentPasswordController =
  TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController confirmpriceController =
  TextEditingController();
  TextEditingController dateCtl = TextEditingController();



  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    priceController.dispose();
    confirmpriceController.dispose();
    dateCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Update Graph"),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 15, top: 20, right: 15),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(screenPadding)),
                child: Column(
                  children: [
                   // buildCurrentPasswordFormField(),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Text(
                      "Update Graph",
                      style: headingStyle,
                    ),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    buildProductTypeDropdown(),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 4,
                            child: new TextFormField(
                                  controller: dateCtl,
                                  decoration: new InputDecoration(hintText: new DateFormat('yyyy-MM-dd  kk:mm:ss').format(DateTime.now()).toString(),
                                    labelText: "Date",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    contentPadding: EdgeInsets.only(left: 30),
                                  ),
                              validator: (value) {
                                if (dateCtl.text.isEmpty) {
                                  return "Date cannot be empty";
                                }
                                if(!isValidDate(dateCtl.text))
                                  return "Invalid date format";

                                return null;
                              },
                                ),
                          ),
                          SizedBox(width: getProportionateScreenHeight(5)),
                          Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () async {
                                DateTime pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101)
                                );
                                dateCtl.text = new DateFormat('yyyy-MM-dd hh:mm:ss').format(pickedDate).toString();
                              },
                              child: IgnorePointer(
                                child: new TextField(
                                  decoration: new InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    suffixIcon: CustomSuffixIcon(
                                      svgIcon: "assets/icons/Calendar.svg",
                                    ),
                                    contentPadding: EdgeInsets.only(left: 30),
                                  ),
                                  // validator: validateDob,),
                              ),
                            ),
                            ),
                          ),
                        ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    buildPriceFormField(),
                    SizedBox(height: getProportionateScreenHeight(40)),
                    DefaultButton(
                      text: "Update",
                      press: () {
                        final updateFuture = updateButtonCallback();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AsyncProgressDialog(
                              updateFuture,
                              message: Text("Updating Password"),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
        )
    );
  }

  bool isValidDate(String input) {
    String msg;
    bool status= false;
    try{
      DateTime date = DateTime.tryParse(input);
      if(input == DateFormat('yyyy-MM-dd kk:mm:ss').format(date).toString())
        status = true;
    } catch (e) {
      Logger().e(e.toString());
      msg = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg ?? "Something went wrong"),
        ),
      );
    }
    return status;
  }

  ProductType get productType {
    return _productType;
  }

  String dropdownValue = EnumToString.convertToString(ProductType.Cardamon);


  Widget buildProductTypeDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 70,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      child: DropdownButton(
        value: dropdownValue,
        items:  ProductType.values
            .map(
              (e) => DropdownMenuItem(
            value: EnumToString.convertToString(e),
            child: Text(
              EnumToString.convertToString(e),
            ),
          ),
        ).toList(),
        onChanged: (String value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value;
          });
        },
        hint: Text(
          "Chose Product Type",
        ),
        style: TextStyle(
          color: kTextColor,
          fontSize: 16,
        ),
        elevation: 0,
        underline: SizedBox(width: 0, height: 0),
      ),


    );
  }

  Widget buildPriceFormField() {
    return TextFormField(
      controller: priceController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Enter price",
        labelText: "Enter Price",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/rupee.svg",
        ),
        contentPadding: EdgeInsets.only(left: 30),
      ),
      validator: (value) {
        if (priceController.text.isEmpty) {
          return "Price cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> updateButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool addedGraphData = false;
      String snackbarmMessage;

      PriceGraph priceGraph = new PriceGraph(
        null,
          priceDate:  dateCtl.text,
          priceValue :  num.parse(priceController.text),
          productType : dropdownValue)  ;

      try {
        addedGraphData = await GraphDatabaseHelper().addGraphDetails(priceGraph);
        if (addedGraphData) {
          snackbarmMessage = "Graph data added successfully";
        } else {
          throw "Could not add graph data due to unknown issue";
        }
      } on FirebaseException catch (e) {
        Logger().e(e.toString());
        snackbarmMessage = e.toString();
      } catch (e) {
        Logger().e(e.toString());
        snackbarmMessage = e.toString();
      } finally {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarmMessage ?? "Something went wrong"),
          ),
        );
      }

    }
  }
}
