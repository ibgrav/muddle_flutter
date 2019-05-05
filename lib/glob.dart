library muddle.glob;

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String entries =
    'https://cdn.contentful.com/spaces/2epw9eof6jxp/environments/master/entries';
String token = '?access_token=O8ASDr6Eq2vzwsE6v57wVfNEd-BpGfFMT0BcwhU9EwQ';

String loginEmail = '';
String loginPass = '';

Map currentFilters = {};

List ingredients = [];
List recipes = [];
List moods = [];
List flavors = [];
List complexities = [];

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
  //GET INGREDIENTS
  String checkForIngs = await read('ingredients', -1);

  if (checkForIngs == 'err' || checkForIngs == 'old') {
    String allIngs = await getHttp(ingredientsAPI());
    if (allIngs != 'err') {
      save('ingredients', allIngs);
      buildIngredients(allIngs);
    }
  } else {
      print(checkForIngs);
      buildIngredients(checkForIngs);
  }

  //GET FILTERS
  String checkForFilters = await read('filters', -1);

  if (checkForFilters == 'err' || checkForFilters == 'old') {
    String allFilters = await getHttp(filterAPI());
    if (allFilters != 'err') {
      save('ingredients', allFilters);
      buildFilters(allFilters);
    }
  } else {
    print(checkForIngs);
    buildFilters(checkForIngs);
  }

  //GET RECIPES
  String checkForRecipes = await read('filters', -1);

  if (checkForRecipes == 'err' || checkForRecipes == 'old') {
    String allRecipes = await getHttp(recipesAPI());
    if (allRecipes != 'err') {
      save('recipes', allRecipes);
      buildRecipes(allRecipes);
    }
  } else {
    print(checkForRecipes);
    buildFilters(checkForRecipes);
  }

  String recipesByIngrediens = await getHttp(recipeByIngredientAPI(['1a0ceM8qAHlIG4v0OaOlsk','7x9vzy5usZoLVk1Qv3dtet']));
  print(recipesByIngrediens);
}

String idToName(String data, String id){
  Map json = jsonDecode(data);

  for(Map entry in json['includes']['Entry']){
    if(entry['sys']['id'] == id) return entry['fields']['name'];
  }

  return null;
}

String nameToId(String data, String name){
  Map json = jsonDecode(data);

  for(Map entry in json['includes']['Entry']){
    if(entry['fields']['name'] == name) return entry['sys']['id'];
  }

  return null;
}

buildFilters(String allFilters) {
  Map json = jsonDecode(allFilters);

  moods = [];
  flavors = [];
  complexities = [];

  for (var filter in json['items']) {
    if (filter['fields']['type'] == 'mood') moods.add(filter['fields']['name']);

    if (filter['fields']['type'] == 'flavor')
      flavors.add(filter['fields']['name']);

    if (filter['fields']['type'] == 'complexity')
      complexities.add(filter['fields']['name']);
  }

  print(moods);
  print(flavors);
  print(complexities);
}

buildIngredients(String allIngs){
  Map json = jsonDecode(allIngs);

  ingredients = [];

  for (var ingredient in json['items']) {
    ingredients.add(ingredient['fields']['name']);
  }

  print(ingredients);
}

buildRecipes(String allRecipes){
  Map json = jsonDecode(allRecipes);

  recipes = [];

  for (var recipe in json['items']) {
    recipes.add(recipe['fields']);
  }

  print(recipes);
}

getHttp(url) async {
  print('GET - ' + url);
  try {
    Response response = await Dio().get(url);
    String data = response.toString();
    print('GET success');
    return data;
  } catch (e) {
    print(e);
    return 'err';
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

String recipeByIngredientAPI(List params){
  int counter = 0;
  String queryParams = '';
  for(String param in params){
    counter++;
    if(counter >= params.length) queryParams += param;
    else queryParams += param + ',';
  }

  return entries + token + table('recipes') + select(['name', 'ingredients', 'steps']) + '&fields.ingredients.sys.id[in]=' + queryParams;
}

String recipesAPI() {
  return entries + token + table('recipes') + select(['name', 'ingredients', 'steps']);
}

String filterAPI() {
  return entries + token + table('filters') + select(['name', 'type']);
}

String ingredientsAPI() {
  return entries + token + table('ingredients') + select(['name', 'type']);
}

String select(fields) {
  String value = '&select=sys.id,';
  int count = 0;

  for (String field in fields) {
    print(field);

    count++;
    if (count >= fields.length)
      value += 'fields.' + field;
    else
      value += 'fields.' + field + ',';
  }
  return value;
}

String search(val) {
  return '&query=' + val;
}

String table(name) {
  return '&content_type=' + name;
}

String order(by) {
  return '&order=fields.' + by;
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
