import 'dart:convert';

import 'package:boksl_subway/models/Station.dart';
import 'package:flutter/services.dart';

class Helper {
  static Future<List<Station>> readStationList() async {
    final String response = await rootBundle.loadString('stationList.json');
    final data = await json.decode(response) as List;

    var stationList = data.map((json) => Station.fromJson(json)).toList();

    List<Station> sortedStationList = List<Station>.from(stationList).where((_element) {
      Set<String> linesToCheck = ["인천", "용인경전철", "의정부경전철", "김포도시철도", "신림선"].toSet();
      return !linesToCheck.any((line) => _element.lineNum.startsWith(line));
    }).toList();

    sortedStationList.sort((a, b) {
      int compare = a.stationNm.compareTo(b.stationNm);
      if (compare != 0) return compare;
      return a.lineNum.compareTo(b.lineNum);
    });

    return sortedStationList;
  }

}
