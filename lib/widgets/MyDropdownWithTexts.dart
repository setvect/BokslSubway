import 'dart:convert';

import 'package:boksl_subway/models/ResRealtimeArrival.dart';
import 'package:boksl_subway/models/Station.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class MyDropdownWithTexts extends StatefulWidget {
  @override
  _MyDropdownWithTextsState createState() => _MyDropdownWithTextsState();
}

class _MyDropdownWithTextsState extends State<MyDropdownWithTexts> {
  String stationName = '';
  ResRealtimeArrival? resRealtimeArrival;

  @override
  void initState() {
    super.initState();

    readStationList().then((List<Station> stationList) {
      print('stationList: ${stationList.length}');
    });
  }

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

  // 역정보 읽어 오기
  Future<List<Station>> readStationList() async {
    final String response = await rootBundle.loadString('stationList.json');
    final data = await json.decode(response) as List;
    return data.map((json) => Station.fromJson(json)).toList();
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
    final arrival = resRealtimeArrival;

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
                    labelText: '값을 입력하세요',
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: arrival != null
              ? ListView.builder(
                  itemCount: arrival.realtimeArrivalList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${arrival.realtimeArrivalList[index].subwayId}  ${arrival.realtimeArrivalList[index].trainLineNm}'),
                      subtitle: Text('${arrival.realtimeArrivalList[index].arvlMsg2}  ${arrival.realtimeArrivalList[index].arvlMsg3}'),
                    );
                  },
                )
              : Container(),
        ),
      ],
    );
  }
}
