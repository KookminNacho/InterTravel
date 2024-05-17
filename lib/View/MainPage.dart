import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:intertravel/View/LoginPage.dart';
import 'package:intertravel/View/MapScreen.dart';
import 'package:provider/provider.dart';

import '../ViewModel/UserData.dart';
import '../ViewModel/UserPermission.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserData provider = Provider.of<UserData>(context, listen: false);
      provider.autoLogin();
      await provider.getLocation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UserPermission, bool>(
        selector: (_, permission) => permission.locationPermission,
        builder: (context, locationPermission, child) {
          return locationPermission
              ? Selector<UserData, User?>(selector: (_, userData) {
                  return userData.user;
                }, builder: (context, user, child) {
                  return (user != null)
                      ? DefaultBottomBarController(child: const MapScreen())
                      : LoginPage();
                })
              : Center(
                  child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<UserPermission>()
                            .requestLocationPermission();
                      },
                      child: Text("권한을 허용해주세요")),
                );
        });
  }
}
