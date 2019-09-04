import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class BellBlock {
  final String dotw;
  final String period;
  final Duration timeBegin;
  final Duration timeEnd;

  BellBlock({this.dotw, this.period, this.timeBegin, this.timeEnd});

  factory BellBlock.fromJson(Map<String, dynamic> json) {
    final Duration _timeBegin = toDuration(json['time_begin']);
    final Duration _timeEnd = toDuration(json['time_end']);

    return BellBlock(
      dotw: json['dotw'] as String,
      period: json['period'] as String,
      timeBegin: _timeBegin,
      timeEnd: _timeEnd,
    );
  }

  static Duration toDuration(String _durationStr) {
//    String _durationStr = json['time_begin'];
    var _durationArray = _durationStr.split(":");
    var _duration = Duration(
      hours: int.parse(_durationArray[0]),
      minutes: int.parse(_durationArray[1]),
      seconds: int.parse(_durationArray[2]),
    );
    return _duration;
  }
}

Future<String> loadBellBlocks() async {
  return await rootBundle.loadString('json/bell.json');
}

Future<Map<String, dynamic>> parseBellBlocks(String data) async {
  final days = await jsonDecode(data);
  // days: map of "MONDAY" -> list of blocks
  for (var key in days.keys) {
    var blocks = days[key];
    var newList = List<BellBlock>();
    for (var block in blocks) {
      var bellBlock = BellBlock.fromJson(block);
//      print(bellBlock);
      newList.add(bellBlock);
    }
    days[key] = newList;
  }

  return days;
}

Future<Map<String, dynamic>> fetchBellBlocks() async {
  final data = await loadBellBlocks();
  return parseBellBlocks(data);
}
