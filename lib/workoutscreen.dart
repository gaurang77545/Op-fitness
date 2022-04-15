import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_fitnessapp/bodyfatpercentage.dart';
import 'package:op_fitnessapp/calorieintakechart.dart';
import 'package:op_fitnessapp/exercisescreen.dart';
import 'package:op_fitnessapp/newworkouttemplate.dart';
import 'package:op_fitnessapp/weightchart.dart';
import 'package:op_fitnessapp/measurescreen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  List<Map<String, dynamic>> templates = [
    {
      'name': 'Evening Workout',
      'last_performed': '14',
      'list': [
        exercise(1, 'Pendlay Row(Barbell'),
        exercise(2, 'Pistol Squat'),
        exercise(1, 'Pendlay Row(Barbell'),
        exercise(2, 'Pistol Squat'),
      ]
    },
    {
      'name': 'Evening Workout',
      'last_performed': '14',
      'list': [
        exercise(1, 'Pendlay Row(Barbell'),
        exercise(2, 'Pistol Squat'),
      ]
    },
    {
      'name': 'Evening Workout',
      'last_performed': '14',
      'list': [
        exercise(1, 'Pendlay Row(Barbell'),
        exercise(2, 'Pistol Squat'),
        exercise(1, 'Pendlay Row(Barbell'),
        exercise(2, 'Pistol Squat'),
      ]
    },
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'QUICK START',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
            ),
            SizedBox(
              height: h * 0.005,
            ),
            Container(
              width: w,
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {},
                child: Text('START AN EMPTY WORKOUT'),
              ),
            ),
            SizedBox(
              height: h * 0.005,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MY TEMPLATES',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WorkoutTemplateScreen()),
                    );
                  },
                  icon: Icon(Icons.add),
                )
              ],
            ),
            SizedBox(
              height: h * 0.005,
            ),
            //template('Evening Workout', '14', l)
            templatelist(templates)
          ],
        ),
      ),
    );
  }

  Widget template(String title, String last_performed, List<exercise> l) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: h * 0.01,
              ),
              Text(
                'Last performed  ' + last_performed + '  days ago',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: h * 0.01,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: l.length * 15,
                    //padding: const EdgeInsets.all(10),
                    child: VerticalDivider(
                      color: Colors.black,
                      thickness: 3,
                      indent: 0,
                      endIndent: 0,
                      width: 20,
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (ctx, item) {
                          return Row(
                            children: [
                              Text(
                                l[item].count.toString() + ' x ' + '  ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: w * 0.001,
                              ),
                              Text(
                                l[item].name,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              )
                            ],
                          );
                        },
                        itemCount: l.length,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget templatelist(List<Map<String, dynamic>> l) {
    return Container(
      child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (ctx, item) {
            return Column(
              children: [
                template(l[item]['name'], l[item]['last_performed'],
                    l[item]['list']),
                SizedBox(
                  height: h * 0.02,
                )
              ],
            );
          },
          itemCount: l.length,
        ),
      ),
    );
  }
}

class exercise {
  int count;
  String name;
  exercise(this.count, this.name);
}
