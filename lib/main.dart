import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare/routes/homeScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  if (kIsWeb) await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Config>(create: (context) => Config()),
        ChangeNotifierProvider<Auth>(create: (context) => Auth()),
      ],
      builder: (context, child) {
        return App();
      },
    ),
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(
        fontFamily: GoogleFonts.changa().fontFamily,
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: GoogleFonts.changa(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
