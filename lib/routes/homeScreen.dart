import 'package:flare/routes/addPostScreen.dart';
import 'package:flare/widgets.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AddPostScreen();
              },
            );
          },
        ),
        body: Text('${context.watch<Auth>().currentUser}'),
      ),
    );
  }
}
