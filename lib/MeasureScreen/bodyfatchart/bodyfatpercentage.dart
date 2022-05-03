import 'package:flutter/material.dart';
import 'package:op_fitnessapp/MeasureScreen/bodyfatchart/bodyfathelper.dart';
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../customwidgets/flatbuttonsimple.dart';
import '../../customwidgets/iconbuttonsimple.dart';
import '../../customwidgets/text.dart';

class bodyfatChart extends StatefulWidget {
  @override
  State<bodyfatChart> createState() => _bodyfatChartState();
}

class _bodyfatChartState extends State<bodyfatChart> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<bodyfatData> data = [
    // bodyfatData(formattedate( DateTime.now()), 35),
    // bodyfatData(formattedate(DateTime.now().add(Duration(days: 1))), 28),
    // bodyfatData(DateTime.now().add(Duration(days: 2)), 34),
    // bodyfatData(DateTime.now().add(Duration(days: 3)), 32),
    // bodyfatData(DateTime.now().add(Duration(days: 4)), 40),
    // bodyfatData(DateTime.now().add(Duration(days: 5)), 40),
    // bodyfatData('17 Jan', 40),
    // bodyfatData('19 Jan', 40),
    // bodyfatData('21 Jan', 40),
    // bodyfatData('23 Jan', 40),
    // bodyfatData('6 Jan', 2),
  ];
  final dbHelper = DatabaseHelper.instance;
  DateTime dater = DateTime.now();
  String bodyfat = '';
  TextEditingController bodyfatcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    dbHelper.database;
    _query();
    // _delete();
    // data.add(bodyfatData(formattedate(DateTime.now()), 35));
    // bodyfatData(formattedate(DateTime.now().add(Duration(days: 1))), 35);
    // bodyfatData(formattedate(DateTime.now().add(Duration(days: 1))), 47);
    super.initState();
  }

  @override
  void dispose() {
    bodyfatcontroller.dispose();
    super.dispose();
  }

  void sort() {
    data.sort((a, b) {
      var adate = a.month; //before -> var adate = a.expiry;
      var bdate = b.month; //before -> var bdate = b.expiry;
      return adate.compareTo(
          bdate); //to get the order other way just switch `adate & bdate`
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;

    return Scaffold(
      appBar: AppBar(
        title: TextPlain("Body Fat"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: h * 0.45,
              margin: EdgeInsets.all(5 * kh * h),
              decoration: BoxDecoration(
                  border: Border.all(width: Constants.borderwidth * kw * w, color: Constants.bordercolor)),
              width: w,
              padding: EdgeInsets.symmetric(
                  horizontal: 10 * kw * w, vertical: 20 * kh * h),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Date'),
                    edgeLabelPlacement: EdgeLabelPlacement.shift),
                primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Body Fat'),
                    decimalPlaces: 0,
                    desiredIntervals: 8,
                    maximum: 100,
                    labelFormat: '{value}%',
                    edgeLabelPlacement: EdgeLabelPlacement.shift),
                //title: ChartTitle(text: 'bodyfat(%)'),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<bodyfatData, String>>[
                  LineSeries<bodyfatData, String>(
                    dataSource: data,
                    xValueMapper: (bodyfatData bodyfat, _) =>
                        formattedate(bodyfat.month),
                    yValueMapper: (bodyfatData bodyfat, _) => bodyfat.bodyfat,
                    name: 'Body Fat',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Constants.padding * kw * w, right: Constants.padding * kw * w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextPlain(
                    'HISTORY',
                    fontWeight: FontWeight.w500,
                    fontSize: 12 * kh * h,
                  ),
                  IconButtonSimple(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              String date = DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now())
                                  .toString();
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                bodyfat = '';
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(Constants.circularradiusbig * kh * h))),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextPlain("Body Fat"),
                                      FlatButtonSimple(
                                        child: TextPlain(date),
                                        onPressed: () {},
                                      )
                                    ],
                                  ),
                                  content: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: bodyfatcontroller,
                                      decoration: InputDecoration(
                                        hintText: '%',
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      onChanged: (val) {
                                        setState() {
                                          bodyfat = val;
                                          print(bodyfat);
                                        }
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButtonSimple(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: TextPlain("CANCEL"),
                                    ),
                                    FlatButtonSimple(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          bool x = await _showDatePicker();
                                          if (x) {
                                            print(bodyfatcontroller.text
                                                .toString());
                                            _insert(
                                                dater,
                                                bodyfatcontroller.text
                                                    .toString());
                                            sort();
                                            // print(bodyfatcontroller.text);
                                            print(dater.toString());
                                          }
                                          Navigator.of(ctx)
                                              .pop(bodyfatcontroller.text);
                                        }
                                      },
                                      child: TextPlain("SAVE"),
                                    ),
                                  ],
                                );
                              });
                            }).then((value) {
                          //print(value);
                          setState(() {
                            bodyfat = value;
                          });
                        });
                        // int id = await dbHelper.delete(8);
                        // print(id);
                      },
                      icon: Icon(Icons.add))
                ],
              ),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Container(
              height: h * 0.45,
              padding: EdgeInsets.only(left: 8 * kw * w, right: 8 * kw * w),
              child: ListView.builder(
                itemBuilder: (ctx, item) {
                  return historyrecord(
                      data[item].month, data[item].bodyfat.toString());
                },
                itemCount: data.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _insert(DateTime dt, String bodyfat) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnDate:
          int.parse(Timestamp.fromDate(dt).seconds.toString()),
      DatabaseHelper.columnbodyfat: bodyfat,
      //DatabaseHelper.columnExperience:'Flutter Developer'
    };
    // print(row);
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
    _query();
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print(allRows);
    print('query all rows:');
    data = [];
    allRows.isNotEmpty
        ? allRows.forEach((row) {
            setState(() {
              data.add(bodyfatData(
                  DateTime.fromMillisecondsSinceEpoch(row['date'] * 1000),
                  double.parse(row['bodyfat'].toString())));
            });
          })
        : [];
    sort();
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  String formattedate(DateTime date) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    String num = date.day.toString();
    String month = months[date.month - 1].substring(0, 3);
    String num_month = num + '  ' + month + '    ';
    String time = date.hour.toString() + ":" + date.minute.toString();
    return num_month;
  }

  Future<bool> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        dater = picked;
      });
      return true;
    }
    return false;
    //print(bodyfat);
    //
    //print(data);
    // print(dater);
  }
}

Widget historyrecord(DateTime date, String cal) {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  String num = date.day.toString();
  String month = months[date.month - 1].substring(0, 3);
  String num_month = num + '  ' + month + '    ';
  //String time = DateTime.now().hour.toString() + ":" + date.minute.toString();
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextPlain(num_month, fontWeight: FontWeight.bold),
          //TextPlain(
          //   time,
          //   style: TextStyle(fontWeight: FontWeight.w300),
          // )
        ],
      ),
      TextPlain(
        cal + ' %',
        fontWeight: FontWeight.w500,
      )
    ],
  );
}

class bodyfatData {
  final DateTime month;
  final double bodyfat;

  bodyfatData(this.month, this.bodyfat);
}
