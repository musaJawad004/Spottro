import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/config.dart';
import '../../viewmodels/notification_controller.dart';
import '../../models/notification_model.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Obx(() {
            if (controller.unreadCount > 0) {
              return TextButton(
                onPressed: controller.markAllAsRead,
                child: const Text('Mark all read'),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshNotifications,
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: AppConfig.iconSizeXLarge * 2,
                    color: AppConfig.textSecondaryLight,
                  ),
                  SizedBox(height: AppConfig.spacingMedium),
                  Text(
                    'No notifications',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: AppConfig.spacingSmall),
                  Text(
                    'You\'re all caught up!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(AppConfig.defaultPadding),
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => SizedBox(height: AppConfig.spacingSmall),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return _NotificationCard(
                notification: notification,
                onTap: () => controller.markAsRead(notification.id),
              );
            },
          );
        }),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  IconData _getIcon(String? type) {
    switch (type) {
      case 'new_place':
        return Icons.location_on;
      case 'favorite_open':
        return Icons.store;
      case 'promotion':
        return Icons.local_offer;
      case 'review':
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppConfig.spacingMedium),
        decoration: BoxDecoration(
          color: notification.isRead
              ? (isDark ? AppConfig.surfaceDark : AppConfig.surfaceLight)
              : (isDark
                  ? AppConfig.primaryColorDark.withValues(alpha: 0.1)
                  : AppConfig.primaryColorLight.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(AppConfig.cornerRadiusMedium),
          border: Border.all(
            color: notification.isRead
                ? Colors.transparent
                : AppConfig.primaryColorLight.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: AppConfig.accentGradient,
                borderRadius: BorderRadius.circular(AppConfig.cornerRadiusSmall),
              ),
              child: Icon(
                _getIcon(notification.type),
                color: Colors.white,
                size: AppConfig.iconSizeMedium,
              ),
            ),
            SizedBox(width: AppConfig.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: Theme.of(context).textTheme.labelLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8.w,
                          height: 8.w,
                          margin: EdgeInsets.only(left: AppConfig.spacingSmall),
                          decoration: BoxDecoration(
                            color: AppConfig.primaryColorLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: AppConfig.spacingSmall),
                  Text(
                    notification.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppConfig.spacingSmall),
                  Text(
                    _getTimeAgo(notification.timestamp),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppConfig.textSecondaryLight,
                          fontSize: AppConfig.fontSizeCaption,
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
