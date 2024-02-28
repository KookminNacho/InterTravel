import 'package:flutter/material.dart';
import 'package:intertravel/Profile/LoginPage.dart';
import 'GlobalPageRoute.dart';

void main() {
  runApp(const MyApp());
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Center(
              child: Text(
            "여행사이, InterTravel!",
            style: TextStyle(fontSize: 30),
          )),
          MaterialButton(
            onPressed: () {
              Navigator.pushNamed(context, GlobalPageRoute.routeLogin);
            },
            child: const Text('로그인하고 시작하기'),
          ),
          MaterialButton(onPressed: () {
            Navigator.pushNamed(context, GlobalPageRoute.mainPage);

          }, child: Text("로그인 없이 시작하기"))
        ],
      ),
    );
  }
}
