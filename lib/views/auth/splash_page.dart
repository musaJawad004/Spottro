import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/config.dart';
import '../../viewmodels/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      final authController = Get.find<AuthController>();
      if (authController.isAuthenticated) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppConfig.accentGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConfig.cornerRadiusXLarge),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    size: AppConfig.iconSizeXLarge * 1.5,
                    color: AppConfig.primaryColorLight,
                  ),
                ),
              ),
              SizedBox(height: AppConfig.spacingLarge),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Spottro',
                  style: TextStyle(
                    fontSize: AppConfig.fontSizeLargeHeading,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              SizedBox(height: AppConfig.spacingSmall),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Find your spot anywhere.',
                  style: TextStyle(
                    fontSize: AppConfig.fontSizeSubtitle,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(height: AppConfig.spacingXLarge * 2),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: 50.w,
                  height: 50.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
