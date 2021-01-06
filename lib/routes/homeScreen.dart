import 'package:flutter/material.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';

import 'addPostScreen.dart';
import '../widgets.dart';
import '../providers.dart';
import 'courses.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isRequest;

  final course = Wrapper<String>();

  final sKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        key: sKey,
        backgroundColor: Colors.transparent,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton(
          tooltip: 'اضافة اعلان جديد',
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            if (context.read<Auth>().isSignedIn)
              showDialog(
                context: context,
                builder: (context) {
                  return AddPostScreen();
                },
              );
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  //behavior: SnackBarBehavior.floating,
                  content: Text(
                    'قم بتسجيل الدخول من اجل اضافة اعلان',
                    textDirection: TextDirection.rtl,
                  ),
                ),
              );

              context.read<Auth>().signInWithGoogle();
            }
          },
        ),
        body: LayoutBuilder(
          builder: (context, c) {
            return Center(
              child: ListView(
                padding: c.maxWidth > 800
                    ? EdgeInsets.symmetric(horizontal: c.maxWidth / 3)
                    : EdgeInsets.symmetric(horizontal: 10),
                children: [
                  DropDownSearchable(course),
                  ListTile(
                    title: Text(
                      'يوسف ياسين',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'كتاب لغة عربية 1',
                      textDirection: TextDirection.rtl,
                    ),
                    trailing: CircleAvatar(),
                  ),
                  Padding(
                    padding: c.maxWidth > 500
                        ? EdgeInsets.symmetric(horizontal: c.maxWidth / 12)
                        : EdgeInsets.symmetric(horizontal: 100),
                    child: const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'يوسف ياسين',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'كتاب لغة عربية 1',
                      textDirection: TextDirection.rtl,
                    ),
                    trailing: CircleAvatar(),
                    leading: Container(
                      width: 100,
                      child:
                          // Row(
                          //   children: [
                          //     CircleAvatar(
                          //       backgroundImage: AssetImage('assets/whatsapp.png'),
                          //       backgroundColor: Colors.transparent,
                          //     ),
                          //     CircleAvatar(
                          //       backgroundImage: AssetImage('assets/facebook.png'),
                          //       backgroundColor: Colors.transparent,
                          //     ),
                          //   ],
                          // ),

                          RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('تواصل معي'),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
