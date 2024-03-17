import 'dart:convert';

import 'package:boksl_subway/models/res_realtime_arrival.dart';
import 'package:boksl_subway/models/station.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArrivalInfo extends StatefulWidget {
  final Station station;

  ArrivalInfo({required this.station});

  @override
  _ArrivalInfoState createState() => _ArrivalInfoState();
}

class _ArrivalInfoState extends State<ArrivalInfo> {
  ResRealtimeArrival? resRealtimeArrival;

  @override
  void initState() {
    super.initState();
    getArrivalTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.stationNm),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: resRealtimeArrival?.realtimeArrivalList.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(resRealtimeArrival?.realtimeArrivalList[index].trainLineNm ?? ''),
                subtitle: Text(resRealtimeArrival?.realtimeArrivalList[index].arvlMsg2 ?? ''),
              ),
            );
          },
        )
      ),
    );
  }

  Future<ResRealtimeArrival?> fetchArrivalTime(int start, int end) async {
    final response =
    await http.get(Uri.parse('http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/$start/$end/${widget.station.stationNm}'));
    if (response.statusCode == 200) {
      return ResRealtimeArrival.fromJson(jsonDecode(response.body));
    } else {
      if (mounted) {
        showApiCallErrorDialog(context);
      }
    }
    return null;
  }

  void getArrivalTime() async {
    ResRealtimeArrival? tempResRealtimeArrival = await fetchArrivalTime(1, 5);
    if (tempResRealtimeArrival != null) {
      int total = tempResRealtimeArrival.errorMessage.total;
      if (total > 5) {
        int start = 6;
        while (start <= total) {
          ResRealtimeArrival? additionalResRealtimeArrival = await fetchArrivalTime(start, start + 4);
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
}
