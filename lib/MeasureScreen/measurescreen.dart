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
  String weight = '';//Stores value of latest weight
  String bodyfatpercentage = '';//Stores value of latest body fat
  String calorieintake = '';//Stores value of latest calorie intake
  List<WeightData> weightdata = [];//Stores all the entries of weight data
  List<caloricintakeData> caloricintakedata = [];//Stores all entries of calorie intake data
  List<bodyfatData> bodyfatdata = [];//Stores all entries of body fat data
  final dbweightHelper = wd.DatabaseHelper.instance;
  final dbcaloricintakehelper = ci.DatabaseHelper.instance;
  final dbbodyfathelper = bf.DatabaseHelper.instance;
  @override
  void initState() {
    _weightquery();//Query weight table to get latest data
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
        padding:  EdgeInsets.all(Constants.padding*kh*h),
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

  void weightsort() {//sort weight table to get latest value of the weight
    weightdata.sort((a, b) {
      var adate = a.month; 
      var bdate = b.month; 
      return adate.compareTo(
          bdate); 
    });
    weight = weightdata.last.weight.toString();
    setState(() {});
  }

  void bodyfatsort() {//sort body fat table to get latest entry
    weightdata.sort((a, b) {
      var adate = a.month; 
      var bdate = b.month; 
      return adate.compareTo(
          bdate); 
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

  void _weightquery() async {//queries weight table and adds it to weight data
    final allRows = await dbweightHelper.queryAllRows();
    
    weightdata = [];
    allRows.isNotEmpty
        ? allRows.forEach((row) {
            setState(() {
              weightdata.add(WeightData(
                  DateTime.fromMillisecondsSinceEpoch(row['date'] ),
                  double.parse(row['weight'].toString())));
            });
          })
        : [];
    if (allRows.isNotEmpty) {
      weightsort();//sort and get the latest value
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
                  DateTime.fromMillisecondsSinceEpoch(row['date'] ),
                  double.parse(row['caloricintake'].toString())));
            });
          })
        : [];
    if (allRows.isNotEmpty) {
      calorificsort();
    }
  }

  Widget listitem(String title, String val, Widget screen) {
    //COMMENTS ARE ONLY ADDED IN WEIGHT DATA SCREEN+HELPER.REST 2 ie BODY FAT AND CALORIFIC DATA FOLLOW SAME PATTERN OF CODE
    return val == ''
        ? InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextPlain(title,
                    fontWeight: FontWeight.w700,
                    fontSize: 25 * kh * h,
                    letterSpacing: 2 * kw * w),
                Icon(
                  Icons.arrow_circle_right_outlined,
                  color: Colors.blueAccent,
                  size: 25 * kh * h,
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
                    TextPlain(title,
                        fontWeight: FontWeight.w700,
                        fontSize: 25 * kh * h,
                        letterSpacing: 2 * kw * w),
                    TextPlain(val, fontSize: 20 * kh * h),
                  ],
                ),
                Icon(Icons.arrow_circle_right_outlined,
                    color: Colors.blueAccent, size: 25 * kh * h)
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
