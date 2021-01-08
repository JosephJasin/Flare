import 'package:flare/bookModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'addPostScreen.dart';
import '../widgets.dart';
import '../providers.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final course = Wrapper<String>();

  final sKey = GlobalKey<ScaffoldState>();

  final selectedScreen = Wrapper<int>(1);

  @override
  Widget build(BuildContext context) {
    print('course = ${selectedScreen.value}');
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
        appBar: MyAppBar(selectedScreen , setState),
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
            return FutureBuilder<List<Book>>(
              future: BookModel.getBooks(selectedScreen.value != 1, course: course.value),
              builder: (context, snap) {
                List<Book> books = snap.data;
                return ListView(
                  padding: c.maxWidth > 800
                      ? EdgeInsets.symmetric(horizontal: c.maxWidth / 3)
                      : EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    DropDownSearchable(course, setState),
                    if (snap.hasData)
                      for (int i = 0; i < books.length; ++i)
                        ListTile(
                          title: Text(
                            books[i].name,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            books[i].course,
                            textDirection: TextDirection.rtl,
                          ),
                          trailing: CircleAvatar(
                            backgroundImage: NetworkImage(books[i].image),
                          ),
                        ),
                  ],
                );
              },
            );
          },
        ),

        //           Padding(
        //             padding: c.maxWidth > 500
        //                 ? EdgeInsets.symmetric(horizontal: c.maxWidth / 12)
        //                 : EdgeInsets.symmetric(horizontal: 100),
        //             child: const Divider(
        //               color: Colors.grey,
        //               thickness: 1,
        //             ),
        //           ),
        //           ListTile(
        //             title: Text(
        //               'يوسف ياسين',
        //               textDirection: TextDirection.rtl,
        //               style: TextStyle(
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             subtitle: Text(
        //               'كتاب لغة عربية 1',
        //               textDirection: TextDirection.rtl,
        //             ),
        //             trailing: CircleAvatar(
        //
        //             ),
        //             leading: Container(
        //               width: 100,
        //               child:
        //                   // Row(
        //                   //   children: [
        //                   //     CircleAvatar(
        //                   //       backgroundImage: AssetImage('assets/whatsapp.png'),
        //                   //       backgroundColor: Colors.transparent,
        //                   //     ),
        //                   //     CircleAvatar(
        //                   //       backgroundImage: AssetImage('assets/facebook.png'),
        //                   //       backgroundColor: Colors.transparent,
        //                   //     ),
        //                   //   ],
        //                   // ),
        //
        //                   RaisedButton(
        //                 color: Colors.white,
        //                 shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(10),
        //                 ),
        //                 child: Text('تواصل معي'),
        //                 onPressed: () {},
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}
