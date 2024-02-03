import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resto/User/Pages/Settings/DeveloperOptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:resto/User/Pages/Settings/about_us.dart';
import 'package:resto/User/Pages/Settings/privacy_policy.dart';
import 'package:resto/User/Pages/Settings/terms_conditions.dart';
import 'package:resto/User/theme/app_color.dart';
import 'package:resto/main.dart';

class Settings extends StatefulWidget {
  Function updateTheme;
  Settings({super.key, required this.updateTheme});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text("Settings",
              style: GoogleFonts.aladin(
                color: AppColorsLight.primaryColor,
                fontSize: 45,
              )),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 10.0, left: 10.0),
            child: Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {},
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, bottom: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.sunny,
                                  color: AppColorsLight.primaryColor, size: 25),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Dark Mode",
                                  style: TextStyle(
                                      color: AppColorsLight.primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                            child: Switch(
                              activeColor: AppColorsLight.primaryColor,
                              value: AppColorsLight.darkMode,
                              onChanged: (value) async {
                                AppColorsLight.darkMode = value;
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('darkMode', value);
                                widget.updateTheme();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DeveloperOptions(),
                    ));
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(15)),
                    child: Tooltip(
                        message: 'Developer Options',
                        child: BuildContainer("Developer Options", Icons.code)),
                  ),
                ),
                const SizedBox(height: 50),
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PrivacyPolicy(),
                    ));
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(15)),
                    child: Tooltip(
                        message: 'Read Privacy Policy',
                        child: BuildContainer(
                            "Privacy Policy", Icons.contact_page_outlined)),
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TermsConditions(),
                    ));
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(15)),
                    child: Tooltip(
                        message: 'Read Terms & Conditions',
                        child: BuildContainer(
                            "Terms & Conditions", Icons.contact_page)),
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AboutUs(),
                    ));
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(15)),
                    child: Tooltip(
                        message: 'About Us',
                        child: BuildContainer(
                            "About Us", Icons.question_mark_outlined)),
                  ),
                ),
                const SizedBox(height: 50),
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('token');
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return MyApp();
                      }));
                    }
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(15)),
                    child: Tooltip(
                        message: 'Sign Out',
                        child: BuildContainer("Sign Out", Icons.logout)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget BuildContainer(String name, IconData icon) {
    return Container(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15, bottom: 10, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColorsLight.primaryColor, size: 25),
                const SizedBox(
                  width: 10,
                ),
                Text(name,
                    style: const TextStyle(
                        color: AppColorsLight.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColorsLight.primaryColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
