import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/config.dart';
import '../../viewmodels/auth_controller.dart';
import '../../viewmodels/theme_controller.dart';
import '../../widgets/glass_container.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConfig.defaultPadding),
          child: Column(
            children: [
              SizedBox(height: AppConfig.spacingLarge),
              // Profile Header
              Obx(() {
                final user = authController.currentUser;
                return Column(
                  children: [
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppConfig.accentGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppConfig.primaryColorLight.withValues(alpha: 0.4),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          user?.name.substring(0, 1).toUpperCase() ?? 'U',
                          style: TextStyle(
                            fontSize: AppConfig.fontSizeLargeHeading * 1.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppConfig.spacingLarge),
                    Text(
                      user?.name ?? 'User',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: AppConfig.spacingSmall),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConfig.spacingMedium,
                        vertical: AppConfig.spacingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: AppConfig.primaryColorLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppConfig.cornerRadiusLarge),
                      ),
                      child: Text(
                        user?.email ?? 'user@example.com',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppConfig.primaryColorLight,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: AppConfig.spacingXLarge),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.favorite,
                      label: 'Favorites',
                      value: '5',
                      gradient: AppConfig.accentGradient,
                    ),
                  ),
                  SizedBox(width: AppConfig.spacingMedium),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.explore,
                      label: 'Explored',
                      value: '12',
                      gradient: AppConfig.accentGradientAlt,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppConfig.spacingXLarge),

              // Settings Section
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: AppConfig.spacingSmall),
                  child: Text(
                    'SETTINGS',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppConfig.textSecondaryLight,
                          letterSpacing: 1.2,
                        ),
                  ),
                ),
              ),
              SizedBox(height: AppConfig.spacingMedium),

              _SettingsCard(
                isDark: isDark,
                children: [
                  Obx(() => _SettingsTile(
                        icon: themeController.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        title: 'Appearance',
                        subtitle: themeController.isDarkMode ? 'Dark Mode' : 'Light Mode',
                        trailing: Switch.adaptive(
                          value: themeController.isDarkMode,
                          onChanged: (value) => themeController.setDarkMode(value),
                          activeTrackColor: AppConfig.primaryColorLight,
                        ),
                      )),
                  Container(
                    height: 3.h,
                    margin: EdgeInsets.symmetric(horizontal: AppConfig.spacingMedium),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppConfig.primaryColorLight.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage your notifications',
                    onTap: () => Get.toNamed('/notifications'),
                  ),
                  Container(
                    height: 3.h,
                    margin: EdgeInsets.symmetric(horizontal: AppConfig.spacingMedium),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppConfig.primaryColorLight.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    subtitle: 'Location preferences',
                    onTap: () {
                      Get.snackbar(
                        'Location Settings',
                        'Location settings coming soon',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: AppConfig.spacingLarge),

              // Help Section
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: AppConfig.spacingSmall),
                  child: Text(
                    'SUPPORT',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppConfig.textSecondaryLight,
                          letterSpacing: 1.2,
                        ),
                  ),
                ),
              ),
              SizedBox(height: AppConfig.spacingMedium),

              _SettingsCard(
                isDark: isDark,
                children: [
                  _SettingsTile(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    subtitle: 'Get help and support',
                    onTap: () {
                      Get.snackbar(
                        'Help Center',
                        'Help center coming soon',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  Container(
                    height: 3.h,
                    margin: EdgeInsets.symmetric(horizontal: AppConfig.spacingMedium),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppConfig.primaryColorLight.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.info_outline,
                    title: 'About Spottro',
                    subtitle: 'Version 1.0.0',
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Spottro',
                        applicationVersion: '1.0.0',
                        applicationIcon: Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                            gradient: AppConfig.accentGradient,
                            borderRadius: BorderRadius.circular(AppConfig.cornerRadiusMedium),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            size: AppConfig.iconSizeLarge,
                            color: Colors.white,
                          ),
                        ),
                        children: [
                          const Text('Find your spot anywhere.'),
                        ],
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: AppConfig.spacingXLarge),

              // Logout Button
              Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConfig.errorLight,
                      AppConfig.errorLight.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppConfig.cornerRadiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: AppConfig.errorLight.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                              authController.logout();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConfig.errorLight,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConfig.cornerRadiusLarge),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: AppConfig.iconSizeMedium),
                      SizedBox(width: AppConfig.spacingMedium),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: AppConfig.fontSizeSubtitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppConfig.bottomNavHeight),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Gradient gradient;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.all(AppConfig.spacingLarge),
      gradient: gradient,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppConfig.cornerRadiusMedium),
        ),
        padding: EdgeInsets.all(AppConfig.spacingSmall),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: AppConfig.iconSizeLarge,
            ),
            SizedBox(height: AppConfig.spacingMedium),
            Text(
              value,
              style: TextStyle(
                fontSize: AppConfig.fontSizeLargeHeading,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: AppConfig.spacingSmall),
            Text(
              label,
              style: TextStyle(
                fontSize: AppConfig.fontSizeBody,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;

  const _SettingsCard({required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppConfig.spacingLarge,
        vertical: AppConfig.spacingSmall,
      ),
      leading: Container(
        padding: EdgeInsets.all(AppConfig.spacingSmall),
        decoration: BoxDecoration(
          gradient: AppConfig.accentGradient,
          borderRadius: BorderRadius.circular(AppConfig.cornerRadiusSmall),
        ),
        child: Icon(
          icon,
          size: AppConfig.iconSizeMedium,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right,
                  size: AppConfig.iconSizeMedium,
                  color: AppConfig.textSecondaryLight,
                )
              : null),
      onTap: onTap,
    );
  }
}
