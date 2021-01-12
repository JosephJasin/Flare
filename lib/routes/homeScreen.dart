import 'dart:html';

import 'package:flare/bookModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'addPostScreen.dart';
import '../widgets.dart';
import '../providers.dart';
import 'courses.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NavigationRailLabelType labelType = NavigationRailLabelType.none;

  final course = Wrapper<String>();

  final sKey = GlobalKey<ScaffoldState>();

  int selected = 0;

  final controller = TextEditingController();

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Row(
        children: [
          //AppBar

          //Main content.
          Expanded(
              child: Column(
            children: [
              //DropDownSearchable(course, setState),
              TypeAheadField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  onTap: () {
                    if (focusNode.hasFocus) focusNode.unfocus();
                  },
                  controller: controller,
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    suffixIcon: controller.text.isEmpty
                        ? Icon(Icons.search)
                        : IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                controller.clear();
                                focusNode.unfocus();
                              });
                            },
                          ),
                  ),
                ),
                suggestionsCallback: (pattern) => search(pattern),
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion,
                      textDirection: TextDirection.rtl,
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  print('test : ${suggestion}');
                  setState(() {
                    controller.text = suggestion;
                  });
                },
                noItemsFoundBuilder: (context) {
                  return ListTile(
                    leading: Icon(Icons.search),
                    trailing: Icon(Icons.error_outline),
                    title: Text(
                      'اسم المادة غير صحيح',
                      textDirection: TextDirection.rtl,
                    ),
                    onTap: () {
                      controller.clear();
                    },
                  );
                },
              ),
            ],
          )),

          VerticalDivider(thickness: 1, width: 1),

          //Navigation.
          NavigationRail(
            selectedIndex: selected,
            onDestinationSelected: (int index) {
              switch (index) {
                case 0:
                  labelType = labelType == NavigationRailLabelType.none
                      ? NavigationRailLabelType.all
                      : NavigationRailLabelType.none;
                  break;
              }

              setState(() {
                selected = index;
              });
            },
            labelType: labelType,
            destinations: [
              NavigationRailDestination(
                icon: Icon(MdiIcons.menu),
                label: Text(''),
              ),
              NavigationRailDestination(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://lh3.googleusercontent.com/a-/AOh14GgsdW09cGNoS3qfSMN_52V8VrXTB4HHjN6fmkMXPw=s96-c',
                  ),
                ),
                label: Text('حسابي'),
              ),
              NavigationRailDestination(
                icon: Icon(MdiIcons.homeOutline),
                selectedIcon: Icon(MdiIcons.home),
                label: Text('الصفحة الرئيسة'),
              ),
              NavigationRailDestination(
                icon: Icon(MdiIcons.notebookCheckOutline),
                selectedIcon: Icon(MdiIcons.notebookCheck),
                label: Text('الكتب المتوفرة'),
              ),
              NavigationRailDestination(
                icon: Icon(MdiIcons.bookOpenOutline),
                selectedIcon: Icon(MdiIcons.bookOpen),
                label: Text('الكتب المطلوبة'),
              ),
              NavigationRailDestination(
                icon: Icon(MdiIcons.google),
                label: Text('تسيجيل الدخول'),
              ),
              NavigationRailDestination(
                icon: Icon(MdiIcons.logout),
                label: Text('تسيجيل الخروج'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
