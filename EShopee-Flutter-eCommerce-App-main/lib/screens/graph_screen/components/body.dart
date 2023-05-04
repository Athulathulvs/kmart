import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:e_commerce_app_flutter/constants.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/services/database/graph_database_helper.dart';
import 'package:e_commerce_app_flutter/models/PriceGraph.dart';
import 'package:logger/logger.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';
import 'dart:math';
import 'label.dart';

class Body extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  const Body({key, this.seriesList, this.animate}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}


class _BodyState extends State<Body> {
  List<charts.Series> seriesLists;

  //List<charts.Series<TimeSeriesSales, DateTime>> seriesLists;
  List<TimeSeriesSales> list;

  Future<List<PriceGraph>> pp;
  DateTime _time;
  Map<String, num> _measures;

  @override
  void initState() {
    super.initState();
    pp = GraphDatabaseHelper().getGraphDetails();
    //seriesLists = _createSampleData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      // measures["Cardamom Price"] = selectedDatum.first.datum.sales;

      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.sales;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }


  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      SizedBox(height: getProportionateScreenHeight(10)),
      Text(
        "Price Graph",
        style: headingStyle,
      ),
      SizedBox(height: getProportionateScreenHeight(20)),
      Card(
        child: Container(
          //padding: EdgeInsets.all(10),
          height: 380,
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Label("Cardamom".toString(), Colors.blue),
                    //Expanded(child: SizedBox()),
                    Label("Pepper", Colors.red),
                  ],
                ),
              ),

              Flexible(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    Label("Grampu", Colors.yellow),
                    Expanded(child: SizedBox()),
                   // Label("Data4", Colors.green),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Date:Price (Zoom & Pan)",
              ),
              Flexible(
                flex: 12,
                child: FutureBuilder<List<PriceGraph>>(
                    future: GraphDatabaseHelper().getGraphDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final graphItem = snapshot.data;
                        list = new List<TimeSeriesSales>();
                        seriesLists = new List<charts.Series>();

                        //graphItem.where((item) => item.productType == EnumToString.convertToString(ProductType.Cardamon)).toList();

                        for (final item in ProductType.values) {
                          final typelist = graphItem.where((LiItem) =>
                          LiItem.productType == EnumToString.convertToString(item))
                              .toList();
                          list = new List<TimeSeriesSales>();
                          for (final item in typelist) {
                            list.add(new TimeSeriesSales(
                                DateTime.parse(item.priceDate),
                                item.priceValue));
                          }
                          list.sort((a, b) => a.time.compareTo(b.time));
                          if (list.length > 0) {
                            seriesLists.addAll(_createSampleData(
                                list, EnumToString.convertToString(item)));
                          }
                        }

                        print(seriesLists[0].id);
                      } else if (snapshot.hasError) {
                        final error = snapshot.error.toString();
                        Logger().e(error);
                      }
                      print(seriesLists[0].id);
                      return new charts.TimeSeriesChart(
                        seriesLists.cast(),
                        //widget.seriesList,
                        animate: false,
                        defaultRenderer: new charts.LineRendererConfig(
                          includePoints: true,
                        ),
                        /*customSeriesRenderers: [
                  new charts.PointRendererConfig(
                      customRendererId: 'customPoint')
                ],*/
                        selectionModels: [
                          new charts.SelectionModelConfig(
                            type: charts.SelectionModelType.info,
                            changedListener: _onSelectionChanged,
                          )
                        ],
                        dateTimeFactory: const charts.LocalDateTimeFactory(),
                        behaviors: [
                          new charts.PanAndZoomBehavior(
                              panningCompletedCallback: () {}),
                          /* new charts.ChartTitle('Date',
                           // maxWidthStrategy: charts.MaxWidthStrategy.ellipsize,
                            behaviorPosition: charts.BehaviorPosition.bottom,
                            titleOutsideJustification:
                            charts.OutsideJustification.middleDrawArea),
                        new charts.ChartTitle('Price',
                            behaviorPosition: charts.BehaviorPosition.start,
                            titleOutsideJustification:
                            charts.OutsideJustification.middleDrawArea),*/
                        ],

                      );
                    }
                ),
              )
            ],
          ),
        ),
      ),

    //  SizedBox(height: getProportionateScreenHeight(20)),
    ];

    // If there is a selection, then include the details.
    if (_time != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text(_time.toString())));
    }
    _measures?.forEach((String series, num value) {
      children.add(new Text('${series}: ${value}'));
    });

    return
      /*SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: */
      Container(
       // padding: EdgeInsets.all(5),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(7.0),
            child: Column(
              children: children,
            ),
          ),
        ),
        //   ),
      );
  }


  /// Create one series with sample hard coded data.
  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(
      List<TimeSeriesSales> list, String type) {
    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: type,
        // colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: list,
      ),
      /*  new charts.Series<TimeSeriesSales, DateTime>(
          id: type,
         // colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: list)*/
      // Configure our custom point renderer for this series.
      // ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}