import 'dart:convert';

import 'package:boksl_subway/models/ResRealtimeArrival.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyDropdownWithTexts extends StatefulWidget {
  @override
  _MyDropdownWithTextsState createState() => _MyDropdownWithTextsState();
}

class _MyDropdownWithTextsState extends State<MyDropdownWithTexts> {
  String dropdownValue = '';
  ResRealtimeArrival? resRealtimeArrival;

  final List<MapEntry<String, String>> items = [
    const MapEntry('', '-- 선택하세요 --'),
    const MapEntry('사당', '사당'),
    const MapEntry('광화문', '광화문'),
    const MapEntry('용산', '용산'),
    const MapEntry('고속터미널', '고속터미널'),
    const MapEntry('수원', '수원'),
  ];

  Future<ResRealtimeArrival?> fetchDataFromApi(int start, int end) async {
    final response = await http.get(Uri.parse(
        'http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/$start/$end/$dropdownValue'));
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
          ResRealtimeArrival? additionalResRealtimeArrival =
              await fetchDataFromApi(start, start + 4);
          if (additionalResRealtimeArrival != null) {
            tempResRealtimeArrival.realtimeArrivalList
                .addAll(additionalResRealtimeArrival.realtimeArrivalList);
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
    final arrival = resRealtimeArrival;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width, // 화면의 넓이로 설정
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: items.map<DropdownMenuItem<String>>(
                      (MapEntry<String, String> item) {
                    return DropdownMenuItem<String>(
                      value: item.key,
                      child: Text(item.value),
                    );
                  }).toList(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (dropdownValue.isEmpty) {
                    showWarningDialog(context);
                    return;
                  }
                  print('dropdownValue: $dropdownValue');
                  fetchData();
                });
              },
              child: const Text('확인'),
            ),
          ],
        ),
        Expanded(
          child: arrival != null
              ? ListView.builder(
                  itemCount: arrival.realtimeArrivalList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          '${arrival.realtimeArrivalList[index].subwayId}  ${arrival.realtimeArrivalList[index].trainLineNm}'),
                      subtitle: Text(
                          '${arrival.realtimeArrivalList[index].arvlMsg2}  ${arrival.realtimeArrivalList[index].arvlMsg3}'),
                    );
                  },
                )
              : Container(),
        ),
      ],
    );
  }
}
