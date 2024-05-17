import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';

import '../Model/Diary.dart';
import '../Util/Constrains.dart';
import '../ViewModel/DiaryProvider.dart';
import '../ViewModel/ImageProvider.dart';
import '../ViewModel/UIViewMode.dart';
import '../ViewModel/UserData.dart';
import '../ViewModel/UserPermission.dart';
import '../WelcomePage.dart';
import 'AddNewDiaryPage.dart';
import 'DIalog/ListDialog.dart';
import 'DIalog/SettingDialog.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  bool _userVerified = false;
  bool _cameraMove = false;
  late NaverMapController _controller;
  double zoomLevel = 10;

  @override
  void initState() {
    super.initState();
    generateButtonList();
    UserData user = Provider.of<UserData>(context, listen: false);
    if (user.location == null) {
      user.getLocation();
    }
    DiaryProvider diaries = Provider.of<DiaryProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await diaries.loadDiary(user.uid);
      await mapLoad(diaries);
    });
    DefaultBottomBarController.of(context).open();
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
                  backgroundColor: Colors.white,
                  bottomSheet: bottomNavBar(),
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
                          Future.delayed(Duration(milliseconds: 1000), () {
                            setState(() {
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

  Widget floatingButton(UserData user) {
    return Consumer<UserData>(builder: (context, uuser, child) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
                onVerticalDragUpdate:
                    DefaultBottomBarController.of(context).onDrag,
                onVerticalDragEnd:
                    DefaultBottomBarController.of(context).onDragEnd,
                child: ExpandableFab(
                    openButtonBuilder: RotateFloatingActionButtonBuilder(
                      heroTag: "FloatingButton1",
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
                      heroTag: "FloatingButton2",
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

  List iconList = [
    [Icons.add, "새 일기"],
    [Icons.list, "리스트"],
    [Icons.settings, "설정"]
  ];

  void callDialog(int index) {
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (BuildContext context, Animation<double> a1,
          Animation<double> a2, Widget child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: a1,
            curve: Curves.easeInBack,
          ),
          child: child,
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        switch (index) {
          case 0:
            return AddNewDiaryPage();
          case 1:
            return const ListDialog();
          case 2:
            return const SettingDialog();
          default:
            return const Text("Error");
        }
      },
    );
  }

  void generateButtonList() {
    for (int i = 0; i < 3; i++) {
      floatingButtonList.add(FloatingActionButton(
        heroTag: iconList[i][1],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        onPressed: () {
          callDialog(i);
          DefaultBottomBarController.of(context).close();
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

  Future<void> mapLoad(DiaryProvider diaries) async {
    if (DefaultBottomBarController.of(context).isClosed) {
      DefaultBottomBarController.of(context).open();
    }
    diaries.diaries.forEach((element) {
      drawMarker(element);
    });
  }

  void drawMarker(Diary d) {
    NOverlayImage markerImage =
        const NOverlayImage.fromAssetImage("assets/images/marker.png");
    _controller.addOverlay(clickAbleMarker(d, markerImage));
  }

  NMarker clickAbleMarker(Diary diary, NOverlayImage image) {
    NMarker marker =
        NMarker(id: diary.title, position: diary.location, icon: image);
    marker.setOnTapListener((overlay) {
      _cameraMove = false;
      DefaultBottomBarController.of(context).open();
      Provider.of<DiaryProvider>(context, listen: false).selectDiary(diary);
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
      if (diaries.selectedDiary != null) {
        if (!DefaultBottomBarController.of(context).isOpening ||
            DefaultBottomBarController.of(context).isOpen) {
          DefaultBottomBarController.of(context).open();
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

  Widget bottomNavBar() {
    BottomBarController bottomBarController = BottomBarController(vsync: this);
    bottomBarController.onDragEnd(DragEndDetails(velocity: Velocity.zero));
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: BottomExpandableAppBar(
        bottomAppBarColor: Colors.white,
          attachSide: Side.Top,
          appBarHeight: 30,
          expandedHeight: welcomeHeight,
          bottomOffset: 25,
          horizontalMargin: 0,
          bottomAppBarBody: Container(
              height: 25,
              color: Colors.white,
              child: GestureDetector(
                onVerticalDragUpdate:
                    DefaultBottomBarController.of(context).onDrag,
                onVerticalDragEnd:
                    DefaultBottomBarController.of(context).onDragEnd,
                child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        DefaultBottomBarController.of(context).swap();
                      });
                    },
                    child: const Icon(Icons.keyboard_arrow_up,
                        size: 30)),
              )),
          expandedBody: const WelcomePage()),
    );
  }
}
