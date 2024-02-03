import 'package:google_fonts/google_fonts.dart';
import 'package:resto/Admin/Overview/API.dart';
import 'package:flutter/material.dart';

class DeliveryContent extends StatefulWidget {
  const DeliveryContent({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DeliveryContentState createState() => _DeliveryContentState();
}

class _DeliveryContentState extends State<DeliveryContent> {
  late Future<List<DeliveryMenData>> futureDeliveryMen;
  double orderState = 0;
  int selected = 0;
  int selectedButtonIndex = 0;
  @override
  void initState() {
    super.initState();
    futureDeliveryMen = fetchDeliveryMen(0).whenComplete(() => setState(
          () {},
        ));
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
              'Delivery Men',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 28,
                
                ),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              //Text('Filter:'),
              ActionChip(
                avatar: Icon(
                    selected == 1 ? Icons.numbers : Icons.format_list_numbered),
                label: Text(
                  'Orders Delivered',
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
                    futureDeliveryMen = fetchDeliveryMen(0);
                  });
                },
              ),

              ActionChip(
                avatar:
                    Icon(selected == 2 ? Icons.person : Icons.person_outline),
                label: Text(
                  'Status',
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
                    futureDeliveryMen = fetchDeliveryMen(0);
                    selectedButtonIndex = 0;
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
                        child: Slider(
                          value: orderState,
                          min: 0,
                          max: DeliveryMenData.maxNumberOfOrders.toDouble(),
                          label: orderState.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              orderState = value;
                            });
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
                                  futureDeliveryMen =
                                      fetchDeliveryMen(orderState.toInt());
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
              Container(
                height: 86,
                padding: const EdgeInsets.all(8),
                child: Card(
                  elevation: 8,
                  child: Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          constraints: const BoxConstraints(
                              maxWidth: 600, minWidth: 400),
                          child: SegmentedButton(
                              showSelectedIcon: false,
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity:
                                    VisualDensity(horizontal: -1, vertical: -1),
                              ),
                              segments: const [
                                ButtonSegment(
                                    icon: Icon(Icons.star_border),
                                    value: 1,
                                    label: Text('Free')),
                                ButtonSegment(
                                    icon: Icon(Icons.delivery_dining_outlined),
                                    value: 2,
                                    label: Text('Busy')),
                              ],
                              selected: {selectedButtonIndex},
                              onSelectionChanged: (index) {
                                setState(() {
                                  selectedButtonIndex = index.first;
                                  futureDeliveryMen =
                                      fetchDeliveryMenFilterStatus(
                                          index.first - 1);
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const Divider(),
            Flexible(
              child: FutureBuilder<List<DeliveryMenData>>(
                future: futureDeliveryMen,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DeliveryMenData> delivery = snapshot.data!;
                    if (delivery.isNotEmpty) {
                      return ListView.builder(
                          itemCount: delivery.length,
                          itemBuilder: (context, index) {
                            // ignore: non_constant_identifier_names
                            final deliveryList = delivery[index];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                              child: Container(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ID: #${deliveryList.deliveryManId}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      'Name: ${deliveryList.firstName} ${deliveryList.lastName}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      'Date Of Joining: ${deliveryList.dateOfJoining.split('T')[0]}',
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 20),
                                    ),
                                    Text(
                                      'Rating: ${deliveryList.rating}',
                                      style: const TextStyle(
                                          color: Colors.orange, fontSize: 20),
                                    ),
                                    Text(
                                      'Orders Delivered: ${deliveryList.numberOfOrders}',
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 20),
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
