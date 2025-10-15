import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../config/config.dart';
import '../../models/place_model.dart';
import '../../viewmodels/home_controller.dart';

class PlaceDetailPage extends StatelessWidget {
  const PlaceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaceModel place = Get.arguments as PlaceModel;
    final homeController = Get.find<HomeController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: place.imageUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        size: AppConfig.iconSizeXLarge,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Obx(() {
                final isFavorite = homeController.places
                    .firstWhere((p) => p.id == place.id, orElse: () => place)
                    .isFavorite;
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? AppConfig.errorLight : Colors.white,
                  ),
                  onPressed: () => homeController.toggleFavorite(place.id),
                );
              }),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  Get.snackbar(
                    'Share',
                    'Share functionality coming soon',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppConfig.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place.name,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      if (place.isOpen)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConfig.spacingMedium,
                            vertical: AppConfig.spacingSmall,
                          ),
                          decoration: BoxDecoration(
                            color: AppConfig.successLight,
                            borderRadius: BorderRadius.circular(AppConfig.cornerRadiusSmall),
                          ),
                          child: Text(
                            'OPEN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppConfig.fontSizeCaption,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: AppConfig.spacingMedium),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConfig.spacingMedium,
                          vertical: AppConfig.spacingSmall,
                        ),
                        decoration: BoxDecoration(
                          color: AppConfig.primaryColorLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppConfig.cornerRadiusSmall),
                        ),
                        child: Text(
                          place.category,
                          style: TextStyle(
                            color: AppConfig.primaryColorLight,
                            fontSize: AppConfig.fontSizeBody,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (place.rating != null) ...[
                    SizedBox(height: AppConfig.spacingLarge),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: place.rating!,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: AppConfig.iconSizeMedium,
                          direction: Axis.horizontal,
                        ),
                        SizedBox(width: AppConfig.spacingMedium),
                        Text(
                          '${place.rating!.toStringAsFixed(1)} (${place.reviewCount ?? 0} reviews)',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: AppConfig.spacingLarge),
                  _InfoSection(
                    icon: Icons.location_on,
                    title: 'Address',
                    content: place.address ?? 'Address not available',
                  ),
                  if (place.phone != null) ...[
                    SizedBox(height: AppConfig.spacingMedium),
                    _InfoSection(
                      icon: Icons.phone,
                      title: 'Phone',
                      content: place.phone!,
                      onTap: () async {
                        final uri = Uri.parse('tel:${place.phone}');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                    ),
                  ],
                  if (place.openingHours != null) ...[
                    SizedBox(height: AppConfig.spacingMedium),
                    _InfoSection(
                      icon: Icons.access_time,
                      title: 'Opening Hours',
                      content: place.openingHours!,
                    ),
                  ],
                  if (place.distance != null) ...[
                    SizedBox(height: AppConfig.spacingMedium),
                    _InfoSection(
                      icon: Icons.directions_walk,
                      title: 'Distance',
                      content:
                          '${place.distance!.toStringAsFixed(1)} km (${place.estimatedTime} min walk)',
                    ),
                  ],
                  SizedBox(height: AppConfig.spacingXLarge),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final url = Uri.parse(
                          'https://www.google.com/maps/dir/?api=1&destination=${place.latitude},${place.longitude}',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      icon: Icon(Icons.directions, size: AppConfig.iconSizeMedium),
                      label: Text(
                        'Get Directions',
                        style: TextStyle(
                          fontSize: AppConfig.fontSizeSubtitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.primaryColorLight,
                        foregroundColor: Colors.white,
                        elevation: AppConfig.elevationMedium,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConfig.cornerRadiusMedium),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppConfig.spacingLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final VoidCallback? onTap;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.content,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppConfig.spacingMedium),
        decoration: BoxDecoration(
          color: isDark ? AppConfig.surfaceDark : AppConfig.surfaceLight,
          borderRadius: BorderRadius.circular(AppConfig.cornerRadiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppConfig.spacingMedium),
              decoration: BoxDecoration(
                gradient: AppConfig.accentGradient,
                borderRadius: BorderRadius.circular(AppConfig.cornerRadiusSmall),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: AppConfig.iconSizeMedium,
              ),
            ),
            SizedBox(width: AppConfig.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppConfig.textSecondaryLight,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: AppConfig.textSecondaryLight,
                size: AppConfig.iconSizeMedium,
              ),
          ],
        ),
      ),
    );
  }
}
