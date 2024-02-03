import 'package:google_fonts/google_fonts.dart';
import 'package:resto/Admin/Overview/API.dart';
import 'package:flutter/material.dart';

class OrdersContent extends StatefulWidget {
  const OrdersContent({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OrdersContentState createState() => _OrdersContentState();
}

class _OrdersContentState extends State<OrdersContent> {
  ScrollController scroll = ScrollController();
  late Future<List<OrderData>> futureOrders;
  RangeValues priceRange = RangeValues(0, OrderData.maxPrice);
  int selected = 0;
  TextEditingController nameControler = TextEditingController();
  List<String> statusNames = [
    'New',
    'Taken',
    'Picked Up',
    'At Location',
    'Delivered'
  ];
  int selectedButtonIndex = -55;
  @override
  void initState() {
    super.initState();
    futureOrders = fetchOrders(priceRange.start, priceRange.end)
        .whenComplete(() => priceRange = RangeValues(0, OrderData.maxPrice));
  }

  void update(RangeValues values) {
    setState(() {
      priceRange = values;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      // padding: const EdgeInsets.all(10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              'Order History',
               style: GoogleFonts.dmSerifDisplay(
                  fontSize: 28,
          
                ),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              //Text('Filter:'),
              ActionChip(
                avatar: Icon(selected == 1
                    ? Icons.table_restaurant
                    : Icons.table_restaurant_outlined),
                label: Text(
                  'Price',
                  style: TextStyle(
                      color: selected == 1
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface),
                ),
                onPressed: () {
                  setState(() {
                    if (selected == 1) {
                      selected = 0;
                    } else {
                      selected = 1;
                    }
                    futureOrders = fetchOrders(0, OrderData.maxPrice);
                  });
                },
              ),

              ActionChip(
                avatar:
                    Icon(selected == 2 ? Icons.person : Icons.person_outline),
                label: Text(
                  'Name',
                  style: TextStyle(
                      color: selected == 2
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface),
                ),
                onPressed: () {
                  setState(() {
                    if (selected == 2) {
                      selected = 0;
                    } else {
                      selected = 2;
                    }
                    futureOrders = fetchOrders(0, OrderData.maxPrice);
                  });
                },
              ),

              ActionChip(
                avatar:
                    Icon(selected == 3 ? Icons.person : Icons.person_outline),
                label: Text(
                  'Status',
                  style: TextStyle(
                      color: selected == 3
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface),
                ),
                onPressed: () {
                  setState(() {
                    if (selected == 3) {
                      selected = 0;
                    } else {
                      selected = 3;
                    }
                    selectedButtonIndex = -55;
                    futureOrders = fetchOrders(0, OrderData.maxPrice);
                  });
                },
              ),
            ]),
            if (selected == 1)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  elevation: 8,
                  child: Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 5,
                        child: RangeSlider(
                          values: priceRange,
                          min: 0,
                          max: OrderData.maxPrice,
                          labels: RangeLabels(
                            priceRange.start.round().toString(),
                            priceRange.end.round().toString(),
                          ),
                          onChanged: (RangeValues values) {
                            update(values);
                          },
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                          child: FilledButton.tonal(
                              onPressed: () {
                                setState(() {
                                  futureOrders = fetchOrders(
                                      priceRange.start, priceRange.end);
                                });
                              },
                              child: const Text('Filter')),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            if (selected == 2)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  elevation: 8,
                  child: Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: TextField(
                            controller: nameControler,
                            decoration: const InputDecoration(
                                constraints: BoxConstraints(maxHeight: 45),
                                border: OutlineInputBorder(),
                                labelText: 'Name'),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                          child: FilledButton.tonal(
                              onPressed: () {
                                setState(() {
                                  if (nameControler.text.isNotEmpty) {
                                    futureOrders = fetchOrdersNameFilter(
                                        nameControler.text);
                                  }
                                });
                              },
                              child: const Text('Filter')),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            if (selected == 3)
              Container(
                  height: 70,
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: ScrollbarTheme(
                    data: const ScrollbarThemeData(
                      thickness: MaterialStatePropertyAll(5),
                      crossAxisMargin: -5,
                    ),
                    child: Scrollbar(
                      controller: scroll,
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      interactive: true,
                      child: ListView.builder(
                        controller: scroll,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: statusNames.length,
                        itemBuilder: (context, index) {
                          return Container(
                            //clipBehavior: Clip.antiAlias,
                            child: Card(
                              elevation: selectedButtonIndex == index ? 0 : 5,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(13),
                                onTap: () {
                                  setState(() {
                                    selectedButtonIndex = index;
                                    futureOrders = fetchOrdersFilterStatus(index);
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Center(
                                      child:
                                          Text(statusNames[index].toString())),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )),
            const Divider(),
            Flexible(
              child: FutureBuilder(
                future: futureOrders,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<OrderData> orders = snapshot.data!;
                    if (orders.isNotEmpty) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            // ignore: non_constant_identifier_names
                            final OrderList = orders[index];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                              child: Container(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Order #${OrderList.orderId}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          'Name: ${OrderList.firstName} ${OrderList.lastName}',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                            'Status: ${switch (OrderList.deliveryStatus) {
                                              0 => 'Just Placed',
                                              1 => 'Order Processed',
                                              2 => 'Picked Up',
                                              3 => 'At Location',
                                              4 => 'Delivered',
                                              int() => 'Unknown'
                                            }}',
                                            style:
                                                const TextStyle(fontSize: 20)),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                      ],
                                    ),
                                    Opacity(
                                      opacity: 0.5,
                                      child: Text(
                                          OrderList.dateOfOrder.split('T')[0],
                                          style: const TextStyle(fontSize: 17)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Text('Empty');
                    }
                  } else if (snapshot.hasError) {
                    return Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.all(10),
                        child: Card(
                          color: Theme.of(context).colorScheme.onError,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.error.toString(),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer),
                            ),
                          ),
                        ));
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            ),
          ]),
    );
  }
}
