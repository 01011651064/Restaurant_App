import 'package:flutter/material.dart';
import 'package:resto/Admin/EditMenu/Page.dart';
import 'package:resto/Admin/Settings.dart';
import 'package:resto/main.dart';
import 'package:resto/Admin/Overview/OverviewPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminInterface extends StatefulWidget {
  Function updateTheme;
  AdminInterface({super.key, required this.updateTheme});
  @override
  State<AdminInterface> createState() => _AdminInterfaceState();
}

class _AdminInterfaceState extends State<AdminInterface> {
  int currentPageIndex = 0;
  List<String> records = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (currentPageIndex) {
        0 => OverviewPage(),
        1 => EditMenuPage(),
        int() => Settings(updateTheme: widget.updateTheme),
       
      },
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateTextStyle.resolveWith(
              (states) => const TextStyle(fontSize: 15)),
        ),
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Theme.of(context).dividerColor,
          selectedIndex: currentPageIndex,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_filled,
                color:
                    currentPageIndex == 0 ? Colors.grey[100] : Colors.grey[600],
              ),
              label: 'Main',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.restaurant_menu_outlined,
                color:
                    currentPageIndex == 1 ? Colors.grey[100] : Colors.grey[600],
              ),
              label: 'Restaurant',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings,
                color:
                    currentPageIndex == 2 ? Colors.grey[100] : Colors.grey[600],
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
