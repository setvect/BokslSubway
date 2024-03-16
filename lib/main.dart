import 'package:boksl_subway/widgets/MyDropdownWithTexts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: BokslSubwayMain(),
  ));
}
class BokslSubwayMain extends StatefulWidget {
  const BokslSubwayMain({super.key});

  @override
  _BokslSubwayMainState createState() => _BokslSubwayMainState();
}

class _BokslSubwayMainState extends State<BokslSubwayMain> {

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
                  icon: Icon(Icons.home),
                  onPressed: () {
                    // Handle your logic here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Handle your logic here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    // Handle your logic here
                  },
                ),
              ],
            ),
            // Rest of your body content
            Expanded(
              child: Center(
                child: MyDropdownWithTexts(),
              ),
            ),
          ],
        ),
    );
  }
}
