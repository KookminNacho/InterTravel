import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:intertravel/ViewModel/UserData.dart";

import "../DataSource/UserDataSource.dart";
import "../Model/SavedUserData.dart";

class UserRepository {
  final UserDataSource _authDataSource = UserDataSource();

  Future<void> updateTag(List<String> tags) async {
    // 중복 태그 제거
    tags = tags.toSet().toList();
    print("태그 모음: $tags");
    await _authDataSource.updateTag(tags);
  }

  Future<UserCredential?> signInWithGoogle(UserData userdata) async {
    UserCredential? user = await _authDataSource.signWithGoogle(userdata);
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (user != null) {
      firestore.collection('users').doc(user.user!.uid).get().then((doc) {
        if (!doc.exists) {
          addUserToFirestore();
        }
      });
    }
    return user;
  }

  Future<void> updateSuggestions(List<Map<String, DateTime>> list) async {
    await _authDataSource.updateSuggestions(list);
  }

  Future<SavedUserData> loadSavedUserData(UserData userdata) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final savedUserData =
        await firestore.collection('users').doc(userdata.uid).get();
    if (savedUserData.exists) {
      print(savedUserData.get('lastSuggestions'));
      List<Map<String, DateTime>> suggestions = (savedUserData.get('lastSuggestions') as List<dynamic>?)
          ?.map((item) => Map<String, DateTime>.from(
          item.map((key, value) => MapEntry(key, (value as Timestamp).toDate()))))
          .toList() ?? [];
      return SavedUserData(
        uid: savedUserData.get('uid'),
        email: savedUserData.get('email'),
        displayName: savedUserData.get('displayName'),
        tags: List<String>.from(savedUserData.get('tags')),
        lastSuggestions: suggestions,
      );
    } else {
      return SavedUserData(
        uid: "",
        email: "",
        displayName: "",
        tags: [],
        lastSuggestions: [],
      );
    }
  }

  Future<void> addUserToFirestore() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Firestore의 'users' 컬렉션에 문서 추가
      // 문서 ID로 사용자의 UID를 사용
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set({
        'uid': currentUser.uid,
        'email': currentUser.email,
        // 추가하고 싶은 다른 사용자 정보 필드
        'displayName': currentUser.displayName,
        'tags': [],
        // 'profilePicture': currentUser.photoURL, // 프로필 사진 URL 등
      });
    }
  }
}
