import 'package:flutter/material.dart';
import './glob.dart' as glob;
import './filters.dart' as filter;
import './search.dart' as results;

void main() async {
  await glob.initializeApp();

  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHome(),
    ),
  );
}

class MyHome extends StatefulWidget {
  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<MyHome> {
  var nameOfApp = "Muddle";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameOfApp, style: glob.headStyle(0xbbefefef)),
      ),
      body: Container(
        child: Center(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(50),
                  child: RaisedButton(
                    child: Text(
                      'By Ingredient',
                      style: glob.subHeadStyle(0xffefefef),
                    ),
                    color: Theme.of(context).accentColor,
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      glob.pushMember(context, filter.Filters());
                      // glob.pushMember(context, results.SearchResults());
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(50),
                  child: RaisedButton(
                    child: Text(
                      'Refresh Data',
                      style: glob.subHeadStyle(0xffefefef),
                    ),
                    color: Colors.deepOrange,
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      glob.initializeApp();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
