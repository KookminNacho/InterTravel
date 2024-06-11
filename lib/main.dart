import 'dart:convert';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/Util/Constrains.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/UIViewMode.dart';
import 'package:intertravel/theme.dart';
import 'package:provider/provider.dart';
import 'GlobalPageRoute.dart';
import 'ViewModel/ImageProvider.dart';
import 'ViewModel/MarkerManager.dart';
import 'ViewModel/UserData.dart';
import 'ViewModel/UserPermission.dart';
import 'firebase_options.dart';

String jsonString = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug);
  await dotenv.load(fileName: ".env");

  await NaverMapSdk.instance.initialize(clientId: dotenv.env["ACCESS_KEY"]!);
  jsonString = await rootBundle.loadString('assets/appainter_theme.json');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserData()),
    ChangeNotifierProvider(create: (context) => UserPermission()),
    ChangeNotifierProvider(create: (context) => DiaryProvider()),
    ChangeNotifierProvider(create: (context) => ImageProviderModel()),
    ChangeNotifierProvider(create: (context) => MarkerManager()),
    ChangeNotifierProvider(create: (context) => UIViewModel())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    loginHeight = MediaQuery.of(context).size.height / 2.5;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: GlobalPageRoute.mainPage,
        routes: namedRoutes,
        theme: CustomTheme.dark(),
        // theme: ThemeData(
        //   primaryColor: Colors.white,
        //   dialogTheme: const DialogTheme(
        //     backgroundColor: Colors.white,
        //     elevation: 0,
        //     surfaceTintColor: Colors.white,
        //   ),
        //   useMaterial3: true,
        //   /**/
        //   canvasColor: Colors.white,
        //   scaffoldBackgroundColor: Colors.white,
        //   appBarTheme: const AppBarTheme(
        //     elevation: 0,
        //     iconTheme: IconThemeData(color: Colors.black),
        //   ),
        //   primarySwatch: Colors.blue,
        //   buttonTheme: const ButtonThemeData(
        //     buttonColor: Colors.blue,
        //     textTheme: ButtonTextTheme.primary,
        //   ),
        // )
    );
  }
}
