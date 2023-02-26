import 'package:chat_app_flutter/firebase_options.dart';
import 'package:chat_app_flutter/helpers/helper_functions.dart';
import 'package:chat_app_flutter/pages/auth/login_page.dart';
import 'package:chat_app_flutter/pages/home_page.dart';
import 'package:chat_app_flutter/shared/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   bool isSignedIn=false;
   @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  
  }
   getUserLoggedInStatus() async{
   await HelperFunctions.getUserLoggedInStatus().then((value) {
    if(value!=null){
      setState(() {
        isSignedIn=value;
      });   
    }
   });
   }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: isSignedIn?const HomePage():const LogInPage(),
    );    
  }
  
   
}
