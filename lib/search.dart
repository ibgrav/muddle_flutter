import 'package:flutter/material.dart';
import './glob.dart' as glob;
import './api.dart' as api;
import './recipe.dart' as recipe;

Scaffold searchPage(title, context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Muddle - ' + title, style: glob.headStyle(0xbbefefef)),
    ),
    body: Container(
      child: Center(
        child: Results(recipeList: glob.recipes, listType: 100),
      ),
    ),
  );
}

class SearchResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return searchPage('Results', context);
  }
}

class RecipeResult {
  RecipeResult(
      {this.name,
      this.ingredients,
      this.matchStrength,
      this.index,
      this.length});

  String name;
  List ingredients;
  int matchStrength;
  int length;
  int index;
}

class Results extends StatefulWidget {
  Results({Key key, @required this.recipeList, @required this.listType})
      : super(key: key);

  final List recipeList;
  final int listType;

  @override
  State<StatefulWidget> createState() => ResultsState();
}

class ResultsState extends State<Results> {
  List<RecipeResult> recipes;

  @override
  void initState() {
    super.initState();

    var counter = 0;

    recipes = List<RecipeResult>();
    for (var recipe in widget.recipeList) {
      recipes.add(RecipeResult(
        name: recipe['name'],
        ingredients: recipe['ingredients'],
        matchStrength: glob.recipeMatchStrength(recipe['ingredients']),
        index: counter,
        length: recipes.length,
      ));
      counter++;
    }

    recipes.sort((a, b) => a.matchStrength.compareTo(b.matchStrength));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return ListItem(
              recipes[index],
              () => onBtnPressed(index, recipes),
            );
          },
          shrinkWrap: true,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: FiltersDrop(),
        ),
      ],
    );
  }

  onBtnPressed(int index, List<RecipeResult> items) async {
    final item = items[index];
    // var getRecipe = await api.getRecipe(item.name.toString());
    var gotRecipe;

    glob.recipes.forEach((oneRecipe) {
      if(oneRecipe['name'] == item.name) gotRecipe = oneRecipe;
    });

    glob.pushMember(context, recipe.filterPage(gotRecipe));
  }
}

class ListItem extends StatelessWidget {
  ListItem(this.recipeResult, this.onSelected);

  final RecipeResult recipeResult;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    BoxDecoration deco;
    TextStyle font;

    EdgeInsets pad = EdgeInsets.fromLTRB(50, 15, 50, 15);

    if (recipeResult.index == 0) {
      pad = EdgeInsets.fromLTRB(50, 80, 50, 15);
    }

    if (recipeResult.index == recipeResult.length - 1) {
      pad = EdgeInsets.fromLTRB(50, 15, 50, 80);
    }

    deco = glob.boxDec(Color(0xFFffffff), Color(0xFFffffff), 5.0, 3.0);
    font = glob.subHeadStyle(0xff000000);

    return Padding(
      padding: pad,
      child: GestureDetector(
        onTap: onSelected,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          // height: 200.0,
          decoration: deco,
          child: buildIngredientsList(recipeResult, font),
        ),
      ),
    );
  }
}

Column buildIngredientsList(RecipeResult recipe, TextStyle font) {
  var columnChildren = [
    Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: Text(
        'Ingredients Missing: ' + recipe.matchStrength.toString(),
        textAlign: TextAlign.center,
        style: font,
      ),
    ),
    Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Text(
        recipe.name,
        textAlign: TextAlign.center,
        style: font,
      ),
    ),
  ];

  for (var ingredient in recipe.ingredients) {
    columnChildren.add(
      Padding(
          padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
          child: Text(ingredient['name'], style: glob.textStyle)),
    );
  }

  columnChildren.add(Padding(padding: EdgeInsets.only(bottom: 10)));

  return Column(
    children: columnChildren,
  );
}

class FiltersDrop extends StatefulWidget {
  FiltersDrop({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FiltersDropState();
}

class FiltersDropState extends State<FiltersDrop> {
  bool open = false;
  double curHeight = 50;
  Container filterChild = closedFilters();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          open = !open;

          if (open) {
            curHeight = glob.height(context, 0.8);
            filterChild = openFilters();
          } else {
            curHeight = 50;
            filterChild = closedFilters();
          }
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        height: curHeight,
        decoration: BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Color(0x88888888),
              offset: new Offset(0.0, 0.0),
              blurRadius: 10.0,
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff345675), Color(0x33333333)],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        child: filterChild,
      ),
    );
  }
}

Container closedFilters() {
  return Container(
    child: Center(
      child: Text(
        'Filters',
        textAlign: TextAlign.center,
        style: glob.subHeadStyle(0xffefefef),
      ),
    ),
  );
}

Container openFilters() {
  List<Widget> wholeRow = [];
  List<Widget> columnChildren = [];
  Expanded newColumn;

  glob.currentFilters.forEach((k, v) {
    columnChildren = [];

    for (var item in v) {
      columnChildren.add(
        Padding(
          padding: EdgeInsets.all(10.0),
          child: FilterItem(item),
        ),
      );
    }

    newColumn = Expanded(
      child: Column(children: columnChildren),
    );
    wholeRow.add(newColumn);
  });

  return Container(
    child: SingleChildScrollView(
      child: Row(
        children: wholeRow,
      ),
    ),
  );
}

class FilterItem extends StatelessWidget {
  FilterItem(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    BoxDecoration deco;
    TextStyle font;

    deco = glob.boxDec(Color(0xFFefefef), Color(0xFFefefef), 5.0, 3.0);
    font = glob.textStyle;

    return GestureDetector(
      onTap: () {
        print(title);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        decoration: deco,
        child: Center(
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: font,
              ),
              Icon(Icons.close, color: Colors.redAccent),
            ],
          ),
        ),
      ),
    );
  }
}
