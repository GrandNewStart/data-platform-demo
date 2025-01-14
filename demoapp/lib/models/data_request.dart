import 'dart:ffi';

import '../comm/app_state.dart';

class DataRequest {
  String id;
  String sender;
  List<String> queries;

  DataRequest(this.id, this.sender, this.queries);

  bool hasData() {
    var resultA = false;
    var resultB = false;
    var resultC = false;
    final records = AppState.instance!.records;
    for (var e in records) {
      for (var q in queries) {
        if (q.startsWith('A')) {
          if (e.name != 'A') continue;
          final value = q.split('==').last;
          resultA = value == e.value;
        }
        if (q.startsWith('B')) {
          if (e.name != 'B') continue;
          final value = q.split('==').last;
          resultB = value == e.value;
        }
        if (q.startsWith('C')) {
          if (e.name != 'C') continue;
          final min = int.parse(e.value.split(',').first);
          final max = int.parse(e.value.split(',').last);
          final subQueries = q.split(',');
          for (var sub in subQueries) {
            if (sub.contains('<=')) {
              final value = sub.split('<=').last;
              resultC = max <= int.parse(value);
            }
            if (sub.contains('>=')) {
              final value = sub.split('>=').last;
              resultC = min >= int.parse(value);
            }
          }
        }
      }
    }
    return resultA && resultB && resultC;
  }
}
