import 'package:flutter/material.dart';
import 'package:op_fitnessapp/weightchart/weighthelper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WeightChart extends StatefulWidget {
  @override
  State<WeightChart> createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<WeightData> data = [
    // WeightData(formattedate( DateTime.now()), 35),
    // WeightData(formattedate(DateTime.now().add(Duration(days: 1))), 28),
    // WeightData(DateTime.now().add(Duration(days: 2)), 34),
    // WeightData(DateTime.now().add(Duration(days: 3)), 32),
    // WeightData(DateTime.now().add(Duration(days: 4)), 40),
    // WeightData(DateTime.now().add(Duration(days: 5)), 40),
    // WeightData('17 Jan', 40),
    // WeightData('19 Jan', 40),
    // WeightData('21 Jan', 40),
    // WeightData('23 Jan', 40),
    // WeightData('6 Jan', 2),
  ];
  final dbHelper = DatabaseHelper.instance;
  DateTime dater = DateTime.now();
  String weight = '';
  TextEditingController weightcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    dbHelper.database;
    _query();
    // _delete();
    // data.add(WeightData(formattedate(DateTime.now()), 35));
    // WeightData(formattedate(DateTime.now().add(Duration(days: 1))), 35);
    // WeightData(formattedate(DateTime.now().add(Duration(days: 1))), 47);
    super.initState();
  }

  @override
  void dispose() {
    weightcontroller.dispose();
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
        title: Text("Weight"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: h * 0.45,
              margin: EdgeInsets.all(5*kh*h),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey)),
              width: w,
              padding: EdgeInsets.symmetric(horizontal: 10*kh*h, vertical: 20*kh*h),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Date'),
                    edgeLabelPlacement: EdgeLabelPlacement.shift),
                primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Weight'),
                    decimalPlaces: 0,
                    desiredIntervals: 8,
                    maximum: 100,
                    labelFormat: '{value}kg',
                    edgeLabelPlacement: EdgeLabelPlacement.shift),
                //title: ChartTitle(text: 'Weight(kg)'),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<WeightData, String>>[
                  LineSeries<WeightData, String>(
                    dataSource: data,
                    xValueMapper: (WeightData weight, _) =>
                        formattedate(weight.month),
                    yValueMapper: (WeightData weight, _) => weight.weight,
                    name: 'Weight',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'HISTORY',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12*kh*h),
                  ),
                  IconButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              String date = DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now())
                                  .toString();
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                weight = '';
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32.0*kh*h))),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Weight"),
                                      FlatButton(
                                        onPressed: () {},
                                        child: Text(date),
                                      )
                                    ],
                                  ),
                                  content: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: weightcontroller,
                                      decoration: InputDecoration(
                                        hintText: 'kg',
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      onChanged: (val) {
                                        setState() {
                                          weight = val;
                                          print(weight);
                                        }
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text("CANCEL"),
                                    ),
                                    FlatButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          bool x = await _showDatePicker();
                                          if (x) {
                                            print(weightcontroller.text
                                                .toString());
                                            _insert(
                                                dater,
                                                weightcontroller.text
                                                    .toString());
                                            sort();
                                            // print(weightcontroller.text);
                                            print(dater.toString());
                                          }
                                          Navigator.of(ctx)
                                              .pop(weightcontroller.text);
                                        }
                                      },
                                      child: Text("SAVE"),
                                    ),
                                  ],
                                );
                              });
                            }).then((value) {
                          //print(value);
                          setState(() {
                            weight = value;
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
              padding: EdgeInsets.only(left: 8*kw*w, right: 8*kw*w),
              child: ListView.builder(
                itemBuilder: (ctx, item) {
                  return historyrecord(
                      data[item].month, data[item].weight.toString());
                },
                itemCount: data.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _insert(DateTime dt, String weight) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnDate:
          int.parse(Timestamp.fromDate(dt).seconds.toString()),
      DatabaseHelper.columnWeight: weight,
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
              data.add(WeightData(
                  DateTime.fromMillisecondsSinceEpoch(row['date'] * 1000),
                  double.parse(row['weight'].toString())));
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
    //print(weight);
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
          Text(
            num_month,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // Text(
          //   time,
          //   style: TextStyle(fontWeight: FontWeight.w300),
          // )
        ],
      ),
      Text(
        cal + ' kg',
        style: TextStyle(fontWeight: FontWeight.w500),
      )
    ],
  );
}

class WeightData {
  final DateTime month;
  final double weight;

  WeightData(this.month, this.weight);
}
