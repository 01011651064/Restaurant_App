import 'package:flutter/material.dart';
import 'package:resto/Admin/EditMenu/API.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../EditMenu/FoodCard.dart';
import '../EditMenu/EditForm.dart';
import '../EditMenu/CatagoryForm.dart';

class EditMenuPage extends StatefulWidget {
  const EditMenuPage({super.key});

  @override
  State<EditMenuPage> createState() => _EditMenuPageState();
}

class _EditMenuPageState extends State<EditMenuPage> {
  late Future<List<FoodCardData>> futureFoodCardData;
  final ScrollController yourScrollController = ScrollController();
  int selectedSeg = 1;
  bool filterState = false;
  RangeValues priceRange = RangeValues(0, FoodCardData.maxPrice);
  double timesOrdered = 0;
  double rating = 0;

  @override
  void initState() {
    futureFoodCardData = fetchFoodCardData(
        rating, priceRange.end, priceRange.start, timesOrdered.toInt());

    super.initState();
  }

  void update(bool isEdit) {
    setState(() {
      if (isEdit) {
        priceRange = RangeValues(0, FoodCardData.maxPrice);
        futureFoodCardData = fetchFoodCardData(rating, FoodCardData.maxPrice,
            priceRange.start, timesOrdered.toInt());
      } else {
        futureFoodCardData = fetchFoodCardData(
            rating, priceRange.end, priceRange.start, timesOrdered.toInt());
      }

      // if (isDelete) {
      //   futureFoodCardData = fetchFoodCardData(
      //           rating, priceRange.end, priceRange.start, timesOrdered.toInt())
      //       .whenComplete(() {
      //     priceRange = RangeValues(0, FoodCardData.maxPrice);
      //     timesOrdered = 0;
      //   });
      // } else {

      //}

      //  } else if (currentWidgetPrice > priceRange.end) {
      //   futureFoodCardData = fetchFoodCardData(rating, max(currentWidgetPrice,priceRange.end),
      //           priceRange.start, timesOrdered.toInt())
      //       .whenComplete(() =>
      //           priceRange = RangeValues(priceRange.start, currentWidgetPrice));
      // } else if (currentWidgetPrice < priceRange.end) {
      //   futureFoodCardData = fetchFoodCardData(
      //           rating, priceRange.end, priceRange.start, timesOrdered.toInt())
      //       .whenComplete(() => priceRange =
      //           RangeValues(priceRange.start, FoodCardData.maxPrice));
      // } else {
      //   futureFoodCardData = fetchFoodCardData(
      //       rating, priceRange.end, priceRange.start, timesOrdered.toInt());
      // }
    });
  }

  Widget filter() {
    return IgnorePointer(
      ignoring: !filterState,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: filterState ? 1 : 0,
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth: 600),
          height: 200,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 6,
            child: Stack(
              children: [
                InkWell(
                  onTap: () {},
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Price:'),
                          Flexible(
                            child: RangeSlider(
                              values: priceRange,
                              min: 0,
                              max: FoodCardData.maxPrice,
                              labels: RangeLabels(
                                priceRange.start.round().toString(),
                                priceRange.end.round().toString(),
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  priceRange = values;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Rating:'),
                          Flexible(
                            child: Slider(
                                min: 0,
                                max: 5,
                                value: rating,
                                label: rating.round().toString(),
                                onChanged: (tt) {
                                  setState(() {
                                    rating = tt;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Times Ordered:'),
                          Flexible(
                            child: Slider(
                                min: 0,
                                max: FoodCardData.maxTimesOrdered,
                                value: timesOrdered,
                                label: timesOrdered.round().toString(),
                                onChanged: (tt) {
                                  setState(() {
                                    timesOrdered = tt;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          filterState = !filterState;

                          update(false);
                        },
                        icon: Icon(Icons.search),
                        label: Text('Filter'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 75,
            title: Container(
              //padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
              child: Center(
                child: SearchAnchor(
                  viewHintText: "Search",
                  viewConstraints: BoxConstraints(maxHeight: 250),
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      hintText: 'Search',
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onChanged: (_) {
                        controller.openView();
                      },
                      leading: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.search),
                      ),
                      trailing: <Widget>[
                        IconButton.filledTonal(
                            splashRadius: 18,
                            onPressed: () {
                              setState(() {
                                filterState = !filterState;
                              });
                            },
                            icon: const Icon(Icons.filter_alt_rounded)),
                      ],
                    );
                  },
                  suggestionsBuilder: (BuildContext context,
                      SearchController controller) async {
                    var list = await searchItem(controller.text);
                    var tiles = List<ListTile>.generate(list.length, (index) {
                      return ListTile(
                        title: Text(list[index].name),
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return EditForm(this.update, list[index], true);
                            },
                          );
                        },
                      );
                    });

                    return tiles;
                  },
                ),
              ),
            ),
          ),
          body: Container(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    // SegmentedButton(
                    //     segments: const [
                    //       ButtonSegment(
                    //           value: 1, icon: Icon(Icons.abc), label: Text('FoodData')),
                    //       ButtonSegment(
                    //           value: 2, icon: Icon(Icons.abc), label: Text('Drinks'))
                    //     ],
                    //     selected: {
                    //       selectedSeg
                    //     },
                    //     onSelectionChanged: (index) {
                    //       setState(() {
                    //         selectedSeg = index.first;
                    //       });
                    //     }),
                    Flexible(
                        child: FutureBuilder(
                            future: futureFoodCardData,
                            builder: (context, foodDataList) {
                              if (foodDataList.hasError) {
                                return Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Error: Request to server failed',
                                      style: TextStyle(fontSize: 20),
                                    ));
                              } else if (foodDataList.hasData) {
                                if (foodDataList.data!.isEmpty) {
                                  return Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'No Data within the specified filters',
                                        style: TextStyle(fontSize: 20),
                                      ));
                                } else {
                                  return Scrollbar(
                                    controller: yourScrollController,
                                    interactive: true,
                                    scrollbarOrientation:
                                        ScrollbarOrientation.right,
                                    child: Container(
                                      //constraints: const BoxConstraints(maxWidth: 600),
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 15, 0),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        controller: yourScrollController,
                                        scrollDirection: Axis.vertical,
                                        itemCount: foodDataList.data!.length,
                                        itemBuilder: (context, index) {
                                          return FoodCard(
                                              update: update,
                                              cardData:
                                                  foodDataList.data![index]);
                                        },
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return Container(
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(),
                                );
                              }
                            })),
                  ],
                ),
                filter(),
              ],
            ),
          ),
          floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.small(
                  enableFeedback: true,
                  onPressed: () {
                    setState(() {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return CatagoryForm();
                        },
                      );
                      //foodTitles.insert(0, 'element');
                    });
                  },
                  child: Icon(Icons.edit),
                  tooltip: "Add Catagory",
                ),
                SizedBox(height: 10),
                FloatingActionButton.extended(
                  enableFeedback: true,
                  //hoverColor: Colors.blue[300],
                  onPressed: () {
                    setState(() {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return EditForm(
                              this.update, FoodCardData.emptyObj(), false);
                        },
                      );
                      //foodTitles.insert(0, 'element');
                    });
                  },
                  label: const Text(
                    'Add',
                    style: TextStyle(
                        fontFamily: 'OpenSansBold',
                        fontWeight: FontWeight.bold),
                  ),
                  icon: const Icon(Icons.add),
                  tooltip: "Add Item",
                ),
              ])),
    );
  }
}
