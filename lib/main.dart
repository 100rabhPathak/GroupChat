import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/shared/constant.dart';
import 'package:chatapp/view/home_page.dart';
import 'package:chatapp/view/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constant.apiKey,
            appId: Constant.appId,
            messagingSenderId: Constant.messagingSenderId,
            projectId: Constant.projectId));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatetus().then((value) {
      if (value != null) {
        setState(() {
          _isSignIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _isSignIn ? const HomePage() : const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
