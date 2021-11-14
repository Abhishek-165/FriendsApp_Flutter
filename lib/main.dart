import 'package:flutter/material.dart';
import 'package:friends/screens/friends.dart';
import 'package:friends/screens/login_page.dart';
import 'package:friends/utils/mytheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Future<Widget> _isLoggedIn() async {
  //   if (prefs.getString("number").isNotEmpty) {
  //     return Friends();
  //   } else {
  //     return LoginPage();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme(context),
      home: LoginPage(),
    );
  }
}
