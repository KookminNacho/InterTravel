import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModel/UserPermission.dart';

class PermissionRequestPage extends StatelessWidget {
  const PermissionRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.location_on,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              Text(
                '위치 권한이 필요합니다',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '여행사이 앱은 여러분의 여행 경험을 더욱 풍부하게 만들기 위해 위치 정보를 사용합니다. 정확한 위치 기록과 지도 기능을 위해 권한을 허용해 주세요.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  context.read<UserPermission>().requestLocationPermission();
                },
                child: const Text(
                  "위치 권한 허용하기",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}