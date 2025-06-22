import 'package:flutter/material.dart';
import 'package:kevit_prac/screens/auth/login.dart';
import 'dart:async';

import 'package:kevit_prac/screens/feed/feed.dart';
import 'package:kevit_prac/utils/my_color.dart';
import 'package:kevit_prac/utils/style.dart';

class SplashScreen extends StatefulWidget {
  final String hasLogin;
  const SplashScreen({required this.hasLogin});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>  widget.hasLogin.isNotEmpty ? FeedScreen() : LoginScreen(),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: child,
          ),
          transitionDuration: Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [MyColor.primaryColor, MyColor.secondryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child:Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt_rounded, size: 80, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  "Kevit Practical",
                  style: outfitifBoldText.copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Social Media App",
                  style: outfitifMediumText.copyWith(color: Colors.white70, fontSize: 14),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
