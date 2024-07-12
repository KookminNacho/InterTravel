import 'dart:io';

import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intertravel/theme.dart';
import 'package:provider/provider.dart';

import '../Model/Diary.dart';
import '../Util/Constrains.dart';
import '../ViewModel/DiaryProvider.dart';
import '../ViewModel/ImageProvider.dart';
import '../ViewModel/UIViewMode.dart';
import '../ViewModel/UserData.dart';
import '../WelcomePage.dart';
import 'AddNewDiaryPage.dart';
import 'DIalog/ListDialog.dart';
import 'DIalog/SettingDialog.dart';
import 'GallayPage.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  bool _userVerified = false;
  bool _mapReady = false;
  bool _cameraMove = false;
  late NaverMapController _controller;
  double zoomLevel = 10;
  late Widget _preloadedPage;
  late DiaryProvider diaries;

  @override
  void initState() {
    super.initState();
    _preloadAddNewDiaryPage();
    UserData user = Provider.of<UserData>(context, listen: false);
    if (user.location == null) {
      user.getLocation();
    }
    diaries = Provider.of<DiaryProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await diaries.loadDiary(user.uid);
      await mapLoad(diaries);
    });
    DefaultBottomBarController.of(context).open();
  }

  void _preloadAddNewDiaryPage() async {
    _preloadedPage = const AddNewDiaryPage();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryProvider>(builder: (context, diaries, child) {
      return Selector<ImageProviderModel, bool>(selector: (_, imageProvider) {
        return imageProvider.isLoaded;
      }, builder: (context, isLoaded, child) {
        return Stack(
          children: [
            Consumer<UIViewModel>(builder: (context, uiViewModel, child) {
              return Consumer<UserData>(builder: (context, user, child) {
                mapFunction(diaries, user, uiViewModel);
                return Scaffold(
                  bottomSheet: bottomSheet(),
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12)),
                    height: 97,
                    child: bottomBar(),
                  ),
                  body: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      NaverMap(
                        onMapTapped: (point, latLng) {
                          if (_userVerified) {
                            if (diaries.selectedDiary != null) {
                              diaries.selectDiary(null);
                              DefaultBottomBarController.of(context).close();
                            } else {
                              DefaultBottomBarController.of(context).swap();
                            }
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
                            mapType: NMapType.basic,
                            rotationGesturesEnable: false,
                            symbolScale: 0.7,
                            buildingHeight: 2,
                            logoClickEnable: false,
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
                                : const NCameraPosition(
                                    target: NLatLng(
                                        35.95667374781408, 127.85881633921491),
                                    zoom: 6)),
                        onMapReady: (NaverMapController mapController) {
                          Future.delayed(const Duration(milliseconds: 1000),
                              () {
                            setState(() {
                              _mapReady = true;
                              loginColor = Colors.black.withOpacity(0.5);
                              loginHeight = 0;
                            });
                          });
                          _controller = mapController;
                          ;
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
              });
            }),
          ],
        );
      });
    });
  }

  List<Widget> buttonList = [];

  Widget bottomBar() {
    return Consumer<UserData>(builder: (context, user, child) {
      if (buttonList.isEmpty) {
        buttonList = List.generate(
          iconList.length,
              (index) => Flexible(
            child: MaterialButton(
              padding: const EdgeInsets.all(0),
              splashColor: Colors.transparent,
              onPressed: () {
                callDialog(index);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconList[index][0],
                    size: 25,
                  ),
                  Text(iconList[index][1], style: const TextStyle(fontSize: 9))
                ],
              ),
            ),
          ),
        );
        buttonList.add(Flexible(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width / 5,
              shape: const CircleBorder(),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => const SettingDialog());
              },
              child: CircleAvatar(
                foregroundImage: NetworkImage(user.user!.photoURL!),
                backgroundColor: Colors.grey,
              ),
            ),
          ),
        ));
      }
      return BottomAppBar(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttonList,
            ),
          ));
    });
  }


  List iconList = [
    [FontAwesomeIcons.plus, "새 일기"],
    [FontAwesomeIcons.list, "리스트"],
    [FontAwesomeIcons.thLarge, "갤러리"]
  ];

  void callDialog(int index) {
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (BuildContext context, Animation<double> a1,
          Animation<double> a2, Widget child) {
        final CurvedAnimation c = CurvedAnimation(
            parent: a1, curve: Curves.fastOutSlowIn, reverseCurve: Curves.ease);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(c),
          child: child,
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        switch (index) {
          case 0:
            return const AddNewDiaryPage();
          case 1:
            return const ListPage();
          case 2:
            return const GalleryPage();
          default:
            return const Text("Error");
        }
      },
    );
  }

  Future<void> mapLoad(DiaryProvider diaries) async {
    if (DefaultBottomBarController.of(context).isClosed) {
      DefaultBottomBarController.of(context).open();
    }
    diaries.diaries.forEach((element) {
      drawMarker(element);
    });
  }

  Future<void> drawMarker(Diary d) async {
    NOverlayImage markerImage = await NOverlayImage.fromAssetImage(
      "assets/images/marker.png",
    );
    _controller.addOverlay(clickAbleMarker(d, markerImage));
  }

  NMarker clickAbleMarker(Diary diary, NOverlayImage image) {
    NMarker marker =
        NMarker(id: diary.title, position: diary.location, icon: image);
    marker.setOnTapListener((overlay) {
      _cameraMove = false;
      diaries.selectDiary(diary);
      DefaultBottomBarController.of(context).open();

    });
    return marker;
  }

  Future<void> mapFunction(
      DiaryProvider diaries, UserData user, UIViewModel uiViewModel) async {
    if (user.user != null) {
      _userVerified = true;
      try {
        _controller.addOverlay(NMarker(
            size: const NSize(40, 40),
            id: "myLocation",
            position:
                NLatLng(user.location!.latitude, user.location!.longitude),
            icon: const NOverlayImage.fromAssetImage(
                "assets/images/myPosition.png")));
      } catch (LateInitializationError) {
        print("Map is not ready");
      }

      if (!diaries.isLoaded && _mapReady) {
        diaries.loadDiary(user.uid);
        await mapLoad(diaries);
      }

      if (diaries.selectedDiary == null) {
        if (!DefaultBottomBarController.of(context).isOpening ||
            !DefaultBottomBarController.of(context).isOpen) {
          DefaultBottomBarController.of(context).open();
        }
      } else {
        NCameraUpdate target = NCameraUpdate.scrollAndZoomTo(
            target: NLatLng(
                diaries.selectedDiary!.location.latitude - 1 / zoomLevel,
                diaries.selectedDiary!.location.longitude),
            zoom: (zoomLevel > 10) ? 10 : zoomLevel);
        target.setAnimation(
            duration: const Duration(milliseconds: 1500),
            animation: NCameraAnimation.fly);
        _controller.updateCamera(target);
      }
    } else {
      try {
        _controller.clearOverlays();
      } catch (LateInitializationError) {
        print("Map is not ready");
      }
      diaries.clearDiary();
      _userVerified = false;
      uiViewModel.setFirstLoad(true);
      DefaultBottomBarController.of(context).open();
    }
  }

  Widget bottomSheet() {
    BottomBarController bottomBarController = BottomBarController(vsync: this);
    bottomBarController.onDragEnd(DragEndDetails(velocity: Velocity.zero));
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: BottomExpandableAppBar(
          bottomAppBarColor: Colors.transparent,
          attachSide: Side.Top,
          appBarHeight: 25,
          expandedHeight: welcomeHeight,
          bottomOffset: 0,
          horizontalMargin: 0,
          bottomAppBarBody: Container(
              decoration: BoxDecoration(
                color: CustomTheme.light().scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              height: 1,
              child: GestureDetector(
                onVerticalDragUpdate:
                    DefaultBottomBarController.of(context).onDrag,
                onVerticalDragEnd:
                    DefaultBottomBarController.of(context).onDragEnd,
                child: InkWell(
                    onTap: () {
                      DefaultBottomBarController.of(context).swap();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width / 2 - 50),
                      child: const Divider(
                        thickness: 5,
                      ),
                    )),
              )),
          expandedBody: WelcomePage()),
    );
  }
}
