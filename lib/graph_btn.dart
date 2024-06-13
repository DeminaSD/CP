import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphButton extends StatelessWidget {
  final String text;
  final List<List<double> Function()> lines;
  final List<List<List<double>> Function()>? scatters;

  const GraphButton({
    super.key,
    required this.text,
    required this.lines,
    this.scatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          barrierColor: Colors.black,
          context: context,
          builder: (context) {
            List<CartesianSeries<dynamic, dynamic>> series = [];
            for (var e in lines) {
              series.add(
                LineSeries(
                  xValueMapper: (datum, index) => index,
                  yValueMapper: (datum, index) => datum,
                  dataSource: e(),
                ),
              );
            }

            if (scatters != null) {
              for (var e in scatters!) {
                series.add(
                  ScatterSeries(
                    dataSource: e(),
                    xValueMapper: (datum, index) => datum[0],
                    yValueMapper: (datum, index) => datum[1],
                  ),
                );
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 100,
              ),
              child: SfCartesianChart(
                series: series,
              ),
            );
          },
        );
      },
      child: Text(text),
    );
  }
}
