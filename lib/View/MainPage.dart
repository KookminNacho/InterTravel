import 'dart:typed_data';

import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/View/DIalog/ListDialog.dart';
import 'package:intertravel/View/LoginPage.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/UIViewMode.dart';
import 'package:intertravel/ViewModel/UserPermission.dart';
import 'package:intertravel/WelcomePage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/Diary.dart';
import '../Util/Constrains.dart';
import '../ViewModel/ImageProvider.dart';
import '../ViewModel/UserData.dart';
import 'DIalog/SettingDialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late NaverMapController _controller;
  bool _userVerified = false;
  bool _isLoaded = false;
  bool _cameraMove = false;
  bool _firstLoad = true;
  late Future<SharedPreferences> _prefs;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserData provider = Provider.of<UserData>(context, listen: false);
      provider.autoLogin();

      await provider.getLocation();
    });
    _prefs = SharedPreferences.getInstance();

    generateButtonList();
    super.initState();
  }

  void mapFunction(DiaryProvider diaries, UserData user) {
    if (user.user != null) {
      _userVerified = true;
      if (_firstLoad) {
        diaries.loadDiary(user.uid);
        print(user.uid);
        DefaultBottomBarController.of(context).open();

        _firstLoad = false;
      }

      if (!_isLoaded && diaries.isLoaded) {
        mapLoad(user, diaries);
      }
      if (diaries.selectedDiary != null) {
        if (!DefaultBottomBarController.of(context).isOpening ||
            DefaultBottomBarController.of(context).isOpen) {
          DefaultBottomBarController.of(context).open();
        }
        NCameraUpdate target = NCameraUpdate.scrollAndZoomTo(
            target: diaries.selectedDiary!.location, zoom: 10);
        target.setAnimation(
            duration: const Duration(milliseconds: 1500),
            animation: NCameraAnimation.fly);
        _controller.updateCamera(target);
      } else {
        if (!DefaultBottomBarController.of(context).isClosing ||
            DefaultBottomBarController.of(context).isOpen) {
          DefaultBottomBarController.of(context).close();
        }
      }
    } else {
      try {
        _controller.clearOverlays();
      } catch (LateInitializationError) {
        print("Map is not ready");
      }
      diaries.clearDiary();
      _userVerified = false;
      _firstLoad = true;
      _isLoaded = false;
      DefaultBottomBarController.of(context).open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryProvider>(builder: (context, diaries, child) {
      return Consumer<UserPermission>(builder: (context, permission, child) {
        return (permission.locationPermission)
            ? Consumer<UserData>(builder: (context, user, child) {
                mapFunction(diaries, user);
                return Scaffold(
                  bottomNavigationBar: bottomNavBar(user),
                  floatingActionButtonLocation: ExpandableFab.location,
                  floatingActionButton: (diaries.isLoaded && _userVerified)
                      ? floatingButton(user)
                      : Container(),
                  body: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      NaverMap(
                        onMapTapped: (point, latLng) {
                          if (_userVerified) {
                            DefaultBottomBarController.of(context).swap();
                          }
                        },
                        onCameraChange: (reason, isGesture) {
                          if (reason == NCameraUpdateReason.gesture) {
                            if (!DefaultBottomBarController.of(context)
                                .isClosing) {
                              DefaultBottomBarController.of(context).close();
                            }
                          }
                        },
                        onCameraIdle: () async {
                          if (_cameraMove) {
                            _cameraMove = false;
                          }
                        },
                        options: NaverMapViewOptions(
                            extent: const NLatLngBounds(
                              southWest: NLatLng(31.43, 122.37),
                              northEast: NLatLng(44.35, 132.0),
                            ),
                            minZoom: 6,
                            initialCameraPosition: (diaries.selectedDiary !=
                                    null)
                                ? NCameraPosition(
                                    target: diaries.selectedDiary!.location,
                                    zoom: 10)
                                : NCameraPosition(
                                    target: NLatLng(
                                        35.95667374781408, 127.85881633921491),
                                    zoom: 6)),
                        onMapReady: (NaverMapController mapController) {
                          Future.delayed(Duration(milliseconds: 1000), () {
                            setState(() {
                              loginColor = Colors.black.withOpacity(0.5);
                              loginHeight = 0;
                            });
                          });
                          _controller = mapController;
                        },
                      ),
                      (_userVerified)
                          ? Container()
                          : Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.black.withOpacity(0.2),
                            ),
                    ],
                  ),
                );
              })
            : Center(
                child: ElevatedButton(
                    onPressed: () {
                      permission.requestLocationPermission();
                    },
                    child: Text("권한을 허용해주세요")),
              );
      });
    });
  }

  Widget floatingButton(UserData user) {
    return Consumer<UserData>(builder: (context, uuser, child) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
                //
                // Set onVerticalDrag event to drag handlers of controller for swipe effect
                onVerticalDragUpdate:
                    DefaultBottomBarController.of(context).onDrag,
                onVerticalDragEnd:
                    DefaultBottomBarController.of(context).onDragEnd,
                child: ExpandableFab(
                    openButtonBuilder: RotateFloatingActionButtonBuilder(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: user.photo,
                      ),
                      fabSize: ExpandableFabSize.regular,
                      foregroundColor: Colors.amber,
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(
                        side: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    closeButtonBuilder: RotateFloatingActionButtonBuilder(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: user.photo,
                      ),
                      fabSize: ExpandableFabSize.regular,
                      foregroundColor: Colors.deepOrangeAccent,
                      backgroundColor: Colors.grey,
                      shape: const CircleBorder(),
                    ),
                    type: ExpandableFabType.values[2],
                    distance: 60.0,
                    children: floatingButtonList)),
          ],
        ),
      );
    });
  }

  Future<NOverlayImage> markerWithImage(Diary diary) async {
    Uint8List image = Provider.of<ImageProviderModel>(context, listen: false)
        .images[diary.imageURI]![0];

    return NOverlayImage.fromByteArray(image);
  }

  void mapLoad(UserData user, DiaryProvider diaries) async {
    if (DefaultBottomBarController.of(context).isClosed) {
      DefaultBottomBarController.of(context).open();
    }

    ImageProviderModel imageProvider =
        Provider.of<ImageProviderModel>(context, listen: false);
    for (Diary d in diaries.diaries) {
      if (imageProvider.images[d.imageURI] == null) {
        await imageProvider.loadImage(d);
      }
      drawMarker(d, imageProvider);
    }
    _isLoaded = true;
  }

  void drawMarker(Diary d, ImageProviderModel imageProviderModel) async {
    Uint8List img = imageProviderModel.images[d.imageURI[0]]![0];
    Uint8List bigimg = imageProviderModel.images[d.imageURI[0]]![1];
    _controller.addOverlay(clickAbleMarker(d, [
      await NOverlayImage.fromByteArray(img),
      await NOverlayImage.fromByteArray(bigimg)
    ]));
  }

  Future<NMarker> bigMarker(Diary diary, NOverlayImage image) async {
    NMarker marker =
        NMarker(id: diary.title, position: diary.location, icon: image);
    return marker;
  }

  NMarker clickAbleMarker(Diary diary, List<NOverlayImage> image) {
    NMarker marker =
        NMarker(id: diary.title, position: diary.location, icon: image[0]);
    marker.setOnTapListener((overlay) async {
      _cameraMove = false;
      DefaultBottomBarController.of(context).open();
      Provider.of<DiaryProvider>(context, listen: false).selectDiary(diary);
      Provider.of<UIViewModel>(context, listen: false).welcomeHeight = 400;
      NCameraUpdate move = NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(diary.location.latitude, diary.location.longitude),
          zoom: 10);
      move.setAnimation(
          animation: NCameraAnimation.fly,
          duration: const Duration(milliseconds: 1500));
      _controller.updateCamera(move);
    });
    return marker;
  }

  List iconList = [
    [Icons.add, "새 일기"],
    [Icons.list, "리스트"],
    [Icons.settings, "설정"]
  ];

  void generateButtonList() {
    for (int i = 0; i < 3; i++) {
      floatingButtonList.add(FloatingActionButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        onPressed: () {
          callDialog(i);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            Icon(iconList[i][0]),
            Text("${iconList[i][1]}", style: TextStyle(fontSize: 8))
          ],
        ),
      ));
    }
  }

  List<Widget> floatingButtonList = [];

  void callDialog(int index) {
    showDialog(
        barrierColor: Colors.black.withOpacity(0.2),
        context: context,
        builder: (BuildContext context) {
          switch (index) {
            case 0:
              return Container();
            case 1:
              return const ListDialog();
            case 2:
              return const SettingDialog();
            default:
              return const Text("Error");
          }
        });
  }

  Widget bottomNavBar(UserData user) {
    BottomBarController bottomBarController = BottomBarController(vsync: this);
    bottomBarController.onDragEnd(DragEndDetails(velocity: Velocity.zero));
    return Consumer<UserData>(builder: (context, user, child) {
      return BottomExpandableAppBar(
          attachSide: Side.Top,
          appBarHeight: 10,
          expandedHeight: welcomeHeight,
          bottomOffset: 0,
          horizontalMargin: 16,
          shape: AutomaticNotchedShape(
              RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
          expandedBody: (user.user == null) ? LoginPage() : WelcomePage());
    });
  }
}
