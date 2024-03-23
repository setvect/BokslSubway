import 'package:boksl_subway/widgets/Favorites.dart';
import 'package:boksl_subway/widgets/Help.dart';
import 'package:boksl_subway/widgets/StationSearch.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(MaterialApp(
    home: BokslSubwayMain(),
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
  ));
}

class BokslSubwayMain extends StatefulWidget {
  const BokslSubwayMain({super.key});

  @override
  _BokslSubwayMainState createState() => _BokslSubwayMainState();
}

class _BokslSubwayMainState extends State<BokslSubwayMain> {
  final StationSearch _stationSearch = StationSearch();
  final Favorites _favorites = Favorites();
  final Help _help = Help();

  Widget? _currentWidget;

  @override
  void initState() {
    super.initState();
    _currentWidget = _stationSearch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('수도권 지하철 실시간 도착 안내'),
      ),
      body: Column(
        children: <Widget>[
          // Your custom bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: _currentWidget == _stationSearch ? Colors.yellow : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentWidget = _stationSearch;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.star, color: _currentWidget == _favorites ? Colors.yellow : Colors.grey),
                onPressed: () {
                  setState(() {
                    _currentWidget = _favorites;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.help, color: _currentWidget == _help ? Colors.yellow : Colors.grey),
                onPressed: () {
                  setState(() {
                    _currentWidget = _help;
                  });
                },
              ),
            ],
          ),
          // Rest of your body content
          Expanded(
            child: Center(
              child: _currentWidget,
            ),
          ),
        ],
      ),
    );
  }
}
