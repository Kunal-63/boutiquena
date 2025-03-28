import 'package:vendor_app/config/text_styles.dart';
import 'package:vendor_app/config/theme.dart';
import 'package:vendor_app/utils/secure_storage.dart' as storage;
import 'package:vendor_app/utils/size_config.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkLoginStatus() async {
    bool loggedIn = await storage.LoginStatusUtil.isLoggedIn();
    if (loggedIn) {
      Navigator.pushReplacementNamed(context, '/main_screen');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () async {
      FlutterNativeSplash.remove();
      checkLoginStatus();
    });
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [
          Permission.camera,
          Permission.storage, // For older Android versions
          Permission.photos, // For Android 13+ (READ_MEDIA_IMAGES)
        ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    Future.delayed(const Duration(seconds: 3), () {
      if (allGranted) {
        print("All permissions granted. Navigating to login...");
      } else {
        print("Some permissions denied. Navigating to login anyway...");
      }
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 130 * SizeConfig.widthScale,
              height: 130 * SizeConfig.widthScale,
              child: Image.asset(
                'assets/logo/splash_logo.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print("Error loading splash image: $error");
                  return Icon(Icons.error, size: 50, color: Colors.red);
                },
              ),
            ),
            SizedBox(height: 5 * SizeConfig.heightScale),
            RichText(
              text: TextSpan(
                text: 'BOUTIQUE',
                style: AppTextStyles.loginHeadingStyle().copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: 5.0,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'NA',
                    style: AppTextStyles.loginHeadingStyle().copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 5.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2 * SizeConfig.heightScale),
            Text(
              'Vendor',
              style: AppTextStyles.loginSubHeadingStyle(
                color: const Color.fromRGBO(35, 46, 65, 0.93),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
