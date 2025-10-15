import 'package:get/get.dart';
import '../models/notification_model.dart';

class NotificationController extends GetxController {
  final _notifications = <NotificationModel>[].obs;
  final _isLoading = false.obs;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading.value;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      _isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock notifications
      _notifications.value = [
        NotificationModel(
          id: '1',
          title: 'New Café Nearby',
          message: 'Blue Bottle Coffee just opened 0.5 km away!',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: false,
          type: 'new_place',
        ),
        NotificationModel(
          id: '2',
          title: 'Your Favorite is Open',
          message: 'Starbucks Coffee is now open',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isRead: false,
          type: 'favorite_open',
        ),
        NotificationModel(
          id: '3',
          title: 'Discount Alert',
          message: 'Get 20% off at Italian Bistro today!',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
          type: 'promotion',
        ),
        NotificationModel(
          id: '4',
          title: 'New Review',
          message: 'Someone reviewed Gold\'s Gym - check it out',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          isRead: true,
          type: 'review',
        ),
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load notifications: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _notifications.refresh();
    }
  }

  void markAllAsRead() {
    _notifications.value = _notifications.map((n) {
      return n.copyWith(isRead: true);
    }).toList();
  }

  Future<void> refreshNotifications() async {
    await loadNotifications();
  }
}
