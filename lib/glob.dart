library muddle.glob;

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './api.dart' as api;

String loginEmail = '';
String loginPass = '';

Map currentFilters = {"filters": [], "ingredients": []};

List ingredients = [];
List recipes = [];
List filters = [];

//final FirebaseAuth auth = FirebaseAuth.instance;
final secureStore = new FlutterSecureStorage();

width(context, double per) {
  return (MediaQuery.of(context).size.width * per);
}

height(context, double per) {
  return (MediaQuery.of(context).size.height * per);
}

pushMember(context, page) {
  Navigator.of(context).push(new MaterialPageRoute(builder: (context) => page));
}

//LOGIN INITIALIZATION
//FirebaseUser user = await FirebaseAuth.instance.currentUser();
//print('is logged in: ' + user.toString());
//if (user != null) {
// } else {
//   loginEmail = await secureStore.read(key: 'loginEmail');
//   loginPass = await secureStore.read(key: 'loginPass');
// }

initializeApp() async {
  String checkFilters = await checkStorage('filters');
  buildArray(checkFilters, 'filters');

  String checkIngredients = await checkStorage('ingredients');
  buildArray(checkIngredients, 'ingredients');
}

checkStorage(String title) async {
  String checkForDoc = await read(title, -1);
  String getData;

  if (checkForDoc == 'err' || checkForDoc == 'old') {
    if (title == 'filters') getData = await api.filters();
    if (title == 'ingredients') getData = await api.ingredients();

    if (getData != 'err') {
      save(title, getData);
      return getData;
    }
  } else {
    print(checkForDoc);
    return checkForDoc;
  }
}

buildArray(String allItems, String type) {
  var json = jsonDecode(allItems);

  print('building ' + type);
  if (type == 'filters') filters = [];
  if (type == 'recipes') recipes = [];
  if (type == 'ingredients') ingredients = [];

  for (var item in json) {
    if (type == 'filters') filters.add(item);
    if (type == 'recipes') recipes.add(item);
    if (type == 'ingredients') ingredients.add(item);
  }
}

read(filename, old) async {
  print('READ');
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/' + filename + '.txt');

    var lastModified = await file.lastModified();
    var age = DateTime.now().difference(lastModified).inDays;

    if (age > old) return 'old';

    String text = await file.readAsString();
    return text;
  } catch (e) {
    print("Couldn't read file");
    return 'err';
  }
}

save(filename, data) async {
  print('SAVE');
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/' + filename + '.txt');
  final text = data;
  await file.writeAsString(text);
  return true;
}

saveCredentials(email, pass) async {
  Map<String, String> allValues = await secureStore.readAll();
  print(allValues);

  await secureStore.write(key: 'loginEmail', value: email);
  await secureStore.write(key: 'loginPass', value: pass);
}

BoxDecoration boxDec(color1, color2, double border, double shadow) {
  return BoxDecoration(
    boxShadow: [
      new BoxShadow(
        color: Color(0x88888888),
        offset: new Offset(0.0, 0.0),
        blurRadius: shadow,
      )
    ],
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight, // 10% of the width, so there are ten blinds.
      colors: [color1, color2],
      tileMode: TileMode.clamp, // repeats the gradient over the canvas
    ),
    borderRadius: BorderRadius.circular(border),
  );
}

TextStyle headStyle(int color) {
  return TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      color: Color(color),
      fontSize: 30.0);
}

TextStyle subHeadStyle(int color) {
  return TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      color: Color(color),
      fontSize: 23.0);
}

TextStyle textStyle = TextStyle(
    fontFamily: 'Montserrat', color: Color(0xdd333333), fontSize: 16.0);

// ThemeData primaryTheme = ThemeData(brightness: Brightness.dark);
ThemeData primary = ThemeData(
  // Define the default Brightness and Colors
  brightness: Brightness.light,
  primaryColor: Colors.white,
  accentColor: Colors.black,
);
