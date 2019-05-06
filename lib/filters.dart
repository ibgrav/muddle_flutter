import 'package:flutter/material.dart';
import './glob.dart' as glob;
import './api.dart' as api;
import './search.dart' as results;

Scaffold filterPage(bool search, String title, List list, String type, context, next) {
  FloatingActionButton toWindow;
  if (search) {
    toWindow = FloatingActionButton.extended(
      onPressed: () async {
        
        await glob.searchAndBuildRecipes();

        glob.pushMember(context, results.SearchResults());
      },
      label: Text("RECIPES", style: glob.headStyle(0xFFefefef)),
      icon: Icon(Icons.local_drink),
    );
  } else
    toWindow = FloatingActionButton.extended(
      onPressed: () {
        print(glob.currentFilters);
        glob.pushMember(context, next);
      },
      label: Text("NEXT", style: glob.headStyle(0xFFefefef)),
      icon: Icon(Icons.arrow_forward_ios),
    );

  return Scaffold(
    appBar: AppBar(
      title: Text('Muddle', style: glob.headStyle(0xbbefefef)),
    ),
    body: Container(
      child: Stack(
        children: [
          MyList(readList: list, listType: type),
          AnimatedContainer(
            duration: Duration(milliseconds: 250),
            height: 50,
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
            child: Container(
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: glob.subHeadStyle(0xffefefef),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: toWindow,
  );
}

class Filters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return filterPage(false, 'Filters', glob.filters, 'filters', context, Ingredients());
  }
}

// class Flavors extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return filterPage(
//         false, 'Flavors', glob.flavors, 'flavor', context, Complexity());
//   }
// }

// class Complexity extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return filterPage(false, 'Complexity', glob.complexities, 'complexity',
//         context, Ingredients());
//   }
// }

class Ingredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return filterPage(
        true, 'Ingredients', glob.ingredients, 'ingredients', context, Ingredients());
  }
}

class FilterButton {
  FilterButton({this.title, this.type, this.selected, this.index, this.length});

  String title;
  String type;
  bool selected;
  int index;
  int length;
}

class MyList extends StatefulWidget {
  MyList({Key key, @required this.readList, @required this.listType})
      : super(key: key);

  final List readList;
  final String listType;

  @override
  State<StatefulWidget> createState() => MyListState();
}

class MyListState extends State<MyList> {
  List<FilterButton> filters;

  @override
  void initState() {
    super.initState();

    var counter = 0;

    filters = List<FilterButton>();
    for (var filter in widget.readList) {
      filters.add(FilterButton(
        title: filter['name'],
        index: counter,
        length: widget.readList.length,
        selected: false,
      ));
      counter++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: filters.length,
      itemBuilder: (context, index) {
        return ListItem(
          filters[index],
          () => onBtnPressed(index, filters),
        );
      },
      shrinkWrap: true,
    );
  }

  onBtnPressed(int index, List<FilterButton> items) {
    final item = items[index];
    setState(() {
      item.selected = !item.selected;
    });
    glob.currentFilters[widget.listType] = [];
    for (var one in items) {
      if (one.selected) {
        glob.currentFilters[widget.listType].add(one.title);
      }
    }
  }
}

class ListItem extends StatelessWidget {
  ListItem(this.filterButton, this.onSelected);

  final FilterButton filterButton;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    BoxDecoration deco;
    TextStyle font;
    EdgeInsets pad = EdgeInsets.fromLTRB(50, 15, 50, 15);

    if (filterButton.index == 0) {
      pad = EdgeInsets.fromLTRB(50, 80, 50, 15);
    }

    if (filterButton.index == filterButton.length - 1) {
      pad = EdgeInsets.fromLTRB(50, 15, 50, 80);
    }

    if (filterButton.selected) {
      deco = glob.boxDec(Color(0xff4db6ac), Color(0xFF333333), 30.0, 10.0);
      font = glob.subHeadStyle(0xffefefef);
    } else {
      deco = glob.boxDec(Color(0xFFffffff), Color(0xFFffffff), 5.0, 10.0);
      font = glob.subHeadStyle(0xff000000);
    }

    return Padding(
      padding: pad,
      child: GestureDetector(
        onTap: onSelected,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          height: 70.0,
          decoration: deco,
          child: Center(
            child: Text(
              filterButton.title,
              textAlign: TextAlign.center,
              style: font,
            ),
          ),
        ),
      ),
    );
  }
}
