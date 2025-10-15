import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'config/config.dart';
import 'viewmodels/auth_controller.dart';
import 'viewmodels/theme_controller.dart';
import 'viewmodels/home_controller.dart';
import 'viewmodels/notification_controller.dart';
import 'views/auth/splash_page.dart';
import 'views/auth/login_page.dart';
import 'views/auth/register_page.dart';
import 'views/home/main_navigation.dart';
import 'views/home/notification_page.dart';
import 'views/home/place_detail_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  initControllers();

  runApp(const MyApp());
}

void initControllers() {
  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(HomeController());
  Get.put(NotificationController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: const SplashPage(),
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Spottro',
          debugShowCheckedModeBanner: false,
          theme: AppConfig.lightTheme,
          darkTheme: AppConfig.darkTheme,
          themeMode: ThemeMode.light, // Default to light mode
          home: child,
          getPages: [
            GetPage(
              name: '/splash',
              page: () => const SplashPage(),
              transition: Transition.fade,
              transitionDuration: AppConfig.animationMedium,
            ),
            GetPage(
              name: '/login',
              page: () => const LoginPage(),
              transition: Transition.fadeIn,
              transitionDuration: AppConfig.animationMedium,
            ),
            GetPage(
              name: '/register',
              page: () => const RegisterPage(),
              transition: Transition.rightToLeft,
              transitionDuration: AppConfig.animationMedium,
            ),
            GetPage(
              name: '/home',
              page: () => const MainNavigation(),
              transition: Transition.fadeIn,
              transitionDuration: AppConfig.animationMedium,
            ),
            GetPage(
              name: '/notifications',
              page: () => const NotificationPage(),
              transition: Transition.rightToLeft,
              transitionDuration: AppConfig.animationMedium,
            ),
            GetPage(
              name: '/place-detail',
              page: () => const PlaceDetailPage(),
              transition: Transition.rightToLeft,
              transitionDuration: AppConfig.animationMedium,
            ),
          ],
        );
      },
    );
  }
}
