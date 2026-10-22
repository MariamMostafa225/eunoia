import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_mark.dart';
import '../widgets/theme_toggle_button.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OnboardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ThemeToggleButton(),
                ),
              ),
              Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  BrandMark(light: true),
                  SizedBox(height: 44),
                  Text('EUNOIA', style: TextStyle(color: AppColors.cream, fontSize: 25, letterSpacing: 2)),
                  SizedBox(height: 14),
                  Text('مساحتك الهادئة للرفاهية', style: TextStyle(color: AppColors.muted, fontSize: 19)),
                ]),
              ),
            ],
          ),
        ),
      );
}
