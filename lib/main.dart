import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:gyroscope_example/functions.dart';
import 'package:gyroscope_example/graph_btn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const SafeArea(child: GyroscopeExample()),
    );
  }
}

// ignore: must_be_immutable
class GyroscopeExample extends StatefulWidget {
  const GyroscopeExample({super.key});

  @override
  State<GyroscopeExample> createState() => _GyroscopeExampleState();
}

class _GyroscopeExampleState extends State<GyroscopeExample> {
  List<GyroscopeEvent> _gyroscopeValues = [];
  List<double> wy = [];
  List<double> time = [];
  bool isStop = false;
  final controller = TextEditingController(text: '0.3');
  int moveCount = 0;

  late StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();

    _gyroscopeSubscription = gyroscopeEventStream(
      samplingPeriod: const Duration(milliseconds: 100),
    ).listen((event) {
      setState(() {
        _gyroscopeValues = [event];
        wy.add(event.y);
        time.add(DateTime.now().millisecondsSinceEpoch / 1000);
      });
    });
  }

  @override
  void dispose() {
    // Cancel the Gyroscope event subscription to prevent memory leaks
    _gyroscopeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    angleDeg() => angToDeg(angle(wy.toList(), time));
    smooth() => exponentialSmoothing(
        angleDeg(), double.tryParse(controller.text) ?? 0.3);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gyroscope counts: ${wy.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Divider(),
              if (_gyroscopeValues.isNotEmpty)
                Text(
                  'X: ${_gyroscopeValues[0].x.toStringAsFixed(2)}, '
                  'Y: ${_gyroscopeValues[0].y.toStringAsFixed(2)}, '
                  'Z: ${_gyroscopeValues[0].z.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                )
              else
                const Text('No data available', style: TextStyle(fontSize: 16)),
              const Divider(),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      wy = [];
                      time = [];
                      setState(() {});
                    },
                    child: const Text('Clear'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (!isStop) {
                        _gyroscopeSubscription.pause();
                      } else {
                        _gyroscopeSubscription.resume();
                      }
                      isStop = !isStop;
                    },
                    child: const Text('Start/Stop'),
                  ),
                ],
              ),
              const Divider(),
              GraphButton(
                text: 'Wy data',
                lines: [
                  () => wy.toList(),
                ],
              ),
              const Divider(),
              GraphButton(
                text: 'Angles',
                lines: [
                  () => angle(wy.toList(), time),
                ],
              ),
              const Divider(),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Экспонента сглаживания'),
                ),
                controller: controller,
              ),
              const Divider(),
              GraphButton(
                text: 'Exponential Smoothing and Peaks',
                lines: [
                  () => angleDeg(),
                  () => smooth(),
                ],
                scatters: [
                  () => findP(smooth()),
                  () => findP(angleDeg()),
                ],
              ),
              const Divider(),
              TextFormField(
                key: UniqueKey(),
                decoration: const InputDecoration(
                  label: Text('Количество движений'),
                ),
                initialValue: moveCount.toString(),
                readOnly: true,
              ),
              TextButton(
                onPressed: () {
                  final peaks = findP(smooth());
                  setState(() {
                    //moveCount = td(wy, time).toInt();
                    moveCount = (peaks.length - 1) ~/ 2;
                  });
                },
                child: const Text('Посчитать'),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
