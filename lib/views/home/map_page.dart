import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/config.dart';
import '../../viewmodels/home_controller.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppConfig.defaultPaddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    gradient: AppConfig.accentGradient,
                    borderRadius: BorderRadius.circular(AppConfig.cornerRadiusXLarge),
                    boxShadow: [
                      BoxShadow(
                        color: AppConfig.primaryColorLight.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.map_outlined,
                    size: AppConfig.iconSizeXLarge * 1.5,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppConfig.spacingXLarge),
                Text(
                  'Map View',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppConfig.spacingMedium),
                Text(
                  'Maps removed from this build',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppConfig.spacingXLarge),
                Container(
                  padding: EdgeInsets.all(AppConfig.spacingLarge),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppConfig.surfaceDark
                        : AppConfig.surfaceLight,
                    borderRadius: BorderRadius.circular(AppConfig.cornerRadiusMedium),
                    border: Border.all(
                      color: AppConfig.primaryColorLight.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppConfig.primaryColorLight,
                            size: AppConfig.iconSizeMedium,
                          ),
                          SizedBox(width: AppConfig.spacingMedium),
                          Text(
                            'Setup Required',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppConfig.primaryColorLight,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppConfig.spacingMedium),
                      Text('This screen is kept for reference only', style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: AppConfig.spacingMedium),
                      Text(
                        'See SETUP_GUIDE.md for detailed instructions',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppConfig.textSecondaryLight,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppConfig.spacingXLarge),
                Obx(() {
                  final placesCount = homeController.places.length;
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConfig.spacingLarge,
                      vertical: AppConfig.spacingMedium,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppConfig.accentGradient,
                      borderRadius: BorderRadius.circular(AppConfig.cornerRadiusLarge),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: AppConfig.iconSizeMedium,
                        ),
                        SizedBox(width: AppConfig.spacingMedium),
                        Text(
                          '$placesCount places ready to explore',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppConfig.fontSizeBody,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
