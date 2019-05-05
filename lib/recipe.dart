library muddle.recipe;

import 'dart:convert';
import 'package:flutter/material.dart';
import './glob.dart' as glob;
import './api.dart' as api;

Scaffold filterPage(var gotRecipe) {
  // var json = jsonDecode(gotRecipe);
  // var recipeData = json[0];

  print(gotRecipe);

  return Scaffold(
    appBar: AppBar(
      title: Text('Muddle', style: glob.headStyle(0xbbefefef)),
    ),
    body: Container(
      child: Column(
        children: [
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
        ],
      ),
    ),
  );
}
