// import 'dart:typed_data';
//
// import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_naver_map/flutter_naver_map.dart';
// import 'package:intertravel/View/AddNewDiaryPage.dart';
// import 'package:intertravel/View/DIalog/ListDialog.dart';
// import 'package:intertravel/View/LoginPage.dart';
// import 'package:intertravel/ViewModel/DiaryProvider.dart';
// import 'package:intertravel/ViewModel/UIViewMode.dart';
// import 'package:intertravel/ViewModel/UserPermission.dart';
// import 'package:intertravel/WelcomePage.dart';
// import 'package:provider/provider.dart';
//
// import '../Model/Diary.dart';
// import '../Util/Constrains.dart';
// import '../ViewModel/ImageProvider.dart';
// import '../ViewModel/UserData.dart';
// import 'DIalog/SettingDialog.dart';
//
// class MainPage extends StatefulWidget {
//   const MainPage({super.key});
//
//   @override
//   State<MainPage> createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
//   late NaverMapController _controller;
//   bool _userVerified = false;
//   bool _cameraMove = false;
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       UserData provider = Provider.of<UserData>(context, listen: false);
//       provider.autoLogin();
//
//       await provider.getLocation();
//     });
//     generateButtonList();
//     super.initState();
//   }
//
//   void mapFunction(
//       DiaryProvider diaries, UserData user, UIViewModel uiViewModel) {
//     if (user.user != null) {
//       _userVerified = true;
//
//       if (diaries.isLoaded) {
//         mapLoad(user, diaries);
//       }
//       if (diaries.selectedDiary != null) {
//         if (!DefaultBottomBarController.of(context).isOpening ||
//             DefaultBottomBarController.of(context).isOpen) {
//           DefaultBottomBarController.of(context).open();
//         }
//         NCameraUpdate target = NCameraUpdate.scrollAndZoomTo(
//             target: diaries.selectedDiary!.location, zoom: 10);
//         target.setAnimation(
//             duration: const Duration(milliseconds: 1500),
//             animation: NCameraAnimation.fly);
//         _controller.updateCamera(target);
//       }
//
//       if (uiViewModel.firstLoad) {
//         diaries.loadDiary(user.uid);
//         DefaultBottomBarController.of(context).open();
//
//         // **** State 관리가 필요함 ****
//         uiViewModel.setFirstLoad(false);
//       }
//     } else {
//       try {
//         _controller.clearOverlays();
//       } catch (LateInitializationError) {
//         print("Map is not ready");
//       }
//       diaries.clearDiary();
//       _userVerified = false;
//       uiViewModel.setFirstLoad(true);
//       DefaultBottomBarController.of(context).open();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<DiaryProvider>(builder: (context, diaries, child) {
//       return Selector<UserPermission, bool>(
//         selector: (_, permission) => permission.locationPermission,
//         builder: (context, locationPermission, child) {
//           return locationPermission
//               ? Selector<ImageProviderModel, bool>(
//                   selector: (_, imageProvider) {
//                   return imageProvider.isLoaded;
//                 }, builder: (context, isLoaded, child) {
//                   return Stack(
//                     children: [
//                       Consumer<UIViewModel>(
//                           builder: (context, uiViewModel, child) {
//                         return Consumer<UserData>(
//                             builder: (context, user, child) {
//                           mapFunction(diaries, user, uiViewModel);
//                           return Scaffold(
//                             bottomSheet: bottomNavBar(),
//                             floatingActionButtonLocation:
//                                 ExpandableFab.location,
//                             floatingActionButton:
//                                 (diaries.isLoaded && _userVerified)
//                                     ? floatingButton(user)
//                                     : Container(),
//                             body: Stack(
//                               alignment: Alignment.bottomCenter,
//                               children: [
//                                 NaverMap(
//                                   onMapTapped: (point, latLng) {
//                                     if (_userVerified) {
//                                       if (diaries.selectedDiary != null) {
//                                         diaries.selectDiary(null);
//                                         DefaultBottomBarController.of(context)
//                                             .close();
//                                       }
//                                       DefaultBottomBarController.of(context)
//                                           .swap();
//                                     }
//                                   },
//                                   onCameraChange: (reason, isGesture) {
//                                     if (reason == NCameraUpdateReason.gesture) {
//                                       if (!DefaultBottomBarController.of(
//                                               context)
//                                           .isClosing) {
//                                         DefaultBottomBarController.of(context)
//                                             .close();
//                                       }
//                                     }
//                                   },
//                                   onCameraIdle: () async {
//                                     if (_cameraMove) {
//                                       _cameraMove = false;
//                                     }
//                                   },
//                                   options: NaverMapViewOptions(
//                                       extent: const NLatLngBounds(
//                                         southWest: NLatLng(31.43, 122.37),
//                                         northEast: NLatLng(44.35, 132.0),
//                                       ),
//                                       minZoom: 6,
//                                       initialCameraPosition:
//                                           (diaries.selectedDiary != null)
//                                               ? NCameraPosition(
//                                                   target: diaries
//                                                       .selectedDiary!.location,
//                                                   zoom: 10)
//                                               : NCameraPosition(
//                                                   target: NLatLng(
//                                                       35.95667374781408,
//                                                       127.85881633921491),
//                                                   zoom: 6)),
//                                   onMapReady:
//                                       (NaverMapController mapController) {
//                                     Future.delayed(Duration(milliseconds: 1000),
//                                         () {
//                                       setState(() {
//                                         loginColor =
//                                             Colors.black.withOpacity(0.5);
//                                         loginHeight = 0;
//                                       });
//                                     });
//                                     _controller = mapController;
//                                   },
//                                 ),
//                                 (_userVerified)
//                                     ? Container()
//                                     : Container(
//                                         height:
//                                             MediaQuery.of(context).size.height,
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         color: Colors.black.withOpacity(0.2),
//                                       ),
//                               ],
//                             ),
//                           );
//                         });
//                       }),
//                       (isLoaded)
//                           ? Container()
//                           : Center(
//                               child: Container(
//                                 color: Colors.black26,
//                                 child: CircularProgressIndicator(),
//                                 width: 100,
//                                 height: 100,
//                               ),
//                             ),
//                     ],
//                   );
//                 })
//               : Center(
//                   child: ElevatedButton(
//                       onPressed: () {
//                         context
//                             .read<UserPermission>()
//                             .requestLocationPermission();
//                       },
//                       child: Text("권한을 허용해주세요")),
//                 );
//         },
//       );
//     });
//   }
//
//   Widget floatingButton(UserData user) {
//     return Consumer<UserData>(builder: (context, uuser, child) {
//       return SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             GestureDetector(
//                 onVerticalDragUpdate:
//                     DefaultBottomBarController.of(context).onDrag,
//                 onVerticalDragEnd:
//                     DefaultBottomBarController.of(context).onDragEnd,
//                 child: ExpandableFab(
//                     openButtonBuilder: RotateFloatingActionButtonBuilder(
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: user.photo,
//                       ),
//                       fabSize: ExpandableFabSize.regular,
//                       foregroundColor: Colors.amber,
//                       backgroundColor: Colors.white,
//                       shape: const CircleBorder(
//                         side: BorderSide(color: Colors.grey, width: 1),
//                       ),
//                     ),
//                     closeButtonBuilder: RotateFloatingActionButtonBuilder(
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: user.photo,
//                       ),
//                       fabSize: ExpandableFabSize.regular,
//                       foregroundColor: Colors.deepOrangeAccent,
//                       backgroundColor: Colors.grey,
//                       shape: const CircleBorder(),
//                     ),
//                     type: ExpandableFabType.values[2],
//                     distance: 60.0,
//                     children: floatingButtonList)),
//           ],
//         ),
//       );
//     });
//   }
//
//   void mapLoad(UserData user, DiaryProvider diaries) async {
//     if (DefaultBottomBarController.of(context).isClosed) {
//       DefaultBottomBarController.of(context).open();
//     }
//
//     ImageProviderModel imageProvider =
//         Provider.of<ImageProviderModel>(context, listen: false);
//     for (int i = 0; i < diaries.diaries.length; i++) {
//       Diary d = diaries.diaries[i];
//       if (imageProvider.images[d.imageURI]?[0] == null) {
//         await imageProvider.loadImage(diaries, i);
//       }
//       while (imageProvider.images[d.imageURI[0]] == null) {
//         await Future.delayed(const Duration(milliseconds: 100));
//       }
//       drawMarker(d, imageProvider);
//     }
//   }
//
//   Future<void> drawEmptyMarker(Diary d) async {
//     NMarker marker = NMarker(
//         id: d.title,
//         position: d.location,
//         icon: await NOverlayImage.fromWidget(
//             widget: Container(color: Colors.red),
//             size: Size(45, 45),
//             context: context));
//     _controller.addOverlay(marker);
//   }
//
//   void drawMarker(Diary d, ImageProviderModel imageProviderModel) async {
//     // 이미지 URI에서 이미지를 가져옵니다.
//     Uint8List? img = imageProviderModel.images[d.imageURI[0]]?[0];
//
//     // 이미지가 null이 아닌지 확인합니다.
//     if (img != null) {
//       // Image.memory를 사용하여 이미지 위젯을 생성합니다.
//       Image image = Image.memory(img, fit: BoxFit.cover);
//
//       // NOverlayImage를 생성하기 위해 비동기적으로 위젯을 변환합니다.
//       NOverlayImage markerImage = await NOverlayImage.fromWidget(
//         widget: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(4),
//             border: Border.all(color: Colors.grey, width: 1),
//             color: Colors.grey,
//           ),
//           padding: const EdgeInsets.all(4.0),
//           child: image,
//         ),
//         size: Size(45, 45),
//         context: context,
//       );
//       // showDialog(context: context, builder: (context) => AlertDialog(content: image,));
//       _controller.addOverlay(clickAbleMarker(d, markerImage));
//     } else {
//       // 이미지가 없을 경우 오류를 출력합니다.
//       print("이미지가 없습니다. ${d.title}");
//     }
//   }
//
//   NMarker clickAbleMarker(Diary diary, NOverlayImage image) {
//     NMarker marker =
//         NMarker(id: diary.title, position: diary.location, icon: image);
//     marker.setOnTapListener((overlay) async {
//       _cameraMove = false;
//       DefaultBottomBarController.of(context).open();
//       Provider.of<DiaryProvider>(context, listen: false).selectDiary(diary);
//       NCameraUpdate move = NCameraUpdate.scrollAndZoomTo(
//           target: NLatLng(diary.location.latitude, diary.location.longitude),
//           zoom: 10);
//       move.setAnimation(
//           animation: NCameraAnimation.fly,
//           duration: const Duration(milliseconds: 1500));
//       _controller.updateCamera(move);
//     });
//     return marker;
//   }
//
//   List iconList = [
//     [Icons.add, "새 일기"],
//     [Icons.list, "리스트"],
//     [Icons.settings, "설정"]
//   ];
//
//   void generateButtonList() {
//     for (int i = 0; i < 3; i++) {
//       floatingButtonList.add(FloatingActionButton(
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(24.0))),
//         onPressed: () {
//           callDialog(i);
//           DefaultBottomBarController.of(context).close();
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(),
//             Icon(iconList[i][0]),
//             Text("${iconList[i][1]}", style: TextStyle(fontSize: 8))
//           ],
//         ),
//       ));
//     }
//   }
//
//   List<Widget> floatingButtonList = [];
//
//   void callDialog(int index) {
//     showGeneralDialog(
//       context: context,
//       transitionDuration: const Duration(milliseconds: 250),
//       transitionBuilder: (BuildContext context, Animation<double> a1,
//           Animation<double> a2, Widget child) {
//         return FadeTransition(
//           opacity: CurvedAnimation(
//             parent: a1,
//             curve: Curves.easeInBack,
//           ),
//           child: child,
//         );
//       },
//       pageBuilder: (BuildContext context, Animation<double> animation,
//           Animation<double> secondaryAnimation) {
//         switch (index) {
//           case 0:
//             return AddNewDiaryPage();
//           case 1:
//             return const ListDialog();
//           case 2:
//             return const SettingDialog();
//           default:
//             return const Text("Error");
//         }
//       },
//     );
//   }
//
//   Widget bottomNavBar() {
//     UserData user = Provider.of<UserData>(context, listen: false);
//     BottomBarController bottomBarController = BottomBarController(vsync: this);
//     bottomBarController.onDragEnd(DragEndDetails(velocity: Velocity.zero));
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//       ),
//       child: BottomExpandableAppBar(
//           attachSide: Side.Top,
//           appBarHeight: 10,
//           expandedHeight: welcomeHeight,
//           bottomOffset: 0,
//           horizontalMargin: 16,
//           expandedBody: (user.user == null) ? LoginPage() : WelcomePage()),
//     );
//   }
// }



import 'dart:typed_data';

import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intertravel/View/AddNewDiaryPage.dart';
import 'package:intertravel/View/DIalog/ListDialog.dart';
import 'package:intertravel/View/LoginPage.dart';
import 'package:intertravel/ViewModel/DiaryProvider.dart';
import 'package:intertravel/ViewModel/UIViewMode.dart';
import 'package:intertravel/ViewModel/UserPermission.dart';
import 'package:intertravel/WelcomePage.dart';
import 'package:provider/provider.dart';

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
  bool _cameraMove = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserData provider = Provider.of<UserData>(context, listen: false);
      provider.autoLogin();
      await provider.getLocation();
    });
    generateButtonList();
    super.initState();
  }

  void mapFunction(
      DiaryProvider diaries, UserData user, UIViewModel uiViewModel) {
    if (user.user != null) {
      _userVerified = true;

      if (diaries.isLoaded) {
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
      }

      if (uiViewModel.firstLoad) {
        diaries.loadDiary(user.uid);
        DefaultBottomBarController.of(context).open();
        uiViewModel.setFirstLoad(false);
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

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryProvider>(builder: (context, diaries, child) {
      return Selector<UserPermission, bool>(
        selector: (_, permission) => permission.locationPermission,
        builder: (context, locationPermission, child) {
          return locationPermission
              ? Selector<ImageProviderModel, bool>(
              selector: (_, imageProvider) {
                return imageProvider.isLoaded;
              }, builder: (context, isLoaded, child) {
            return Stack(
              children: [
                Consumer<UIViewModel>(
                    builder: (context, uiViewModel, child) {
                      return Consumer<UserData>(
                          builder: (context, user, child) {
                            mapFunction(diaries, user, uiViewModel);
                            return Scaffold(
                              bottomSheet: bottomNavBar(),
                              floatingActionButtonLocation:
                              ExpandableFab.location,
                              floatingActionButton:
                              (diaries.isLoaded && _userVerified)
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
                                          DefaultBottomBarController.of(context)
                                              .close();
                                        }
                                        DefaultBottomBarController.of(context)
                                            .swap();
                                      }
                                    },
                                    onCameraChange: (reason, isGesture) {
                                      if (reason == NCameraUpdateReason.gesture) {
                                        if (!DefaultBottomBarController.of(
                                            context)
                                            .isClosing) {
                                          DefaultBottomBarController.of(context)
                                              .close();
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
                                        initialCameraPosition:
                                        (diaries.selectedDiary != null)
                                            ? NCameraPosition(
                                            target: diaries
                                                .selectedDiary!.location,
                                            zoom: 10)
                                            : NCameraPosition(
                                            target: NLatLng(
                                                35.95667374781408,
                                                127.85881633921491),
                                            zoom: 6)),
                                    onMapReady:
                                        (NaverMapController mapController) {
                                      Future.delayed(Duration(milliseconds: 1000),
                                              () {
                                            setState(() {
                                              loginColor =
                                                  Colors.black.withOpacity(0.5);
                                              loginHeight = 0;
                                            });
                                          });
                                      _controller = mapController;
                                    },
                                  ),
                                  (_userVerified)
                                      ? Container()
                                      : Container(
                                    height:
                                    MediaQuery.of(context).size.height,
                                    width:
                                    MediaQuery.of(context).size.width,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            );
                          });
                    }),
                if (!isLoaded)
                  Center(
                    child: Container(
                      color: Colors.black26,
                      child: CircularProgressIndicator(),
                      width: 100,
                      height: 100,
                    ),
                  ),
              ],
            );
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
        },
      );
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

  void mapLoad(UserData user, DiaryProvider diaries) async {
    if (DefaultBottomBarController.of(context).isClosed) {
      DefaultBottomBarController.of(context).open();
    }

    ImageProviderModel imageProvider =
    Provider.of<ImageProviderModel>(context, listen: false);
    for (int i = 0; i < diaries.diaries.length; i++) {
      Diary d = diaries.diaries[i];
      if (imageProvider.images[d.imageURI]?[0] == null) {
        await imageProvider.loadImage(diaries, i);
      }
      while (imageProvider.images[d.imageURI[0]] == null) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      drawMarker(d, imageProvider);
    }
  }

  Future<void> drawEmptyMarker(Diary d) async {
    NMarker marker = NMarker(
        id: d.title,
        position: d.location,
        icon: await NOverlayImage.fromWidget(
            widget: Container(color: Colors.red),
            size: Size(45, 45),
            context: context));
    _controller.addOverlay(marker);
  }

  void drawMarker(Diary d, ImageProviderModel imageProviderModel) async {
    Uint8List? img = imageProviderModel.images[d.imageURI[0]]?[0];

    if (img != null) {
      Image image = Image.memory(img, fit: BoxFit.cover);

      NOverlayImage markerImage = await NOverlayImage.fromWidget(
        widget: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey, width: 1),
            color: Colors.grey,
          ),
          padding: const EdgeInsets.all(4.0),
          child: image,
        ),
        size: Size(45, 45),
        context: context,
      );

      _controller.addOverlay(clickAbleMarker(d, markerImage));
    } else {
      print("이미지가 없습니다. ${d.title}");
    }
  }

  NMarker clickAbleMarker(Diary diary, NOverlayImage image) {
    NMarker marker =
    NMarker(id: diary.title, position: diary.location, icon: image);
    marker.setOnTapListener((overlay) async {
      _cameraMove = false;
      DefaultBottomBarController.of(context).open();
      Provider.of<DiaryProvider>(context, listen: false).selectDiary(diary);
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

  Widget bottomNavBar() {
    UserData user = Provider.of<UserData>(context, listen: false);
    BottomBarController bottomBarController = BottomBarController(vsync: this);
    bottomBarController.onDragEnd(DragEndDetails(velocity: Velocity.zero));
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: BottomExpandableAppBar(
          attachSide: Side.Top,
          appBarHeight: 10,
          expandedHeight: welcomeHeight,
          bottomOffset: 0,
          horizontalMargin: 16,
          expandedBody: (user.user == null) ? LoginPage() : WelcomePage()),
    );
  }
}
