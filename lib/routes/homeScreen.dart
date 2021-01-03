import 'package:flare/widgets.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        backgroundColor: Colors.transparent,
        appBar: MyAppBar(),
        body: Center(child: Consumer<Auth>(
          builder: (context, auth, child) {
            print('test');

            return Image.network(auth.url ??
                'https://images.all-free-download.com/images/graphiclarge/harry_potter_icon_6825007.jpg');
          },
        )),
      ),
    );
  }
}
