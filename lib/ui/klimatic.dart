import 'package:flutter/material.dart';
import "../utl/util.dart" as util;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityentered;

  Future _gotoNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
        new MaterialPageRoute<Map>(builder: (BuildContext context) {
          return new ChangeCity();
        })
    );
    if (results != null && results.containsKey('enter')){
      _cityentered = results['enter'];
      //print("From Menu Screen"+ results['enter'].toString());
    }
  }


  void showstuff() async {
    Map data = await getWeather(util.apiId, util.defaultCity);
    print(data['main'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Klimatic"),
        backgroundColor: Colors.indigo,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.menu), onPressed: () {
            _gotoNextScreen(context);
          })
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.png',
                height: 1200.0, width: 800, fit: BoxFit.fill),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 15.0, 15.0, 0.0),
            child: new Text(
              "${_cityentered == null ? util.defaultCity : _cityentered}",
              style: citystyle(),
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: Image.asset("images/light_rain.png"),
          ),
          //Comtainer for weather data
          new Container(
            //alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(50.0, 346.0, 0, 0),
            child: updateTempWidget(_cityentered),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String apiId, String city) async {
    String apiurl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${util.apiId}&units=metric';
    http.Response response = await http.get(apiurl);
    return jsonDecode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(util.apiId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          //this is where we get all of the json data,we setup widgets etc.
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      content['main']['temp'].toString() + " C",
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: new ListTile(
                      title: new Text(
                                "Humidity: ${content['main']['humidity'].toString()}\n"
                                "Min: ${content['main']['temp_min'].toString()} C\n"
                                "Max: ${content['main']['temp_max'].toString()} C",
                        style: new TextStyle(
                            color: Colors.white70,
                           ) ,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return new Container();
          }
        });
  }
}

class ChangeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.indigo,
          title: new Text("Change City"),
          centerTitle: true,
        ),
        body: new Stack(
          children: <Widget>[
            new Center(
              child: new Image.asset('images/white_snow.png',
                width: 490.0,
                height: 1200.0,
                fit: BoxFit.fill,
              ),
            ),
            new ListView(
              children: <Widget>[
                new ListTile(
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Enter City",
                    ),
                    controller: _cityFieldController,
                    keyboardType: TextInputType.text,
                  ),
                ),
                new ListTile(
                  title: new RaisedButton(onPressed:(){
                    Navigator.pop(context,{
                      'enter': _cityFieldController.text
                    });
                  },child: new Text('Get Weather'),
                  color: Colors.indigo,
                  textColor: Colors.white,)
                ),
              ],
            )
          ],
        )
    );

  }
}


TextStyle citystyle() {
  return new TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 20,
      fontStyle: FontStyle.italic);
}

TextStyle tempstyle() {
  return new TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 50.0);
}
