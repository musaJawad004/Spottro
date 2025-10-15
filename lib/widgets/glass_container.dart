import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../config/config.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 20.0,
    this.opacity = 0.15,
    this.border,
    this.boxShadow,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius =
        borderRadius ?? BorderRadius.circular(AppConfig.cornerRadiusLarge);

    // When height is not provided, avoid forcing infinite height on children.
    // Use a BackdropFilter-based glass fallback that can size naturally.
    if (height == null) {
      return Container(
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow:
              boxShadow ??
              [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: gradient != null
                    ? gradient as LinearGradient
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                Colors.white.withValues(alpha: 0.2),
                                Colors.white.withValues(alpha: 0.1),
                              ]
                            : [
                                Colors.white.withValues(alpha: 0.60),
                                Colors.white.withValues(alpha: 0.30),
                              ],
                      ),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
              child: child,
            ),
          ),
        ),
      );
    }

    // If a finite height is provided, we can use GlassmorphicContainer safely.
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
      ),
      child: GlassmorphicContainer(
        width: width ?? double.infinity,
        height: height!,
        borderRadius:
            (radius as BorderRadius?)?.topLeft.x ?? AppConfig.cornerRadiusLarge,
        blur: blur,
        alignment: Alignment.center,
        border: 2,
        linearGradient: gradient != null
            ? gradient as LinearGradient
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withValues(alpha: 0.2),
                        Colors.white.withValues(alpha: 0.1),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.60),
                        Colors.white.withValues(alpha: 0.30),
                      ],
              ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.4),
                  Colors.white.withValues(alpha: 0.2),
                ]
              : [
                  Colors.white.withValues(alpha: 0.8),
                  Colors.white.withValues(alpha: 0.4),
                ],
        ),
        child: Container(padding: padding, child: child),
      ),
    );
  }
}

// Animated Glass Card with press effect
class GlassCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool enablePressEffect;
  // When false, renders a simple container without the glass background.
  final bool useGlassBackground;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.enablePressEffect = true,
    this.useGlassBackground = true,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enablePressEffect && widget.onTap != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.enablePressEffect && widget.onTap != null) {
      _controller.reverse();
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    if (widget.enablePressEffect && widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ??
        BorderRadius.circular(AppConfig.cornerRadiusLarge);

    Widget content = widget.useGlassBackground
        ? GlassContainer(
            padding: widget.padding ?? EdgeInsets.all(AppConfig.spacingMedium),
            margin: widget.margin,
            borderRadius: radius,
            child: widget.child,
          )
        : Container(
            margin: widget.margin,
            padding: widget.padding ?? EdgeInsets.all(AppConfig.spacingMedium),
            decoration: BoxDecoration(
              borderRadius: radius,
              // Keep subtle shadow to match elevation without glass fill
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: widget.child,
          );

    if (widget.onTap != null && widget.enablePressEffect) {
      return GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: content,
            );
          },
        ),
      );
    } else if (widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}

// Glass App Bar
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double blur;

  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.blur = 20,
  });

  @override
  Size get preferredSize => Size.fromHeight(60.h);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        Colors.grey.shade900.withValues(alpha: 0.9),
                        Colors.grey.shade900.withValues(alpha: 0.85),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.9),
                      ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.shade300.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                if (leading != null)
                  leading!
                else
                  SizedBox(width: AppConfig.spacingMedium),
                Expanded(
                  child: centerTitle
                      ? Center(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: AppConfig.fontSizeHeading,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        )
                      : Text(
                          title,
                          style: TextStyle(
                            fontSize: AppConfig.fontSizeHeading,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                ),
                if (actions != null)
                  ...actions!
                else
                  SizedBox(width: AppConfig.spacingMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Glass Dialog with beautiful animations
class GlassDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: _GlassDialogContent(
              title: title,
              content: content,
              actions: actions,
              animation: animation,
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}

class _GlassDialogContent extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final Animation<double> animation;

  const _GlassDialogContent({
    required this.title,
    required this.content,
    required this.animation,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppConfig.spacingLarge),
      constraints: BoxConstraints(
        maxWidth: 400.w,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: GlassContainer(
        padding: EdgeInsets.all(AppConfig.spacingLarge),
        blur: 30,
        opacity: 0.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: AppConfig.fontSizeLargeHeading,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: AppConfig.spacingMedium),

            // Content
            Flexible(child: SingleChildScrollView(child: content)),

            // Actions
            if (actions != null && actions!.isNotEmpty) ...[
              SizedBox(height: AppConfig.spacingLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .map(
                      (action) => Padding(
                        padding: EdgeInsets.only(left: AppConfig.spacingSmall),
                        child: action,
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
