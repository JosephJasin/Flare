import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  int selected = 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        return Container(
          color: Colors.transparent,
          height: c.maxHeight / 7,
          child: Row(
            children: [
              if (c.maxWidth > 500) const Spacer(flex: 1),
              Expanded(
                flex: 2,
                child: Consumer<Auth>(
                  builder: (context, auth, child) {
                    return MyButton(
                      title: auth.isSignedIn ? 'تسجيل الخروج' : 'تسجيل الدخول',
                      onPressed: () {
                        auth.isSignedIn
                            ? auth.signOut()
                            : auth.signInWithGoogle();
                      },
                    );
                  },
                ),
              ),
              if (c.maxWidth > 500) const Spacer(flex: 1),
              Expanded(
                flex: 2,
                child: MyButton(
                  title: 'الكتب المتوفرة',
                  onPressed: () {
                    setState(() {
                      selected = 1;
                    });
                  },
                  isSelected: selected == 1,
                ),
              ),
              if (c.maxWidth > 500) const Spacer(flex: 1),
              Expanded(
                flex: 2,
                child: MyButton(
                  title: 'الكتب المطلوبة',
                  onPressed: () {
                    setState(() {
                      selected = 2;
                    });
                  },
                  isSelected: selected == 2,
                ),
              ),
              if (c.maxWidth > 500) const Spacer(flex: 1),
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

  Size get size => Size(window.physicalSize.width / window.devicePixelRatio,
      window.physicalSize.height / window.devicePixelRatio);

  const MyButton(
      {Key key, this.title, @required this.onPressed, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        if (size.width > 500)
          return Material(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000),
            ),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000),
                side: BorderSide(
                  color: isSelected ? Colors.blue : Colors.transparent,
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: (c.maxWidth + c.maxHeight) / 20,
              ),
              child: Text(
                title,
                style: GoogleFonts.changa(
                    fontSize: (c.maxWidth + c.maxHeight) / 17,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: onPressed,
            ),
          );

        return InkWell(
          child: Tab(
            child: Text(
              title,
              style: GoogleFonts.changa(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.grey[700],
              ),
            ),
          ),
          onTap: onPressed,
        );
      },
    );
  }
}
