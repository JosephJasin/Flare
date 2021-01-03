import 'package:flare/widgets.dart';
import 'package:flutter/material.dart';

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
<<<<<<< HEAD
=======
        body: Center(
          child: Image.network(context.watch<Auth>()?.currentUser?.photoURL ??
              'https://images.all-free-download.com/images/graphiclarge/harry_potter_icon_6825007.jpg'),
        ),
>>>>>>> parent of b7e0a08... add facebook img support
      ),
    );
  }
}
