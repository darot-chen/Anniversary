import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/relationship_calculator.dart';
import 'settings_provider.dart';

final relationshipStatsProvider = Provider<RelationshipStats>((ref) {
  final settings = ref.watch(settingsProvider);
  return RelationshipCalculator.calculate(settings.startDate);
});
