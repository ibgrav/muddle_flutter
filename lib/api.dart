library muddle.api;

import 'dart:convert';
import 'package:dio/dio.dart';

import './glob.dart' as glob;

String url = 'https://muddle.dev/';

filters() async {
  String data = await getHttp(url + 'filters');
  return data;
}

ingredients() async {
  String data = await getHttp(url + 'ingredients');
  return data;
}

getRecipe(String name) async {
  String data = await getHttp(url + 'recipes?name=' + name);
  return data;
}

searchRecipes() async {
  String apiUrl = url + 'recipes?_limit=100';

  if(glob.currentFilters['ingredients'].length > 0) {
    for(String filter in glob.currentFilters['ingredients']) {
      apiUrl += '&ingredients.name=' + filter;
    }
  }

  String data = await getHttp(apiUrl);
  return data;
}

getHttp(url) async {
  print('GET - ' + url);
  try {
    Response response = await Dio().get(url);

    print('GET success');
    String data = jsonEncode(response.data);

    return data;
  } catch (e) {
    print(e);
    return 'err';
  }
}