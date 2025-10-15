import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../config/config.dart';
import '../../viewmodels/home_controller.dart';
import '../../viewmodels/notification_controller.dart';
import '../../widgets/glass_container.dart';
import '../../models/place_model.dart';
import '../../models/category_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final notificationController = Get.find<NotificationController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: homeController.refreshPlaces,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppConfig.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Discover',
                                style: Theme.of(context).textTheme.displayMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Find spots near you',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              IconButton(
                                onPressed: () => Get.toNamed('/notifications'),
                                icon: Icon(
                                  Icons.notifications_outlined,
                                  size: AppConfig.iconSizeLarge,
                                ),
                              ),
                              Obx(() {
                                final unreadCount =
                                    notificationController.unreadCount;
                                if (unreadCount == 0) {
                                  return const SizedBox.shrink();
                                }
                                return Positioned(
                                  right: 8.w,
                                  top: 8.h,
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: BoxDecoration(
                                        color: AppConfig.errorLight,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 16.w,
                                        minHeight: 16.w,
                                      ),
                                      child: Text(
                                        unreadCount > 9 ? '9+' : '$unreadCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: AppConfig.spacingLarge),
                      GlassContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConfig.spacingMedium,
                          vertical: 4.h,
                        ),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: homeController.search,
                          decoration: InputDecoration(
                            hintText: 'Search for spots near you...',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: AppConfig.iconSizeMedium,
                              color: isDark
                                  ? AppConfig.textSecondaryDark
                                  : AppConfig.textSecondaryLight,
                            ),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: isDark
                                  ? AppConfig.textSecondaryDark
                                  : AppConfig.textSecondaryLight,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppConfig.spacingLarge),
                      Text(
                        'Categories',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(() {
                  final categories = homeController.categories;
                  return SizedBox(
                    height: 120.h,
                    child: ListView.builder(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConfig.defaultPadding,
                        vertical: AppConfig.spacingSmall,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return _CategoryCard(
                          category: category,
                          onTap: () {
                            if (category.isSelected) {
                              homeController.selectCategory(null);
                            } else {
                              homeController.selectCategory(category.name);
                            }
                          },
                        );
                      },
                    ),
                  );
                }),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: AppConfig.defaultPadding,
                    left: AppConfig.defaultPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nearby Places',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Obx(() {
                        final selectedCategory =
                            homeController.selectedCategory;
                        if (selectedCategory != null) {
                          return TextButton(
                            onPressed: () =>
                                homeController.selectCategory(null),
                            child: Text('Clear'),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (homeController.isLoading) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _PlaceCardShimmer(),
                      childCount: 3,
                    ),
                  );
                }

                final places = homeController.places;
                if (places.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: AppConfig.iconSizeXLarge * 2,
                            color: AppConfig.textSecondaryLight,
                          ),
                          SizedBox(height: AppConfig.spacingMedium),
                          Text(
                            'No places found',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(height: AppConfig.spacingSmall),
                          Text(
                            'Try adjusting your search or filters',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final place = places[index];
                    return _PlaceCard(
                      place: place,
                      onTap: () =>
                          Get.toNamed('/place-detail', arguments: place),
                      onFavorite: () => homeController.toggleFavorite(place.id),
                    );
                  }, childCount: places.length),
                );
              }),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: AppConfig.bottomNavHeight + AppConfig.spacingMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConfig.animationMedium,
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.category.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_CategoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.category.isSelected && !oldWidget.category.isSelected) {
      _controller.forward();
    } else if (!widget.category.isSelected && oldWidget.category.isSelected) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.category.isSelected;
    return GlassCard(
      onTap: widget.onTap,
      padding: EdgeInsets.all(AppConfig.spacingSmall),
      margin: EdgeInsets.only(right: AppConfig.spacingMedium),
      borderRadius: BorderRadius.circular(AppConfig.cornerRadiusLarge),
      useGlassBackground: !isSelected,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 70.w,
          height: 90.h,
          decoration: BoxDecoration(
            color: isSelected ? widget.category.color : null,
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      widget.category.color,
                      widget.category.color.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(AppConfig.cornerRadiusMedium),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.category.icon,
                size: 28.sp,
                color: isSelected ? Colors.white : widget.category.color,
              ),
              SizedBox(height: 6.h),
              Text(
                widget.category.name,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : widget.category.color,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _PlaceCard({
    required this.place,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.symmetric(
        horizontal: AppConfig.defaultPadding,
        vertical: AppConfig.spacingSmall,
      ),
      borderRadius: BorderRadius.circular(AppConfig.cornerRadiusLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppConfig.cornerRadiusLarge),
                  topRight: Radius.circular(AppConfig.cornerRadiusLarge),
                ),
                child: CachedNetworkImage(
                  imageUrl: place.imageUrl ?? '',
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
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
              ),
              Positioned(
                top: AppConfig.spacingMedium,
                right: AppConfig.spacingMedium,
                child: GestureDetector(
                  onTap: onFavorite,
                  child: Container(
                    padding: EdgeInsets.all(AppConfig.spacingSmall),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      place.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: place.isFavorite
                          ? AppConfig.errorLight
                          : AppConfig.textSecondaryLight,
                      size: AppConfig.iconSizeMedium,
                    ),
                  ),
                ),
              ),
              if (place.isOpen)
                Positioned(
                  top: AppConfig.spacingMedium,
                  left: AppConfig.spacingMedium,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConfig.spacingMedium,
                      vertical: AppConfig.spacingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: AppConfig.successLight,
                      borderRadius: BorderRadius.circular(
                        AppConfig.cornerRadiusSmall,
                      ),
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
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(AppConfig.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        place.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (place.rating != null)
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: AppConfig.iconSizeSmall,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            place.rating!.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: AppConfig.spacingSmall),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: AppConfig.iconSizeSmall,
                      color: AppConfig.textSecondaryLight,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        place.address ?? 'Address not available',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppConfig.spacingSmall),
                Row(
                  children: [
                    if (place.distance != null) ...[
                      Icon(
                        Icons.directions_walk,
                        size: AppConfig.iconSizeSmall,
                        color: AppConfig.primaryColorLight,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${place.distance!.toStringAsFixed(1)} km',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppConfig.primaryColorLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    if (place.estimatedTime != null) ...[
                      SizedBox(width: AppConfig.spacingMedium),
                      Icon(
                        Icons.access_time,
                        size: AppConfig.iconSizeSmall,
                        color: AppConfig.primaryColorLight,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${place.estimatedTime} min',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppConfig.primaryColorLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppConfig.defaultPadding,
        vertical: AppConfig.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppConfig.surfaceDark : AppConfig.surfaceLight,
        borderRadius: BorderRadius.circular(AppConfig.cornerRadiusLarge),
      ),
      child: Shimmer.fromColors(
        baseColor: isDark ? AppConfig.textSecondaryDark.withOpacity(0.2) : AppConfig.textSecondaryLight.withOpacity(0.2),
        highlightColor: isDark ? AppConfig.textSecondaryDark.withOpacity(0.4) : AppConfig.textSecondaryLight.withOpacity(0.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: isDark ? AppConfig.surfaceDark : AppConfig.surfaceLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppConfig.cornerRadiusLarge),
                  topRight: Radius.circular(AppConfig.cornerRadiusLarge),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppConfig.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppConfig.surfaceDark : AppConfig.surfaceLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: AppConfig.spacingSmall),
                  Container(
                    width: 150.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppConfig.surfaceDark : AppConfig.surfaceLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}