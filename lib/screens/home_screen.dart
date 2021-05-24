// import 'package:covisafe/models/region.dart';
import 'package:covisafe/models/summary.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covisafe/widgets/pie_chart.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Summary covidSummary;
  bool isLoading = false;

  num total;
  num confirmedCasesIndian;
  num confirmedCasesForeign;
  num discharged;
  num deaths;
  num confirmedButLocationUnidentified;

  loadSummaryData() async {
    setState(() {
      isLoading = true;
    });
    covidSummary = await Summary.getSummaryData();
    total = covidSummary.total;
    confirmedCasesIndian = covidSummary.confirmedCasesIndian;
    confirmedCasesForeign = covidSummary.confirmedCasesForeign;
    discharged = covidSummary.discharged;
    deaths = covidSummary.deaths;
    confirmedButLocationUnidentified =
        covidSummary.confirmedButLocationUnidentified;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadSummaryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : HomeScreenPieChart(
                seriesList: _createSampleData(),
                animate: true,
              ));
  }

  List<charts.Series<PieStats, String>> _createSampleData() {
    final data = [
      // new PieStats('Total', total),
      new PieStats(
          'Confirmed Indians', confirmedCasesIndian, Color(0xFF000023)),
      new PieStats(
          'Confirmed Foreigners', confirmedCasesForeign, Color(0xFFFF0000)),
      new PieStats('Discharged', discharged, Color(0xFF00FFFF)),
      new PieStats('Deaths', deaths, Color(0xFF003143)),
      // new PieStats('Confirmed But Location Unidentified',
      //     confirmedButLocationUnidentified),
    ];

    return [
      new charts.Series<PieStats, String>(
        id: 'Covid Summary',
        data: data,
        domainFn: (PieStats stat, _) => stat.title,
        measureFn: (PieStats stat, _) => stat.count,
        colorFn: (PieStats stat, _) =>
            charts.ColorUtil.fromDartColor(stat.color),
        labelAccessorFn: (PieStats row, _) => '${row.count}',
      )
    ];
  }
}

class PieStats {
  final String title;
  final num count;
  final Color color;

  PieStats(this.title, this.count, this.color);
}
