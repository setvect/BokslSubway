import 'package:boksl_subway/constant.dart';
import 'package:boksl_subway/util/util.dart';
import 'package:boksl_subway/widgets/ArrivalInfo.dart';
import 'package:flutter/material.dart';
import 'package:boksl_subway/services/favorite_station.dart';
import 'package:boksl_subway/models/station.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  String stationName = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Station>>(
      future: FavoriteStationService.list(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var station = snapshot.data![index];
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
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await FavoriteStationService.remove(station);
                    setState(() {});
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}