import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/Provider/UserPermission.dart';
import 'package:intertravel/Util/Constrains.dart';
import 'package:provider/provider.dart';
import 'GlobalPageRoute.dart';
import 'Provider/UserData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: "d1e8xig1zk");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserData()),
    ChangeNotifierProvider(create: (context) => UserPermission())
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
