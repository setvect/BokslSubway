import 'dart:convert';

import 'package:boksl_subway/constant.dart';
import 'package:boksl_subway/helper/helper.dart';
import 'package:boksl_subway/models/ResRealtimeArrival.dart';
import 'package:boksl_subway/models/Station.dart';
import 'package:boksl_subway/util/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyDropdownWithTexts extends StatefulWidget {
  @override
  _MyDropdownWithTextsState createState() => _MyDropdownWithTextsState();
}

class _MyDropdownWithTextsState extends State<MyDropdownWithTexts> {
  String stationName = '';
  ResRealtimeArrival? resRealtimeArrival;
  List<Station> stationList = [];
  List<Station> filteredStationList = [];

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    super.initState();
    Helper.readStationList().then((list) {
      setState(() {
        this.stationList = list;
        this.filteredStationList = List.from(list);
      });
    });
  }

  // 역정보 읽어 오기
  void onButtonPressed() {
    setState(() {
      if (stationName.isEmpty) {
        showWarningDialog(context);
        return;
      }
      print('dropdownValue: $stationName');
      fetchData();
    });
  }

  final FocusNode _focusNode = FocusNode();

  Future<ResRealtimeArrival?> fetchDataFromApi(int start, int end) async {
    final response =
        await http.get(Uri.parse('http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/$start/$end/$stationName'));
    if (response.statusCode == 200) {
      return ResRealtimeArrival.fromJson(jsonDecode(response.body));
    } else {
      if (mounted) {
        showApiCallErrorDialog(context);
      }
    }
    return null;
  }

  void fetchData() async {
    ResRealtimeArrival? tempResRealtimeArrival = await fetchDataFromApi(1, 5);
    if (tempResRealtimeArrival != null) {
      int total = tempResRealtimeArrival.errorMessage.total;
      if (total > 5) {
        int start = 6;
        while (start <= total) {
          ResRealtimeArrival? additionalResRealtimeArrival = await fetchDataFromApi(start, start + 4);
          if (additionalResRealtimeArrival != null) {
            tempResRealtimeArrival.realtimeArrivalList.addAll(additionalResRealtimeArrival.realtimeArrivalList);
          }
          start += 5;
        }
      }
      setState(() {
        resRealtimeArrival = tempResRealtimeArrival;
        resRealtimeArrival?.realtimeArrivalList.sort((a, b) {
          return a.subwayId.compareTo(b.subwayId);
        });
      });
      print('Parsed data: ${resRealtimeArrival?.realtimeArrivalList.length}');
    }
  }

  void showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('경고'),
          content: const Text('값을 선택해주세요.'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showApiCallErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('경고'),
          content: const Text('값을 선택해주세요.'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final realtimeArrivalList = resRealtimeArrival?.realtimeArrivalList;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width, // 화면의 넓이로 설정
                child: TextField(
                  focusNode: _focusNode,
                  onChanged: (String? newValue) {
                    setState(() {
                      stationName = newValue!;
                      filteredStationList = stationList.where((station) {
                        var contains = station.stationNm.contains(stationName);
                        var chosung = getChosung(station.stationNm).contains(getChosung(stationName));
                        return contains || chosung;
                      }).toList();
                    });
                  },
                  onSubmitted: (String? value) {
                    setState(() {
                      stationName = value!;
                      onButtonPressed();
                      _focusNode.requestFocus();
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '역 이름을 입력하세요.',
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: filteredStationList.isNotEmpty
              ? ListView.builder(
                  itemCount: filteredStationList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredStationList[index].stationNm),
                      subtitle: Text(filteredStationList[index].lineNum,
                          style: TextStyle(
                            color: hexToColor(BokslSubwayConstant.lineColors[filteredStationList[index].lineNum]!),
                          )),
                      onTap: () {
                        setState(() {
                          stationName = filteredStationList[index].stationNm;
                          onButtonPressed();
                        });
                      },
                    );
                  },
                )
              : Container(),
        ),
      ],
    );
  }
}
