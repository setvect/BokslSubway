import 'package:boksl_subway/constant.dart';
import 'package:boksl_subway/helper/helper.dart';
import 'package:boksl_subway/models/station.dart';
import 'package:boksl_subway/services/favorite_station.dart';
import 'package:boksl_subway/util/util.dart';
import 'package:boksl_subway/widgets/ArrivalInfo.dart';
import 'package:flutter/material.dart';

const String favoriteStationList = "favoriteStationList";

class StationSearch extends StatefulWidget {
  @override
  _StationSearchState createState() => _StationSearchState();
}

class _StationSearchState extends State<StationSearch> {
  String stationName = '';
  List<Station> stationList = [];
  List<Station> filteredStationList = [];

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

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
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
          child: ListView.builder(
            itemCount: filteredStationList.length,
            itemBuilder: (context, index) {
              if (filteredStationList.isEmpty) {
                return Container();
              } else {
                return ListTile(
                  title: Text(filteredStationList[index].stationNm),
                  subtitle: Text(filteredStationList[index].lineNum,
                      style: TextStyle(
                        color: hexToColor(BokslSubwayConstant.lineColors[filteredStationList[index].lineNum]!),
                      )),
                  onTap: () {
                    setState(() {
                      stationName = filteredStationList[index].stationNm;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArrivalInfo(station: filteredStationList[index])),
                    );
                  },
                  trailing: FutureBuilder<List<Station>>(
                    future: FavoriteStationService.list(),
                    builder: (BuildContext context, AsyncSnapshot<List<Station>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // 로딩 중일 때는 로딩 인디케이터를 표시
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error);
                      } else {
                        bool isFavorite = snapshot.data!.any((station) {
                          return station.stationNm == filteredStationList[index].stationNm &&
                              station.lineNum == filteredStationList[index].lineNum;
                        });

                        Icon icon = isFavorite ? Icon(Icons.star) : Icon(Icons.star_border);
                        Function onPressed = isFavorite
                            ? () => FavoriteStationService.remove(filteredStationList[index])
                            : () => FavoriteStationService.save(filteredStationList[index]);

                        return IconButton(
                          icon: icon,
                          onPressed: () {
                            onPressed();
                            setState(() {});
                          },
                        );
                      }
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
