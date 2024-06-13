import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

double td(List<double> data, List<double> time) {
  return (time[time.length - 1] - time[0]) / data.length;
}

List<double> angle(List<double> array, List<double> time) {
  List<double> res = [];
  final tD = td(array, time);
  double an = 0;
  for (var e in array) {
    an += e * tD;
    res.add(an);
  }

  return res;
}

List<double> angToDeg(List<double> array) {
  List<double> degs = [];

  for (var e in array) {
    degs.add(e * 180 / pi);
  }
  return degs;
}

List<List<double>> findP(List<double> data) {
  final res = _findP(data);

  final min = _findP(
    data
        .map(
          (e) => -e,
        )
        .toList(),
  );
  res.addAll(
    min.map(
      (e) {
        e[1] = -e[1];
        return e;
      },
    ).toList(),
  );

  List<List<double>> sorted = [];

  for (int i = 0; i < res.length; i++) {
    for (int j = 0; j < res.length - 1; j++) {
      if (res[j][0] > res[j + 1][0]) {
        final num = res[j];
        res[j] = res[j + 1];
        res[j + 1] = num;
      }
    }
  }

  if (res.isNotEmpty) {
    int j = 0;
    sorted.add(res[j]);
    for (var i = 1; i < res.length; i++) {
      double div = (res[i][1] - res[j][1]).abs();
      if (div >= 10) {
        sorted.add(res[i]);
        j = i;
      }
    }
  }

  if (sorted.isNotEmpty) return sorted;
  return res;
}

List<List<double>> _findP(List<double> data) {
  List<List<double>> res = [];
  final list = findPeaks(Array(data));

  if (list.length > 1) {
    for (var i = 0; i < list[0].length; i++) {
      res.add([list[0][i], list[1][i]]);
    }
  }

  return res;
}

List<double> exponentialSmoothing(List<double> data, double alpha) {
  final smoothedData = [data[0]];
  for (int i = 1; i < data.length; i++) {
    smoothedData.add(alpha * data[i] + (1 - alpha) * smoothedData[i - 1]);
  }
  return smoothedData;
}

List<double> movingAverage(List<double> data, int windowSize) {
  return data.asMap().entries.map((entry) {
    int index = entry.key;
    int start = (index - windowSize + 1).clamp(0, data.length);
    int end = index + 1;
    List<double> subset = data.sublist(start, end);
    double sum = subset.reduce((acc, curr) => acc + curr);
    return sum / subset.length;
  }).toList();
}
