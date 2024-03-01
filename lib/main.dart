import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/Profile/LoginPage.dart';
import 'package:intertravel/Provider/UserPermission.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: GlobalPageRoute.routeHome,
      routes: namedRoutes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: Consumer<UserPermission>(builder: (context, userPermission, child) {
        return (userPermission.locationPermission)
            ? Column(
          children: [
            Center(
                child: Text(
                  "여행사이, InterTravel!",
                  style: TextStyle(fontSize: 30),
                )),
            MaterialButton(
              onPressed: () {
                Navigator.popAndPushNamed(
                    context, GlobalPageRoute.routeLogin);
              },
              child: const Text('로그인하고 시작하기'),
            ),
            MaterialButton(
                onPressed: () {
                  Navigator.popAndPushNamed(
                      context, GlobalPageRoute.mainPage);
                },
                child: Text("로그인 없이 시작하기"))
          ],
        )
            : ElevatedButton(onPressed: () {
          userPermission.requestLocationPermission();
        }, child: Text("권한을 허용해주세요!"));
      }),
    );
  }
}
