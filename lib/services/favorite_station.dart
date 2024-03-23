import 'dart:convert';

import 'package:boksl_subway/helper/helper.dart';
import 'package:boksl_subway/models/station.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String favoriteStationList = "favoriteStationList";

class FavoriteStationService {
  static Future<void> save(Station station) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var currentList = await list();

    if (currentList.where((element) {
      var nameMatch = element.stationNm == station.stationNm;
      var lineMatch = element.lineNum == station.lineNum;
      return nameMatch && lineMatch;
    }).isEmpty) {
      currentList.add(station);
    }

    Helper.sortStationList(currentList);
    prefs.setString(favoriteStationList, jsonEncode(currentList.map((e) => jsonEncode(e.toJson())).toList()));
  }

  static Future<void> remove(Station station) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var currentList = await list();
    currentList.removeWhere((element) {
      var nameMatch = element.stationNm == station.stationNm;
      var lineMatch = element.lineNum == station.lineNum;
      return nameMatch && lineMatch;
    });
    prefs.setString(favoriteStationList, jsonEncode(currentList.map((e) => jsonEncode(e.toJson())).toList()));
  }

  static Future<List<Station>> list() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Station> saveList = [];
    var currentList = prefs.getString(favoriteStationList);
    if (currentList != null) {
      List<String> list = jsonDecode(currentList).cast<String>();
      saveList = list.map((e) => Station.fromJson(jsonDecode(e))).toList();
    }
    return saveList;
  }
}