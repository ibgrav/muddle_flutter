library muddle.recipe;

import 'dart:convert';
import 'package:flutter/material.dart';
import './glob.dart' as glob;
import './api.dart' as api;

Scaffold filterPage(var gotRecipe) {
  // var json = jsonDecode(gotRecipe);
  // var recipeData = json[0];

  print(gotRecipe);

  List<Padding> ings = [];

  ings.add(
    Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          gotRecipe['name'],
          style: glob.headStyle(0xFF333333),
        ),
      ),
    ),
  );

  for (var ing in gotRecipe['ingredients']) {
    ings.add(
      Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          child: Center(
            child: Text(
              ing['name'],
              style: glob.subHeadStyle(0xff333333),
            ),
          ),
        ),
      ),
    );
  }

  return Scaffold(
    appBar: AppBar(
      title: Text('Muddle', style: glob.headStyle(0xbbefefef)),
    ),
    body: Container(
      child: Column(
        children: ings,
      ),
    ),
  );
}
