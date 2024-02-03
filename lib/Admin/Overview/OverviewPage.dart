import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resto/Admin/Overview/OrdersContent.dart';
import 'package:resto/Admin/Overview/DeliveryContent.dart';
import 'package:resto/Admin/Overview/BookingsContent.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  int selectedButtonIndex = 1;
  final PageController pcontroller = PageController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Overview',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 40,
               
                ),
              ),
              Divider(),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                constraints: BoxConstraints(maxWidth: 600, minWidth: 500),
                child: SegmentedButton(
                    showSelectedIcon: false,
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity:
                          VisualDensity(horizontal: -1, vertical: -1),
                    ),
                    segments: const [
                      ButtonSegment(value: 1, label: Text('Orders')),
                      ButtonSegment(value: 2, label: Text('Delivery')),
                      ButtonSegment(value: 3, label: Text('Bookings'))
                    ],
                    selected: {selectedButtonIndex},
                    onSelectionChanged: (index) {
                      setState(() {
                        selectedButtonIndex = index.first;
                        pcontroller.animateToPage(index.first - 1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      });
                    }),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: PageView(
                  controller: pcontroller,
                  onPageChanged: (index) {
                    setState(() {
                      selectedButtonIndex = index + 1;
                    });
                  },
                  children: const [
                    OrdersContent(),
                    DeliveryContent(),
                    BookingsContent()
                  ],
                ),
              ),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}



 // showPopover(
                          //   arrowDxOffset: 20,
                          //   arrowHeight: 0,
                          //   radius: 12,
                          //   backgroundColor: Theme.of(context).canvasColor,
                          //   height: 120,
                          //   width: 120,
                          //   context: context,
                          //   direction: PopoverDirection.bottom,
                          //   bodyBuilder: (context) {
                          //     return Scrollbar(
                          //       controller: scroll,
                          //       scrollbarOrientation:
                          //           ScrollbarOrientation.right,
                          //       interactive: true,
                          //       child: ListView.builder(
                          //         controller: scroll,
                          //         shrinkWrap: true,
                          //         itemCount: numberOfPeople.length,
                          //         itemBuilder: (context, index) {
                          //           return ListTile(
                          //             onTap: () {
                          //               setState(() {
                          //                 selected = 2;
                          //                 Navigator.of(context).pop();
                          //                 futurebooking =
                          //                     fetchBookingWithNumberOfPeople(
                          //                         numberOfPeople[index]);
                          //               });
                          //             },
                          //             title: Text(
                          //                 numberOfPeople[index].toString()),
                          //           );
                          //         },
                          //       ),
                          //     );
                          //   },
                          // );