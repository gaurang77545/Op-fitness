import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CalorieIntakeChart extends StatefulWidget {
  @override
  State<CalorieIntakeChart> createState() => _CalorieIntakeChartState();
}

class _CalorieIntakeChartState extends State<CalorieIntakeChart> {
  double h = 0.0, w = 0.0;
  double kh = 1 / 759.2727272727273;
  double kw = 1 / 392.72727272727275;
  List<SalesData> data = [
    SalesData('6 Jan', 35),
    SalesData('7 Jan', 28),
    SalesData('9 Jan', 34),
    SalesData('11 Jan', 32),
    SalesData('13 Jan', 40),
    SalesData('15 Jan', 40),
    SalesData('17 Jan', 40),
    SalesData('19 Jan', 40),
    SalesData('21 Jan', 40),
    SalesData('23 Jan', 40),

  ];

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
      body: Container(
        height: h*0.50,
        width: w,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Date'),edgeLabelPlacement: EdgeLabelPlacement.shift),
          primaryYAxis: NumericAxis(title: AxisTitle(text: 'Calorie Intake'),labelFormat: '{value}kcal',edgeLabelPlacement: EdgeLabelPlacement.shift),
         // title: ChartTitle(text: 'Body Fat Percentage(%)'),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<SalesData, String>>[
            LineSeries<SalesData, String>(  
              dataSource: data,
              xValueMapper: (SalesData sales, _) => sales.month,
              yValueMapper: (SalesData sales, _) => sales.sales,
              name: 'Calorie Intake',
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}
