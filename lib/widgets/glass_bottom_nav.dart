import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../config/config.dart';

class GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 75.h,
      margin: EdgeInsets.all(AppConfig.spacingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConfig.cornerRadiusXLarge),
        boxShadow: [
          BoxShadow(
            color: AppConfig.primaryColorLight.withValues(alpha: 0.15),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConfig.cornerRadiusXLarge),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        // More translucent for glass effect in dark mode
                        Colors.white.withValues(alpha: 0.10),
                        Colors.white.withValues(alpha: 0.06),
                      ]
                    : [
                        // Fresher, glassy translucency for light mode
                        Colors.white.withValues(alpha: 0.60),
                        Colors.white.withValues(alpha: 0.30),
                      ],
              ),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.6),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(AppConfig.cornerRadiusXLarge),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: TablerIcons.home,
                  label: 'Home',
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                  isDark: isDark,
                ),
                _NavItem(
                  icon: TablerIcons.heart,
                  label: 'Favorites',
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                  isDark: isDark,
                ),
                _NavItem(
                  icon: TablerIcons.user,
                  label: 'Profile',
                  isSelected: currentIndex == 2,
                  onTap: () => onTap(2),
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Clear, visible colors for unselected state
    final Color unselectedColor = widget.isDark
        ? Colors
              .grey
              .shade400 // Light grey for dark mode
        : Colors.grey.shade700; // Dark grey for light mode

    final Color selectedColor = AppConfig.primaryColorLight;

    return Expanded(
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon with gradient background when selected
                    AnimatedContainer(
                      duration: AppConfig.animationMedium,
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(widget.isSelected ? 8.w : 0),
                      decoration: widget.isSelected
                          ? BoxDecoration(
                              gradient: AppConfig.accentGradient,
                              borderRadius: BorderRadius.circular(
                                AppConfig.cornerRadiusMedium,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: selectedColor.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            )
                          : null,
                      child: Icon(
                        widget.icon,
                        size: 24.sp,
                        color: widget.isSelected
                            ? Colors.white
                            : unselectedColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Label
                    AnimatedDefaultTextStyle(
                      duration: AppConfig.animationMedium,
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: widget.isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: widget.isSelected
                            ? selectedColor
                            : unselectedColor,
                        height: 1.0,
                      ),
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
