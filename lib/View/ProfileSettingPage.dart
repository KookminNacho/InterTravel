import 'package:flutter/material.dart';
import 'package:intertravel/View/Privacy.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../ViewModel/DiaryProvider.dart';
import '../ViewModel/UserData.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({super.key});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('계정 설정', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        NetworkImage(userData.user?.photoURL ?? ''),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () => unReleasedFunction('프로필 사진 변경'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              userData.user?.displayName ?? '사용자',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              userData.user?.email ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            _buildSettingSection('계정 설정', [
              _buildSettingTile(
                  '닉네임 변경', Icons.person, () => unReleasedFunction('닉네임 변경')),
              _buildSettingTile(
                  '비밀번호 변경', Icons.lock, () => unReleasedFunction('비밀번호 변경')),
              _buildSettingTile(
                  '이메일 변경', Icons.email, () => unReleasedFunction('이메일 변경')),
            ]),
            _buildSettingSection('기타', [
              _buildSettingTile(
                  '데이터 백업', Icons.backup, () => unReleasedFunction('데이터 백업')),
              _buildSettingTile(
                  '개인정보 처리방침',
                  Icons.privacy_tip,
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Privacy()))),
              _buildSettingTile('로그아웃', Icons.exit_to_app, signOutDialog),
              _buildSettingTile(
                  '회원 탈퇴', Icons.delete_forever, deleteAccountDialog,
                  textColor: Colors.red),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSection(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blue),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: tiles),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSettingTile(String title, IconData icon, VoidCallback onTap,
      {Color textColor = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void unReleasedFunction(String feature) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature 기능은 현재 개발 중입니다. 곧 만나보실 수 있습니다!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void signOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('로그아웃 하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: signOut,
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void signOut() {
    Provider.of<UserData>(context, listen: false)
        .signOut(Provider.of<DiaryProvider>(context, listen: false));
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  bool btnEnabled = false;

  void deleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteAccountDialog();
      },
    );
  }


}

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  bool btnEnabled = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('회원 탈퇴'),
      content: SizedBox(
        height: 150,
        child: Column(
          children: [
            const Text(
              '정말로 탈퇴하시나요?\n이 작업은 되돌릴 수 없어요.\n아래 빈칸에 "탈퇴"를 적어주세요',
              textAlign: TextAlign.center,
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                if (value == '탈퇴') {
                  setState(() {
                    btnEnabled = true;
                  });
                } else {
                  setState(() {
                    btnEnabled = false;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        TextButton(
          style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.red)),
          onPressed: (btnEnabled) ? deleteAccount : null,
          child: Text('확인',
              style: TextStyle(color: (btnEnabled) ? Colors.red : Colors.grey)),
        ),
      ],
    );
  }
  void deleteAccount() {
    Provider.of<DiaryProvider>(context, listen: false).deleteAllDiaries();
    Provider.of<UserData>(context, listen: false)
        .deleteAccount(Provider.of<DiaryProvider>(context, listen: false));
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}