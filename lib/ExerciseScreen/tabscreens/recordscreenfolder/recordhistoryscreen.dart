import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:op_fitnessapp/ExerciseScreen/tabscreens/recordscreenfolder/recordsclass.dart';
import 'package:op_fitnessapp/ExerciseScreen/tabscreens/recordscreenfolder/recordstabscreen.dart';
import 'package:op_fitnessapp/customwidgets/constants.dart';
import 'package:op_fitnessapp/customwidgets/text.dart';

class RecordHistoryScreen extends StatefulWidget {
  String name;
  List<maxreps> maxrepsarr = [];
  List<maxweight> maxweightarr = [];
  Records instance;
  RecordHistoryScreen(
      this.name, this.maxrepsarr, this.maxweightarr, this.instance);

  @override
  State<RecordHistoryScreen> createState() => _RecordHistoryScreenState();
}

class _RecordHistoryScreenState extends State<RecordHistoryScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  var instance;
  @override
  void initState() {
    instance = widget.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
    return Scaffold(
      appBar: AppBar(
        title: TextPlain(
          widget.name,
          color: Colors.black,
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextPlain(
                'MAX REPS',
                fontWeight: FontWeight.w400,
              ),
              Container(
                height: widget.maxrepsarr.length * 30 + 30,
                child: ListView.builder(
                  itemBuilder: (_, item) {
                    return singledetailrow(widget.maxrepsarr[item].reps,
                        instance.formattedate(widget.maxrepsarr[item].date));
                  },
                  itemCount: widget.maxrepsarr.length,
                ),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              TextPlain(
                'MAX WEIGHT ADDED',
                fontWeight: FontWeight.w400,
              ),
              Container(
                height: widget.maxweightarr.length * 30 + 30,
                child: ListView.builder(
                  itemBuilder: (_, item) {
                    return singledetailrow(widget.maxweightarr[item].weight,
                        instance.formattedate(widget.maxweightarr[item].date));
                  },
                  itemCount: widget.maxweightarr.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget singledetailrow(int count, String title) {
  return Padding(
    padding: EdgeInsets.all(Constants.padding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextPlain(
          title,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        TextPlain(
          count.toString(),
          fontWeight: FontWeight.w400,
          color: Colors.black,
        )
      ],
    ),
  );
}
