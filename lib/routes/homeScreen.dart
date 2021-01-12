import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare/bookModel.dart';
import 'package:flare/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'accountScreen.dart';
import 'addPostScreen.dart';
import 'courses.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NavigationRailLabelType labelType = NavigationRailLabelType.none;

  int selected = 2;
  bool isRequest = false;
  String course;
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<Auth>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          //Main content.
          Expanded(
              child: Column(
            children: [
              //Search Box.
              Container(
                padding: const EdgeInsets.all(20.0),
                child: TypeAheadField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    onTap: () {
                      if (focusNode.hasFocus) focusNode.unfocus();
                    },
                    controller: controller,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      suffixIcon: controller.text.isEmpty
                          ? Icon(Icons.search)
                          : IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  controller.clear();
                                  focusNode.unfocus();
                                  course = null;
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
                    setState(() {
                      controller.text = suggestion;
                      course = suggestion;
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
              ),

              //Books.
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: BookModel.getBooks(isRequest, course: course),
                  builder: (context, snap) {
                    String intro = isRequest ? 'ابحث عن كتاب ' : 'امتلك كتاب ';

                    if (snap.hasData) {
                      final docs = snap.data.docs;

                      if (docs.isEmpty)
                        return Center(
                          child: Text(isRequest
                              ? 'لا يوجد كتب مطلوبة'
                              : 'لا يوجد كتب متوفرة'),
                        );

                      return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final book = Book.fromJson(
                                docs[index].data(), docs[index].id);

                            final date = DateTime.fromMillisecondsSinceEpoch(
                                book.timestamp);

                            return Card(
                              child: ListTile(
                                trailing: CircleAvatar(
                                  backgroundImage: NetworkImage(book.image),
                                  onBackgroundImageError:
                                      (exception, stackTrace) {},
                                ),
                                title: Text(
                                  book.name,
                                  textDirection: TextDirection.rtl,
                                ),
                                subtitle: RichText(
                                  textDirection: TextDirection.rtl,
                                  text: TextSpan(
                                      style: TextStyle(color: Colors.grey[700]),
                                      children: [
                                        TextSpan(
                                            text: intro + book.course + '\n',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        if (size.width >= 500)
                                          TextSpan(
                                            text:
                                                'التاريخ: ${date.month}/${date.day}',
                                            style: TextStyle(
                                                color: Colors.grey[500]),
                                          ),
                                        if (size.width < 500 &&
                                            book.facebook != null)
                                          WidgetSpan(
                                            child: IconButton(
                                              icon: Icon(
                                                MdiIcons.facebook,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () {
                                                launch(
                                                    'https://www.facebook.com/${book.facebook}');
                                              },
                                            ),
                                          ),
                                        if (size.width < 500 &&
                                            book.facebook != null)
                                          WidgetSpan(
                                            child: IconButton(
                                              icon: Icon(
                                                MdiIcons.facebookMessenger,
                                                color: Color(0xff00B2FF),
                                              ),
                                              onPressed: () {
                                                launch(
                                                    'https://m.me/${book.facebook}');
                                              },
                                            ),
                                          ),
                                        if (size.width < 500 &&
                                            book.whatsapp != null)
                                          WidgetSpan(
                                            child: IconButton(
                                              icon: Icon(
                                                MdiIcons.whatsapp,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {
                                                launch(
                                                    'https://wa.me/${book.whatsapp}');
                                              },
                                            ),
                                          ),
                                        if (size.width < 500)
                                          TextSpan(
                                            text: '\n' +
                                                'التاريخ: ${date.month}/${date.day}',
                                            style: TextStyle(
                                                color: Colors.grey[500]),
                                          ),
                                      ]),
                                ),
                                leading: size.width >= 500
                                    ? RichText(
                                        text: TextSpan(children: [
                                          if (book.facebook != null)
                                            WidgetSpan(
                                              child: IconButton(
                                                icon: Icon(
                                                  MdiIcons.facebook,
                                                  color: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  launch(
                                                      'https://www.facebook.com/${book.facebook}');
                                                },
                                              ),
                                            ),
                                          if (book.facebook != null)
                                            WidgetSpan(
                                              child: IconButton(
                                                icon: Icon(
                                                  MdiIcons.facebookMessenger,
                                                  color: Color(0xff00B2FF),
                                                ),
                                                onPressed: () {
                                                  launch(
                                                      'https://m.me/${book.facebook}');
                                                },
                                              ),
                                            ),
                                          if (book.whatsapp != null)
                                            WidgetSpan(
                                              child: IconButton(
                                                icon: Icon(
                                                  MdiIcons.whatsapp,
                                                  color: Colors.green,
                                                ),
                                                onPressed: () {
                                                  launch(
                                                      'https://wa.me/${book.whatsapp}');
                                                },
                                              ),
                                            ),
                                        ]),
                                      )
                                    : null,
                              ),
                            );
                          });
                    }

                    return Center(
                      child: Text(isRequest
                          ? 'لا يوجد كتب مطلوبة'
                          : 'لا يوجد كتب متوفرة'),
                    );
                  },
                ),
              ),
            ],
          )),

          VerticalDivider(thickness: 1, width: 1),

          //Navigation.
          NavigationRail(
            selectedIndex: selected,
            onDestinationSelected: (int index) {
              focusNode.unfocus();

              switch (index) {
                //Open & Close NavigationRail.
                case 0:
                  setState(() {
                    labelType = labelType == NavigationRailLabelType.none
                        ? NavigationRailLabelType.all
                        : NavigationRailLabelType.none;
                  });

                  break;

                //My Account.
                case 1:
                  if (auth.isSignedIn) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AccountScreen();
                      },
                    );
                  } else
                    auth.signInWithGoogle();

                  break;

                //Available books.
                case 2:
                  setState(() {
                    isRequest = false;
                    selected = index;
                  });
                  break;

                //Requested books.
                case 3:
                  setState(() {
                    isRequest = true;
                    selected = index;
                  });
                  break;

                //Add new Ad.
                case 4:
                  if (auth.isSignedIn)
                    showDialog(
                      context: context,
                      builder: (context) => AddPostScreen(),
                    );
                  else
                    auth.signInWithGoogle();

                  break;

                //Sign in/Sign out with Google
                case 5:
                  if (auth.isSignedIn)
                    auth.signOut();
                  else
                    auth.signInWithGoogle();
                  break;

                default:
                  setState(() {
                    selected = index;
                  });
              }
            },
            labelType: labelType,
            destinations: [
              NavigationRailDestination(
                icon: Icon(MdiIcons.menu),
                label: Text(''),
              ),
              NavigationRailDestination(
                icon: CircleAvatar(
                  child: auth.isSignedIn
                      ? null
                      : Icon(
                          Icons.account_circle_outlined,
                          color: Colors.grey[700],
                        ),
                  backgroundColor: Colors.transparent,
                  backgroundImage: auth.isSignedIn
                      ? NetworkImage(
                          auth.currentUser.photoURL,
                        )
                      : null,
                ),
                label: Text('حسابي'),
              ),
              NavigationRailDestination(
                icon: Tooltip(
                    message: 'الكتب المتوفرة',
                    child: Icon(MdiIcons.notebookCheckOutline)),
                selectedIcon: Tooltip(
                    message: 'الكتب المتوفرة',
                    child: Icon(MdiIcons.notebookCheck)),
                label: Text('الكتب المتوفرة'),
              ),
              NavigationRailDestination(
                icon: Tooltip(
                  message: 'الكتب المطلوبة',
                  child: Icon(MdiIcons.bookOpenOutline),
                ),
                selectedIcon: Tooltip(
                  message: 'الكتب المطلوبة',
                  child: Icon(MdiIcons.bookOpen),
                ),
                label: Text('الكتب المطلوبة'),
              ),
              NavigationRailDestination(
                icon: Tooltip(
                  message: 'اضافة إعلان جديد',
                  child: Icon(
                    MdiIcons.plusThick,
                  ),
                ),
                label: Text('اضافة إعلان جديد'),
              ),
              auth.isSignedIn
                  ? NavigationRailDestination(
                      icon: Tooltip(
                          message: 'تسيجيل الخروج',
                          child: Icon(MdiIcons.logout)),
                      label: Text('تسيجيل الخروج'),
                    )
                  : NavigationRailDestination(
                      icon: Tooltip(
                          message: 'تسيجيل الدخول',
                          child: Icon(MdiIcons.google)),
                      label: Text('تسيجيل الدخول'),
                    )
            ],
          ),
        ],
      ),
    );
  }
}
