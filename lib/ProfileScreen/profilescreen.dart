import 'package:flutter/material.dart';
import 'package:op_fitnessapp/WorkoutAndTemplateScreens/helpers/workouthelper.dart';
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../customwidgets/circleavatarsimple.dart';
import '../customwidgets/flatbuttonsimple.dart';
import '../customwidgets/iconbuttonsimple.dart';
import '../customwidgets/text.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController profilenamecontroller = TextEditingController();
  List<ProfileData> data = [
    // ProfileData(DateTime.now().add(Duration(days: 10)), 2),
    // ProfileData(DateTime.now().add(Duration(days: 5)), 2)
  ];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final prefs = SharedPreferences.getInstance();
  final dbHelper = DatabaseHelper.instance;
  DateTime dater = DateTime.now();
  String workout = '';

  TextEditingController workoutcontroller = TextEditingController();
  String profilename = 'User';

  @override
  void initState() {
    // TODO: implement initState
    getStringValuesSF();
    dbHelper.database;

    _query();
    // _delete();
    // data.add(ProfileData(formattedate(DateTime.now()), 35));
    // ProfileData(formattedate(DateTime.now().add(Duration(days: 1))), 35);
    // ProfileData(formattedate(DateTime.now().add(Duration(days: 1))), 47);
    super.initState();
  }

  Future<void> addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', profilenamecontroller.text);
  }

  Future<void> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = 'User';
    if (prefs.containsKey('name')) {
      stringValue = prefs.getString('name')!;
    }

    setState(() {
      profilename = stringValue;
    });
  }

  @override
  void dispose() {
    workoutcontroller.dispose();
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

  int get workoutcount {
    int count = 0;
    for (int i = 0; i < data.length; i++) {
      count += data[i].workout;
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;

    return Scaffold(
      appBar: AppBar(
        title: TextPlain("Profile"),
        centerTitle: true,
        // backgroundColor: Colors.green[700],
        brightness: Brightness.dark,
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.padding* kh * h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: h * 0.06,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatarSimple(
                    radius: 30 * kh * h,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 55 * kh * h,
                    ),
                  ),
                  SizedBox(
                    width: w * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextPlain(
                        profilename,
                        fontWeight: FontWeight.w600,
                        fontSize: 22 * kh * h,
                      ),
                      TextPlain(
                        workoutcount.toString() + '  workouts',
                        fontWeight: FontWeight.w600,
                        fontSize: 22 * kh * h,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButtonSimple(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      profilename = '';
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(Constants.circularradiusbig*kh*h))),
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextPlain("User Name"),
                                            TextPlain(profilename),
                                          ],
                                        ),
                                        content: Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            controller: profilenamecontroller,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter some text';
                                              }
                                              return null;
                                            },
                                            onChanged: (val) {
                                              setState() {
                                                profilename = val;
                                              }
                                            },
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButtonSimple(
                                            onPressed: () async {
                                              await getStringValuesSF();
                                              Navigator.of(ctx)
                                                  .pop(profilename);
                                            },
                                            child: TextPlain("CANCEL"),
                                          ),
                                          FlatButtonSimple(
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                await addStringToSF();
                                                Navigator.of(ctx).pop(
                                                    profilenamecontroller.text);
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
                                  profilename = value;
                                });
                              });
                              // int id = await dbHelper.delete(8);
                              // print(id);
                            },
                            icon: Icon(Icons.edit)),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Container(
                height: h * 0.45,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(width: Constants.borderwidth * kw * w, color: Constants.bordercolor)),
                width: w,
                padding: EdgeInsets.symmetric(
                    horizontal: 10 * kw * w, vertical: 20 * kh * h),
                child: SfCartesianChart(
                  title: ChartTitle(text: 'Workouts Performed'),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries>[
                    BarSeries<ProfileData, String>(
                        name: 'Workout',
                        dataSource: data,
                        xValueMapper: (ProfileData gdp, _) =>
                            formattedate(gdp.month),
                        yValueMapper: (ProfileData gdp, _) => gdp.workout,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        enableTooltip: true)
                  ],
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      //numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
                      title: AxisTitle(text: 'Workout Performed')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print(allRows);
    print('query all rows:');
    //data = [];
    allRows.isNotEmpty
        ? allRows.forEach((row) {
            setState(() {
              var found = 0;
              for (int i = 0; i < data.length; i++) {
                var obj = data[i];

                if (formattedate(obj.month) ==
                    formattedate(DateTime.fromMillisecondsSinceEpoch(
                        row['date'] * 1000))) {
                  data[i].workout += 1;
                  found = 1;
                  break;
                }
              }
              if (found == 0) {
                data.add(ProfileData(
                    DateTime.fromMillisecondsSinceEpoch(row['date'] * 1000),
                    1));
              } else {
                found = 0;
              }
            });
          })
        : [];
    sort();
    print(data);
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
          cal + ' ',
          fontWeight: FontWeight.w500,
        )
      ],
    );
  }
}

class ProfileData {
  final DateTime month;
  int workout;

  ProfileData(this.month, this.workout);
}
