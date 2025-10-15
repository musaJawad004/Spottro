import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/config.dart';
import '../../viewmodels/home_controller.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(AppConfig.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Favorites',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Your saved places',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final favorites = homeController.places
                    .where((place) => place.isFavorite)
                    .toList();

                if (favorites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: AppConfig.iconSizeXLarge * 2,
                          color: AppConfig.textSecondaryLight,
                        ),
                        SizedBox(height: AppConfig.spacingMedium),
                        Text(
                          'No favorites yet',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: AppConfig.spacingSmall),
                        Text(
                          'Start adding places to your favorites',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(
                    left: AppConfig.defaultPadding,
                    right: AppConfig.defaultPadding,
                    bottom: AppConfig.bottomNavHeight + AppConfig.spacingMedium,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final place = favorites[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed('/place-detail', arguments: place),
                      child: Container(
                        margin: EdgeInsets.only(bottom: AppConfig.spacingMedium),
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
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppConfig.cornerRadiusMedium),
                                bottomLeft: Radius.circular(AppConfig.cornerRadiusMedium),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: place.imageUrl ?? '',
                                width: 100.w,
                                height: 100.w,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: AppConfig.iconSizeMedium,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(AppConfig.spacingMedium),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place.name,
                                      style: Theme.of(context).textTheme.labelLarge,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: AppConfig.spacingSmall),
                                    Row(
                                      children: [
                                        if (place.rating != null) ...[
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: AppConfig.iconSizeSmall,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            place.rating!.toStringAsFixed(1),
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: AppConfig.spacingSmall),
                                    if (place.distance != null)
                                      Text(
                                        '${place.distance!.toStringAsFixed(1)} km away',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: AppConfig.primaryColorLight,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => homeController.toggleFavorite(place.id),
                              icon: Icon(
                                Icons.favorite,
                                color: AppConfig.errorLight,
                                size: AppConfig.iconSizeMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
