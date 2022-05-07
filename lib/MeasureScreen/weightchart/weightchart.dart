import 'package:flutter/material.dart';
import 'package:op_fitnessapp/MeasureScreen/weightchart/weighthelper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

import '../../customwidgets/constants.dart';
import '../../customwidgets/flatbuttonsimple.dart';
import '../../customwidgets/iconbuttonsimple.dart';
import '../../customwidgets/text.dart';

class WeightChart extends StatefulWidget {
  @override
  State<WeightChart> createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<WeightData> data = [];//List of weight data
  final dbHelper = DatabaseHelper.instance;
  DateTime dater = DateTime.now();
  String weight = '';
  TextEditingController weightcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    dbHelper.database;
    _query();//query database and add values to weight data array
    
    super.initState();
  }

  @override
  void dispose() {
    weightcontroller.dispose();
    super.dispose();
  }

  void sort() {//sort weight data array
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
        title: TextPlain("Weight"),
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
                  border: Border.all(
                      width: Constants.borderwidth * kw * w,
                      color: Constants.bordercolor)),
              width: w,
              padding: EdgeInsets.symmetric(
                  horizontal: 10 * kh * h, vertical: 20 * kh * h),
              child: SfCartesianChart(//creates chart
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
                        formattedate(weight.month),//formatting date to look like date+month 
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
                  TextPlain(
                    'HISTORY',
                    fontWeight: FontWeight.w500,
                    fontSize: 12 * kh * h,
                  ),
                  IconButtonSimple(
                      onPressed: () async {
                        showDialog(//show dialog for entering new value of weight+current date
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
                                          Radius.circular(
                                              Constants.circularradiusbig *
                                                  kh *
                                                  h))),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextPlain("Weight"),
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
                                                weightcontroller.text
                                                    .toString());
                                            sort();
                                            
                                         
                                          }
                                          Navigator.of(ctx)
                                              .pop(weightcontroller.text);
                                        }
                                      },
                                      child: TextPlain("SAVE"),
                                    ),
                                  ],
                                );
                              });
                            }).then((value) {
                         
                          setState(() {
                            weight = value;
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
              padding: EdgeInsets.only(
                  left: Constants.padding * kw * w,
                  right: Constants.padding * kw * w),
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

  void _insert(DateTime dt, String weight) async {//insert into backend
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnDate:
          dt.millisecondsSinceEpoch,
      DatabaseHelper.columnWeight: weight,
      
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
              data.add(WeightData(
                  DateTime.fromMillisecondsSinceEpoch(row['date'] ),
                  double.parse(row['weight'].toString())));
            });
          })
        : [];
    sort();
  }

  void _delete() async {//delete entry
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  String formattedate(DateTime date) {//returns a formatted date from date time to date+month(Ex 27 Jan)
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

Widget historyrecord(DateTime date, String cal) {//Widget showing diff weight records
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
        cal + ' kg',
        fontWeight: FontWeight.w500,
      )
    ],
  );
}

class WeightData {
  final DateTime month;
  final double weight;

  WeightData(this.month, this.weight);
}
