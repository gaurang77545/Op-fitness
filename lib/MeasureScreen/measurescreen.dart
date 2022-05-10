import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_fitnessapp/MeasureScreen/bodyfatchart/bodyfatpercentage.dart';
import 'package:op_fitnessapp/MeasureScreen/calorieintakechart/caloricintakehelper.dart'
    as ci;
import 'package:op_fitnessapp/MeasureScreen/weightchart/weightchart.dart';
import 'package:op_fitnessapp/MeasureScreen/weightchart/weighthelper.dart'
    as wd;
import 'package:op_fitnessapp/MeasureScreen/bodyfatchart/bodyfathelper.dart'
    as bf;
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:search_bar_animated/search_bar_animated.dart';

import '../customwidgets/text.dart';
import 'calorieintakechart/calorieintakechart.dart';

class MeasureScreen extends StatefulWidget {
  const MeasureScreen({Key? key}) : super(key: key);

  @override
  State<MeasureScreen> createState() => _MeasureScreenState();
}

class _MeasureScreenState extends State<MeasureScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  String weight = 'NA'; //Stores value of latest weight
  String bodyfatpercentage = 'NA'; //Stores value of latest body fat
  String calorieintake = 'NA'; //Stores value of latest calorie intake
  List<WeightData> weightdata = []; //Stores all the entries of weight data
  List<caloricintakeData> caloricintakedata =
      []; //Stores all entries of calorie intake data
  List<bodyfatData> bodyfatdata = []; //Stores all entries of body fat data
  final dbweightHelper = wd.DatabaseHelper.instance;
  final dbcaloricintakehelper = ci.DatabaseHelper.instance;
  final dbbodyfathelper = bf.DatabaseHelper.instance;
  @override
  void initState() {
    _weightquery(); //Query weight table to get latest data
    _bodyfatquery();
    _caloricintakequery();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _weightquery();
    _bodyfatquery();
    _caloricintakequery();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
    return Scaffold(
      appBar: AppBar(
        title: TextPlain(
          'Measure',
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.padding * kh * h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: h * 0.1,
              ),
              // listitem('Weight', weight, WeightChart()),
              // SizedBox(
              //   height: h * 0.05,
              // ),
              // listitem('Body Fat Percentage', bodyfatpercentage, bodyfatChart()),
              // SizedBox(
              //   height: h * 0.05,
              // ),
              // listitem('Caloric intake', calorieintake, caloricintakeChart()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      textbox(
                          'Weight',
                          weight == 'NA' ? 0 : double.parse(weight),
                          Colors.lightBlueAccent.shade100,
                          Colors.pink,
                          Colors.green,
                          WeightChart()),
                      SizedBox(
                        width: w * 0.05,
                      ),
                      textbox(
                          ' Body Fat\n Percentage',
                          bodyfatpercentage == 'NA'
                              ? 0
                              : double.parse(bodyfatpercentage),
                          Colors.pink.shade100,
                          Colors.pink,
                          Colors.green,
                          bodyfatChart())
                    ],
                  ),
                  SizedBox(
                    height: h * 0.05,
                  ),
                  textbox(
                      ' Caloric\n Intake',
                      calorieintake == 'NA' ? 0 : double.parse(calorieintake),
                      Colors.yellow.shade200,
                      Colors.pink,
                      Colors.green,
                      caloricintakeChart())
                ],
              )
              // textbox('Weight', 47, Colors.lightBlueAccent, Colors.pink,
              //     Colors.green, () {})
              // textbox('Weight', 47, Colors.pink.shade100, Colors.pink,
              //     Colors.green, () {})
            ],
          ),
        ),
      ),
    );
  }

  void weightsort() {
    //sort weight table to get latest value of the weight
    weightdata.sort((a, b) {
      var adate = a.month;
      var bdate = b.month;
      return adate.compareTo(bdate);
    });
    weight = weightdata.last.weight.toString();
    setState(() {});
  }

  void bodyfatsort() {
    //sort body fat table to get latest entry
    weightdata.sort((a, b) {
      var adate = a.month;
      var bdate = b.month;
      return adate.compareTo(bdate);
    });
    bodyfatpercentage = bodyfatdata.last.bodyfat.toString();
    setState(() {});
  }

  void calorificsort() {
    weightdata.sort((a, b) {
      var adate = a.month; //before -> var adate = a.expiry;
      var bdate = b.month; //before -> var bdate = b.expiry;
      return adate.compareTo(
          bdate); //to get the order other way just switch `adate & bdate`
    });
    calorieintake = caloricintakedata.last.caloricintake.toString();
    setState(() {});
  }

  void _weightquery() async {
    //queries weight table and adds it to weight data
    final allRows = await dbweightHelper.queryAllRows();

    weightdata = [];
    allRows.isNotEmpty
        ? allRows.forEach((row) {
            setState(() {
              weightdata.add(WeightData(
                  DateTime.fromMillisecondsSinceEpoch(row['date']),
                  double.parse(row['weight'].toString())));
            });
          })
        : [];
    if (allRows.isNotEmpty) {
      weightsort(); //sort and get the latest value
    }
  }

  void _bodyfatquery() async {
    final allRows = await dbbodyfathelper.queryAllRows();

    bodyfatdata = [];
    allRows.isNotEmpty
        ? allRows.forEach((row) {
            setState(() {
              bodyfatdata.add(bodyfatData(
                  DateTime.fromMillisecondsSinceEpoch(row['date']),
                  double.parse(row['bodyfat'].toString())));
            });
          })
        : [];
    if (allRows.isNotEmpty) {
      bodyfatsort();
    }
  }

  void _caloricintakequery() async {
    final allRows = await dbcaloricintakehelper.queryAllRows();

    caloricintakedata = [];
    allRows.isNotEmpty
        ? allRows.forEach((row) {
            setState(() {
              caloricintakedata.add(caloricintakeData(
                  DateTime.fromMillisecondsSinceEpoch(row['date']),
                  double.parse(row['caloricintake'].toString())));
            });
          })
        : [];
    if (allRows.isNotEmpty) {
      calorificsort();
    }
  }


  Widget textbox(String title, double value, Color backgroundcolor,
      Color textcolor, Color valuecolor, Widget screen) {
    return value == 0
        ? InkWell(
            child: Container(
              height: 170,
              width: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: backgroundcolor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextPlain(
                          title,
                          fontWeight: FontWeight.bold,
                          color: textcolor,
                          fontSize: 25,
                          overflow: TextOverflow.clip,
                        ),
                        TextPlain(
                          value == 0 ? "NA" : value.toString(),
                          fontWeight: FontWeight.bold,
                          color: valuecolor,
                          fontSize: 25,
                        )
                      ]),
                  Icon(Icons.arrow_circle_right_outlined,
                      color: textcolor, size: 30 * kh * h)
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
            },
          )
        : InkWell(
            child: Container(
              height: 170,
              width: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: backgroundcolor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextPlain(
                          title,
                          fontWeight: FontWeight.bold,
                          color: textcolor,
                          fontSize: 25,
                          overflow: TextOverflow.clip,
                        ),
                        TextPlain(
                          value == 0 ? "NA" : value.toString(),
                          fontWeight: FontWeight.bold,
                          color: valuecolor,
                          fontSize: 25,
                        )
                      ]),
                  Icon(Icons.arrow_circle_right_outlined,
                      color: textcolor, size: 30 * kh * h)
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              ).then((value) {
                _weightquery();
                _bodyfatquery();
                _caloricintakequery();
              });
            },
          );
  }
}
