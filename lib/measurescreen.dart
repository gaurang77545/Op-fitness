import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:search_bar_animated/search_bar_animated.dart';

class MeasureScreen extends StatefulWidget {
  const MeasureScreen({Key? key}) : super(key: key);

  @override
  State<MeasureScreen> createState() => _MeasureScreenState();
}

class _MeasureScreenState extends State<MeasureScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  String weight = '92';
  String bodyfatpercentage = '92';
  String calorieintake = '';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Measure',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: h * 0.1,
            ),
            listitem('Weight', weight),
            SizedBox(
              height: h * 0.05,
            ),
            listitem('Body Fat Percentage', bodyfatpercentage),
            SizedBox(
              height: h * 0.05,
            ),
            listitem('Caloric intake', calorieintake),
          ],
        ),
      ),
    );
  }

  Widget listitem(String title, String val) {
    return val == ''
        ? Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25,letterSpacing: 2),
          )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25,letterSpacing: 2),
              ),
              Text(
                val,
                style: TextStyle(fontSize: 20),
              ),
            ],
          );
  }
}
