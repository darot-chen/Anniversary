import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../core/utils/relationship_calculator.dart';
import '../models/display_format.dart';
import '../models/relationship_settings.dart';

/// Pushes the current day count to the Android home screen widget
/// (see android/app/.../DayCounterWidgetProvider.kt). No-ops safely if the
/// widget plugin channel is unavailable (e.g. in widget tests).
class HomeWidgetService {
  static const _androidWidgetName = 'DayCounterWidgetProvider';

  Future<void> update(RelationshipSettings settings) async {
    try {
      final stats = RelationshipCalculator.calculate(settings.startDate);
      final dayCountText = RelationshipCalculator.formatCount(
        stats,
        DisplayFormat.days,
      );
      final sinceText = 'Since ${DateFormat.yMMMMd().format(settings.startDate)}';

      await HomeWidget.saveWidgetData<String>('dayCountText', dayCountText);
      await HomeWidget.saveWidgetData<String>('sinceText', sinceText);
      await HomeWidget.saveWidgetData<String>('userName', settings.userName);
      await HomeWidget.saveWidgetData<String>(
        'partnerName',
        settings.partnerName,
      );
      await HomeWidget.saveWidgetData<String?>(
        'userPhotoPath',
        settings.userPhotoPath,
      );
      await HomeWidget.saveWidgetData<String?>(
        'partnerPhotoPath',
        settings.partnerPhotoPath,
      );
      await HomeWidget.updateWidget(androidName: _androidWidgetName);
    } catch (_) {
      // No-op: widget update is best-effort and shouldn't crash the app.
    }
  }
}
