import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/Util/Constrains.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:provider/provider.dart';
import 'GlobalPageRoute.dart';
import 'ViewModel/ImageProvider.dart';
import 'ViewModel/UserData.dart';
import 'ViewModel/UserPermission.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NaverMapSdk.instance.initialize(clientId: "d1e8xig1zk");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserData()),
    ChangeNotifierProvider(create: (context) => UserPermission()),
    ChangeNotifierProvider(create: (context) => DiaryProvider()),
    ChangeNotifierProvider(create: (context) => ImageProviderModel()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    loginHeight = MediaQuery.of(context).size.height / 2.5;
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: GlobalPageRoute.mainPage,
      routes: namedRoutes,
    );
  }
}
