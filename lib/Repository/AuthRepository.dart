import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:intertravel/DataSource/AuthDataSource.dart";
import "package:intertravel/ViewModel/UserData.dart";
import "package:shared_preferences/shared_preferences.dart";

class AuthRepository {

  AuthDataSource _authDataSource = AuthDataSource();

  Future<UserCredential?> signInWithGoogle(UserData userdata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserCredential? user = await _authDataSource.signWithGoogle(userdata);
    if (user != null) {
      addUserToFirestore();
    }

    return user;
  }


  Future<void> addUserToFirestore() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Firestore의 'users' 컬렉션에 문서 추가
      // 문서 ID로 사용자의 UID를 사용
      await FirebaseFirestore.instance.collection('users')
          .doc(currentUser.uid)
          .set({
        'uid': currentUser.uid,
        'email': currentUser.email,
        // 추가하고 싶은 다른 사용자 정보 필드
        'displayName': currentUser.displayName,
        // 'profilePicture': currentUser.photoURL, // 프로필 사진 URL 등
      });
    }
  }
}