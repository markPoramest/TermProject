import 'package:flutter/material.dart';
import 'login_button/twiiter.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter/services.dart';
import 'package:term_project/HomePage.dart';
class HomeBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeBody> {
  static final TwitterLogin twitterLogin = TwitterLogin(
    consumerKey: 'V6WhIk4MThLDHOZffp5ePjhxb',
    consumerSecret: '0mBgQEhDmlCJYFiEuzv49bwauCKzvBHh7yg2ph5QksMNxHTaOQ',
  );
  String _title = "";

  void _login() async {
    final TwitterLoginResult result = await twitterLogin.authorize();
    String Message;
    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        Message = 'ยินดีต้อนรับคุณ ${result.session.username}';
        break;
      case TwitterLoginStatus.cancelledByUser:
        Message = 'Login cancelled by user.';
        break;
      case TwitterLoginStatus.error:
        Message = 'Login error: ${result.errorMessage}';
        break;
    }

    setState(() {
      _title = Message;
      print('tile :::::' + _title);
    });
  }

  void _logout() async {
    await twitterLogin.logOut();

    setState(() {
      _title = "";
    });
  }

  final MethodChannel _channel = const MethodChannel('flutter_share_me');

  Future<String> shareToTwitter({String msg = '', String url = ''}) async {
    final Map<String, Object> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    dynamic result;
    try {
      result = await _channel.invokeMethod('shareTwitter', arguments);
    } catch (e) {
      return "false";
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Image.asset('assets/images/logo2.png', height: 150,),
        ),
        Container(
            padding: EdgeInsets.only(bottom: 20),
            child: _title.isEmpty ? loginUI() : mainUI()
        )
      ],
    );
  }

  Widget loginUI() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 30.0),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              "เข้าสุ่ระบบด้วยบัญชี Twitter ของคุณ"
                  "               ",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TwitterSignInButton(
            onPressed: _login,
          ),
        ],
      ),
    );
  }
  final TextEditingController _bullywordController = TextEditingController();
  Color color1 = HexColor("ffcde8");
  Widget mainUI() {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child : Text(_title, style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white
              ), textAlign: TextAlign.center,),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              width: 300,
              child: TextField(
                controller: _bullywordController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: color1,
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: color1)),
                    labelText: 'กรอกประโยคที่ต้องการ Tweet'),
              ),
            ),
            RaisedButton(
              child: Text('share to twitter'),
              onPressed: () async {
                var response = await FlutterShareMe().shareToTwitter(
                    url: 'https://github.com/lizhuoyuan',
                    msg: 'ไอควาย กูแค่เทสเฉยๆ');
                if (response == 'success') {
                  print('navigate success');
                }
              },
            ),
            RaisedButton(
              child: Text('Log out'),
              onPressed: _logout,
            ),
          ],
        )
    );
  }

}
