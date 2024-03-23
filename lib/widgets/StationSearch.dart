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
  Map<String, bool> favoriteStatus = {};

  @override
  void initState() {
    super.initState();
    Helper.readStationList().then((list) {
      setState(() {
        this.stationList = list;
        this.filteredStationList = List.from(list);
      });
    });
    _loadFavorites();
  }

  void _loadFavorites() async {
    var favorites = await FavoriteStationService.list();
    Map<String, bool> localFavorites = {};
    for (var station in favorites) {
      String key = "${station.stationNm}_${station.lineNum}";
      localFavorites[key] = true;
    }
    setState(() {
      favoriteStatus = localFavorites;
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
                var station = filteredStationList[index];
                // 즐겨찾기 상태 확인
                bool isFavorite = favoriteStatus["${station.stationNm}_${station.lineNum}"] ?? false;

                return ListTile(
                  title: Text(station.stationNm),
                  subtitle: Text(
                    station.lineNum,
                    style: TextStyle(
                      color: hexToColor(BokslSubwayConstant.lineColors[station.lineNum]!),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      stationName = station.stationNm;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArrivalInfo(station: station)),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                    onPressed: () async {
                      String key = "${station.stationNm}_${station.lineNum}";
                      if (isFavorite) {
                        await FavoriteStationService.remove(station);
                      } else {
                        await FavoriteStationService.save(station);
                      }
                      // 즐겨찾기 상태 업데이트
                      setState(() {
                        favoriteStatus[key] = !isFavorite;
                      });
                    },
                  ),
                );
              }
            },
          )
          ,
        ),
      ],
    );
  }
}
