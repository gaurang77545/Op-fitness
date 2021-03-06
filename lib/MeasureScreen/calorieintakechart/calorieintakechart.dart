import 'package:flutter/material.dart';
import 'package:op_fitnessapp/MeasureScreen/calorieintakechart/caloricintakehelper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

import '../../customwidgets/constants.dart';
import '../../customwidgets/flatbuttonsimple.dart';
import '../../customwidgets/iconbuttonsimple.dart';
import '../../customwidgets/text.dart';

class caloricintakeChart extends StatefulWidget {
  @override
  State<caloricintakeChart> createState() => _caloricintakeChartState();
}

class _caloricintakeChartState extends State<caloricintakeChart> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<caloricintakeData> data = [
    // caloricintakeData(formattedate( DateTime.now()), 35),
    // caloricintakeData(formattedate(DateTime.now().add(Duration(days: 1))), 28),
    // caloricintakeData(DateTime.now().add(Duration(days: 2)), 34),
    // caloricintakeData(DateTime.now().add(Duration(days: 3)), 32),
    // caloricintakeData(DateTime.now().add(Duration(days: 4)), 40),
    // caloricintakeData(DateTime.now().add(Duration(days: 5)), 40),
    // caloricintakeData('17 Jan', 40),
    // caloricintakeData('19 Jan', 40),
    // caloricintakeData('21 Jan', 40),
    // caloricintakeData('23 Jan', 40),
    // caloricintakeData('6 Jan', 2),
  ];
  final dbHelper = DatabaseHelper.instance;
  DateTime dater = DateTime.now();
  String caloricintake = '';
  TextEditingController caloricintakecontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    dbHelper.database;
    _query();
    // _delete();
    // data.add(caloricintakeData(formattedate(DateTime.now()), 35));
    // caloricintakeData(formattedate(DateTime.now().add(Duration(days: 1))), 35);
    // caloricintakeData(formattedate(DateTime.now().add(Duration(days: 1))), 47);
    super.initState();
  }

  @override
  void dispose() {
    caloricintakecontroller.dispose();
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
        title: TextPlain("Caloric Intake"),
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
                    title: AxisTitle(text: 'Caloric Intake'),
                    decimalPlaces: 0,
                    desiredIntervals: 8,
                    maximum: 100,
                    labelFormat: '{value}kcal',
                    edgeLabelPlacement: EdgeLabelPlacement.shift),
                //title: ChartTitle(text: 'caloricintake(kcal)'),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<caloricintakeData, String>>[
                  LineSeries<caloricintakeData, String>(
                    dataSource: data,
                    xValueMapper: (caloricintakeData caloricintake, _) =>
                        formattedate(caloricintake.month),
                    yValueMapper: (caloricintakeData caloricintake, _) =>
                        caloricintake.caloricintake,
                    name: 'caloricintake',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0 * kw * w, right: 8 * kw * w),
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
                                caloricintake = '';
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(Constants.circularradiusbig * kh * h))),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextPlain("caloricintake"),
                                      FlatButtonSimple(
                                        onPressed: () {},
                                        child: TextPlain(date),
                                      )
                                    ],
                                  ),
                                  content: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: caloricintakecontroller,
                                      decoration: InputDecoration(
                                        hintText: 'kcal',
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      onChanged: (val) {
                                        setState() {
                                          caloricintake = val;
                                         
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
                                            
                                            _insert(
                                                dater,
                                                caloricintakecontroller.text
                                                    .toString());
                                            sort();
                                            
                                          }
                                          Navigator.of(ctx).pop(
                                              caloricintakecontroller.text);
                                        }
                                      },
                                      child: TextPlain("SAVE"),
                                    ),
                                  ],
                                );
                              });
                            }).then((value) {
                         
                          setState(() {
                            caloricintake = value;
                          });
                        });
                        
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
              padding: EdgeInsets.only(left: Constants.padding * kw * w, right: Constants.padding * kw * w),
              child: ListView.builder(
                itemBuilder: (ctx, item) {
                  return historyrecord(
                      data[item].month, data[item].caloricintake.toString());
                },
                itemCount: data.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _insert(DateTime dt, String caloricintake) async {
    // row to insert
    Map<String, dynamic> row = {
      
          DatabaseHelper.columnDate: dt.millisecondsSinceEpoch,
      DatabaseHelper.columncaloricintake: caloricintake,
      
    };
    
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
    _query();
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    
    data = [];
    allRows.isNotEmpty
        ? allRows.forEach((row) {
            setState(() {
              data.add(caloricintakeData(
                  DateTime.fromMillisecondsSinceEpoch(row['date'] ),
                  double.parse(row['caloricintake'].toString())));
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
          TextPlain(
            num_month,
            fontWeight: FontWeight.bold,
          ),
          //TextPlain(
          //   time,
          //   style: TextStyle(fontWeight: FontWeight.w300),
          // )
        ],
      ),
      TextPlain(
        cal + ' kcal',
        fontWeight: FontWeight.w500,
      )
    ],
  );
}

class caloricintakeData {
  final DateTime month;
  final double caloricintake;

  caloricintakeData(this.month, this.caloricintake);
}
