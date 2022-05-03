import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_fitnessapp/MeasureScreen/bodyfatchart/bodyfatpercentage.dart';
import 'package:op_fitnessapp/MeasureScreen/calorieintakechart/caloricintakehelper.dart' as ci;
import 'package:op_fitnessapp/MeasureScreen/weightchart/weightchart.dart';
import 'package:op_fitnessapp/MeasureScreen/weightchart/weighthelper.dart' as wd;
import 'package:op_fitnessapp/MeasureScreen/bodyfatchart/bodyfathelper.dart' as bf;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:search_bar_animated/search_bar_animated.dart';

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
  String weight = '';
  String bodyfatpercentage = '';
  String calorieintake = '';
  List<WeightData> weightdata = [];
  List<caloricintakeData> caloricintakedata = [];
  List<bodyfatData> bodyfatdata = [];
  final dbweightHelper = wd.DatabaseHelper.instance;
  final dbcaloricintakehelper = ci.DatabaseHelper.instance;
  final dbbodyfathelper = bf.DatabaseHelper.instance;
  @override
  void initState() {
    _weightquery();
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
        title: Text(
          'Measure',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: h * 0.1,
            ),
            listitem('Weight', weight, WeightChart()),
            SizedBox(
              height: h * 0.05,
            ),
            listitem('Body Fat Percentage', bodyfatpercentage, bodyfatChart()),
            SizedBox(
              height: h * 0.05,
            ),
            listitem('Caloric intake', calorieintake, caloricintakeChart()),
          ],
        ),
      ),
    );
  }

  void weightsort() {
    weightdata.sort((a, b) {
      var adate = a.month; //before -> var adate = a.expiry;
      var bdate = b.month; //before -> var bdate = b.expiry;
      return adate.compareTo(
          bdate); //to get the order other way just switch `adate & bdate`
    });
    weight = weightdata.last.weight.toString();
    setState(() {});
  }

  void bodyfatsort() {
    weightdata.sort((a, b) {
      var adate = a.month; //before -> var adate = a.expiry;
      var bdate = b.month; //before -> var bdate = b.expiry;
      return adate.compareTo(
          bdate); //to get the order other way just switch `adate & bdate`
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
    final allRows = await dbweightHelper.queryAllRows();
    print(allRows);
    print('query all rows:');
    weightdata = [];
    allRows.isNotEmpty
        ? allRows.forEach((row) {
            setState(() {
              weightdata.add(WeightData(
                  DateTime.fromMillisecondsSinceEpoch(row['date'] * 1000),
                  double.parse(row['weight'].toString())));
            });
          })
        : [];
    if (allRows.isNotEmpty) {
      weightsort();
    }
  }

  void _bodyfatquery() async {
    final allRows = await dbbodyfathelper.queryAllRows();
    print(allRows);
    print('query all rows:');
    bodyfatdata = [];
    allRows.isNotEmpty
        ? allRows.forEach((row) {
            setState(() {
              bodyfatdata.add(bodyfatData(
                  DateTime.fromMillisecondsSinceEpoch(row['date'] * 1000),
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
    print(allRows);
    print('query all rows:');
    caloricintakedata = [];
    allRows.isNotEmpty
        ? allRows.forEach((row) {
            setState(() {
              caloricintakedata.add(caloricintakeData(
                  DateTime.fromMillisecondsSinceEpoch(row['date'] * 1000),
                  double.parse(row['caloricintake'].toString())));
            });
          })
        : [];
    if (allRows.isNotEmpty) {
      calorificsort();
    }
  }

  Widget listitem(String title, String val, Widget screen) {
    return val == ''
        ? InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25*kh*h,
                      letterSpacing: 2*kw*w),
                ),
                Icon(
                  Icons.arrow_circle_right_outlined,
                  color: Colors.blueAccent,
                  size: 25*kh*h,
                )
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
            },
          )
        : InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 25*kh*h,
                          letterSpacing: 2*kw*w),
                    ),
                    Text(
                      val,
                      style: TextStyle(fontSize: 20*kh*h),
                    ),
                  ],
                ),
                Icon(Icons.arrow_circle_right_outlined,
                    color: Colors.blueAccent, size: 25*kh*h)
              ],
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
