import 'package:flutter/material.dart';
import 'HomeBody.dart';
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
Color color1 = HexColor("7aabdd");
class MyHomePage1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyHomePage1> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(
            "",
            style: TextStyle(color: Colors.amber),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,),
        backgroundColor: color1,
        body: SingleChildScrollView(
            child: HomeBody()
        )

    );
  }
}