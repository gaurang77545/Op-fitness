import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class WeightChart extends StatefulWidget {
  @override
  State<WeightChart> createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  List<SalesData> data = [
    // SalesData(formattedate( DateTime.now()), 35),
    // SalesData(formattedate(DateTime.now().add(Duration(days: 1))), 28),
    // SalesData(DateTime.now().add(Duration(days: 2)), 34),
    // SalesData(DateTime.now().add(Duration(days: 3)), 32),
    // SalesData(DateTime.now().add(Duration(days: 4)), 40),
    // SalesData(DateTime.now().add(Duration(days: 5)), 40),
    // SalesData('17 Jan', 40),
    // SalesData('19 Jan', 40),
    // SalesData('21 Jan', 40),
    // SalesData('23 Jan', 40),
    // SalesData('6 Jan', 2),
  ];
  DateTime dater = DateTime.now();
  String weight = '';
  TextEditingController weightcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    // data.add(SalesData(formattedate(DateTime.now()), 35));
    // SalesData(formattedate(DateTime.now().add(Duration(days: 1))), 35);
    // SalesData(formattedate(DateTime.now().add(Duration(days: 1))), 47);
    super.initState();
  }

  @override
  void dispose() {
    weightcontroller.dispose();
    super.dispose();
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
      body: Column(
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
                  title: AxisTitle(text: 'Weight'),
                  decimalPlaces: 0,
                  desiredIntervals: 8,
                  maximum: 100,
                  labelFormat: '{value}kg',
                  edgeLabelPlacement: EdgeLabelPlacement.shift),
              //title: ChartTitle(text: 'Weight(kg)'),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<SalesData, String>>[
                LineSeries<SalesData, String>(
                  dataSource: data,
                  xValueMapper: (SalesData sales, _) => sales.month,
                  yValueMapper: (SalesData sales, _) => sales.sales,
                  name: 'Weight',
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
          Row(
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
                                  Text("Weight"),
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
                                  hintText: 'kg',
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
                      data.add(
                          SalesData(formattedate(dater), double.parse(weight)));
                      //print(data[0].month+data[0].sales.toString());
                    });
                  },
                  icon: Icon(Icons.add))
            ],
          ),
          SizedBox(
            height: h * 0.01,
          ),
          historyrecord(DateTime.now(), '1726')
        ],
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
  String time = date.hour.toString() + ":" + date.minute.toString();
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
          Text(
            time,
            style: TextStyle(fontWeight: FontWeight.w300),
          )
        ],
      ),
      Text(
        cal + ' kcal',
        style: TextStyle(fontWeight: FontWeight.w500),
      )
    ],
  );
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}
