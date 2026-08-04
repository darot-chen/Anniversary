import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/home_widget_service.dart';
import '../services/image_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});

final homeWidgetServiceProvider = Provider<HomeWidgetService>((ref) {
  return HomeWidgetService();
});
