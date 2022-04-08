import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class CalorieIntakeChart extends StatefulWidget {
  @override
  State<CalorieIntakeChart> createState() => _CalorieIntakeChartState();
}

class _CalorieIntakeChartState extends State<CalorieIntakeChart> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  List<CalorieIntakeData> data = [
    // CalorieIntakeData(formattedate( DateTime.now()), 35),
    // CalorieIntakeData(formattedate(DateTime.now().add(Duration(days: 1))), 28),
    // CalorieIntakeData(DateTime.now().add(Duration(days: 2)), 34),
    // CalorieIntakeData(DateTime.now().add(Duration(days: 3)), 32),
    // CalorieIntakeData(DateTime.now().add(Duration(days: 4)), 40),
    // CalorieIntakeData(DateTime.now().add(Duration(days: 5)), 40),
    // CalorieIntakeData('17 Jan', 40),
    // CalorieIntakeData('19 Jan', 40),
    // CalorieIntakeData('21 Jan', 40),
    // CalorieIntakeData('23 Jan', 40),
    // CalorieIntakeData('6 Jan', 2),
  ];
  DateTime dater = DateTime.now();
  String weight = '';
  TextEditingController weightcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    // data.add(CalorieIntakeData(formattedate(DateTime.now()), 35));
    // CalorieIntakeData(formattedate(DateTime.now().add(Duration(days: 1))), 35);
    // CalorieIntakeData(formattedate(DateTime.now().add(Duration(days: 1))), 47);
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
        title: Text("Calorie Intake"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: h * 0.45,
              margin: EdgeInsets.all(5),
              decoration:
                  BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
              width: w,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Date'),
                    edgeLabelPlacement: EdgeLabelPlacement.shift),
                primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Calorie Intake'),
                    decimalPlaces: 0,
                    desiredIntervals: 8,
                    maximum: 100,
                    labelFormat: '{value}kcal',
                    edgeLabelPlacement: EdgeLabelPlacement.shift),
                //title: ChartTitle(text: 'Weight(kg)'),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<CalorieIntakeData, String>>[
                  LineSeries<CalorieIntakeData, String>(
                    dataSource: data,
                    xValueMapper: (CalorieIntakeData weight, _) =>
                        formattedate(weight.month),
                    yValueMapper: (CalorieIntakeData weight, _) => weight.bodyfat,
                    name: 'Calorie Intake',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'HISTORY',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              String date = DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now())
                                  .toString();
                              return StatefulBuilder(builder: (context, setState) {
                                weight = '';
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(32.0))),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Calorie Intake"),
                                      FlatButton(
                                        onPressed: () {},
                                        child: Text(date),
                                      )
                                    ],
                                  ),
                                  content: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: weightcontroller,
                                    decoration: InputDecoration(
                                      hintText: 'kcal',
                                    ),
                                    onChanged: (val) {
                                      setState() {
                                        weight = val;
                                        print(weight);
                                      }
                                    },
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
                                        await _showDatePicker();
                                        print(weightcontroller.text);
                                        Navigator.of(ctx)
                                            .pop(weightcontroller.text);
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
                          // print(weight + dater.toString());
                          data.add(CalorieIntakeData(dater, double.parse(weight)));
                          sort();
                          //print(data[0].month+data[0].weight.toString());
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
              height: h*0.45,
              padding: EdgeInsets.only(left: 8,right: 8),
              child: ListView.builder(itemBuilder: (ctx,item)
              {
                  return historyrecord(data[item].month, data[item].bodyfat.toString());
              },
              itemCount: data.length,
              ),
            )
           // historyrecord(DateTime.now(), '1726')
          ],
        ),
      ),
    );
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

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        dater = picked;
      });
    }
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
        cal + ' kcal',
        style: TextStyle(fontWeight: FontWeight.w500),
      )
    ],
  );
}

class CalorieIntakeData {
  final DateTime month;
  final double bodyfat;

  CalorieIntakeData(this.month, this.bodyfat);
}

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class CalorieIntakeChart extends StatefulWidget {
//   @override
//   State<CalorieIntakeChart> createState() => _CalorieIntakeChartState();
// }

// class _CalorieIntakeChartState extends State<CalorieIntakeChart> {
//   double h = 0.0, w = 0.0;
//   double kh = 1 / 759.2727272727273;
//   double kw = 1 / 392.72727272727275;
//   List<SalesData> data = [
//     SalesData('6 Jan', 35),
//     SalesData('7 Jan', 28),
//     SalesData('9 Jan', 34),
//     SalesData('11 Jan', 32),
//     SalesData('13 Jan', 40),
//     SalesData('15 Jan', 40),
//     SalesData('17 Jan', 40),
//     SalesData('19 Jan', 40),
//     SalesData('21 Jan', 40),
//     SalesData('23 Jan', 40),

//   ];

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     h = size.height;
//     w = size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Body Fat %"),
//         centerTitle: true,
//         backgroundColor: Colors.green[700],
//         brightness: Brightness.dark,
//       ),
//       body: Container(
//         height: h*0.50,
//         width: w,
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//         child: SfCartesianChart(
//           primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Date'),edgeLabelPlacement: EdgeLabelPlacement.shift),
//           primaryYAxis: NumericAxis(title: AxisTitle(text: 'Body fat %'),labelFormat: '{value}%',edgeLabelPlacement: EdgeLabelPlacement.shift),
//          // title: ChartTitle(text: 'Body Fat Percentage(%)'),
//           tooltipBehavior: TooltipBehavior(enable: true),
//           series: <ChartSeries<SalesData, String>>[
//             LineSeries<SalesData, String>(  
//               dataSource: data,
//               xValueMapper: (SalesData sales, _) => sales.month,
//               yValueMapper: (SalesData sales, _) => sales.sales,
//               name: 'Body Fat %',
//               dataLabelSettings: DataLabelSettings(isVisible: true),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SalesData {
//   final String month;
//   final double sales;

//   SalesData(this.month, this.sales);
// }
