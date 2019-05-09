import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../util/utils.dart' as util;
//start with video 146

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityEntered = util.defaultCity;

  Future _goToNextScreen(BuildContext context) async{
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute<Map>(
        builder: (BuildContext context){
          return new Changecity();
        })
    );
    if(results != null  && results.containsKey('enter')){
      // print(results['enter'].toString());
      _cityEntered = results['enter'];
    }
  }
  void showStuff() async{
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Klimatic $_cityEntered'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () { _goToNextScreen(context); },
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/bg1.jpg', width: 490.00, height: 1000, fit: BoxFit.fitHeight),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0, 50, 40, 0),
            child: new Text(
              '${ _cityEntered == null ? util.defaultCity : _cityEntered }', 
              style: styleTextCity()),
          ),
          new Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
            child: new Image.asset('images/cloud1.png'),
          ),
          new Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(80, 460, 0, 0),
            child: updatTempWidget(_cityEntered),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String appid, String city) async {
    String apiURL = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appid&units=metric";
    http.Response response = await http.get(apiURL);
    return jsonDecode(response.body);
  }

  Widget updatTempWidget(String city){
    return new FutureBuilder(
      future: getWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
        // where we get the json data
        if(snapshot.hasData){
          Map content = snapshot.data;
          return new Container(
            alignment: Alignment.bottomCenter,
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: Text('${content['main']['temp'].toString()} °C', style: styleTextTemp(),),
                  subtitle: new ListTile(
                    title: Text(
                      "Humidity: ${content['main']['humidity'].toString()} % \n"
                      "Min: ${content['main']['temp_min'].toString()} °C \n"
                      "Max: ${content['main']['temp_max'].toString()} °C \n",
                      style: styleTextExtra(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else{
          return new Container();
        }
      });
  }
}

class Changecity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _cityFieldController = new TextEditingController();
        return Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.blueGrey,
            title: Text('Change city'),
            centerTitle: true,
          ),
          body: new Stack(
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  new Center(
                    child: new Image.asset('images/bg3.jpg', width: 490.00, height: 1000, fit: BoxFit.fitHeight),
                  ),
                  new ListView(
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.only(bottom: 40)),
                      new ListTile(
                        title: new TextField(
                          decoration: new InputDecoration(
                            labelText: "City name here",
                            hintText: 'Aa..'
                          ),
                          controller: _cityFieldController,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      new ListTile(
                        title: new FlatButton(
                          onPressed: () {
                            Navigator.pop(context, {
                              'enter': _cityFieldController.text
                            });
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text('Get weather!'),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          )
        );
  }
}

TextStyle styleTextCity() {
  return new TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white);
} 
TextStyle styleTextTemp() {
  return new TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white);
} 

TextStyle styleTextExtra() {
  return new TextStyle(fontSize: 18, fontWeight: FontWeight.w200, color: Colors.white);
} 