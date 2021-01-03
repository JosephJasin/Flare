import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int selectedScreen;

  MyAppBar({this.selectedScreen});

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size(
      double.infinity, window.physicalSize.height / window.devicePixelRatio);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    print(context.watch<Auth>().currentUser);

    return LayoutBuilder(
      builder: (context, c) {
        if (c.maxWidth > 500)
          return Container(
            color: Colors.transparent,
            height: c.maxHeight / 7,
            child: Row(
              children: [
                const Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: Consumer<Auth>(
                    builder: (context, auth, child) {
                      return MyButton(
                        title:
                            auth.isSignedIn ? 'تسيجل الخروج' : 'تسجيبل الدخول',
                        onPressed: () {
                          auth.isSignedIn
                              ? auth.signOut()
                              : auth.signInWithFacebook();

                          print('auth : ${auth.currentUser}');
                        },
                      );
                    },
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: MyButton(
                    title: 'الكتب',
                    onPressed: () async {},
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: MyButton(
                    title: 'اخر الاخبار',
                    onPressed: () {},
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          );

        return DefaultTabController(
          length: 3,
          initialIndex: widget.selectedScreen ?? 0,
          child: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.transparent,
            unselectedLabelStyle: Theme.of(context).tabBarTheme.labelStyle,
            onTap: (value) async {
              final auth = context.read<Auth>();
              UserCredential x;
              switch (value) {
                case 0:
                  auth.isSignedIn
                      ? auth.signOut()
                      : x = await auth.signInWithFacebook();

                  print('------------------------------------------------------------------------\nx = ${x.additionalUserInfo.profile}');
                  break;

                case 1:
                  break;

                case 2:
                  break;
              }
            },
            tabs: [
              Consumer<Auth>(
                builder: (context, auth, child) {
                  return Tab(
                    text: auth.isSignedIn ? 'تسيجل الخروج' : 'تسجيبل الدخول',
                  );
                },
              ),
              Tab(
                text: 'المسابقات',
              ),
              Tab(
                text: 'اخر الاخبار',
              ),
            ],
          ),
        );
      },
    );
  }
}

class MyButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;

  const MyButton(
      {Key key, this.title, @required this.onPressed, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        return Material(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000),
              side: BorderSide(
                color: isSelected ? Colors.redAccent : Colors.transparent,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: (c.maxWidth + c.maxHeight) / 20,
            ),
            child: Text(
              title,
              style: TextStyle(fontSize: (c.maxWidth + c.maxHeight) / 13),
            ),
            onPressed: onPressed,
          ),
        );
      },
    );
  }
}
