import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sanative_vibez/services/storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('fresh install has no check-ins or reflections', () async {
    final storage = StorageService();
    expect(await storage.getCheckIns(), isEmpty);
    expect(await storage.getDailyReflections(), isEmpty);
  });

  test('saved check-ins and reflections are retrievable', () async {
    final storage = StorageService();
    await storage.saveCheckIn(CheckIn(
      id: '1',
      date: DateTime.now(),
      stressLevel: 'Grounded',
      supportNeeded: 'A quiet moment',
      intention: 'Slow down',
    ));
    await storage.saveDailyReflection(DailyReflection(
      id: '1',
      date: DateTime.now(),
      prompt: 'What would feel a little lighter today?',
      chipResponse: 'I need this today',
      textResponse: 'Some journal text',
    ));

    expect(await storage.getCheckIns(), hasLength(1));
    expect(await storage.getDailyReflections(), hasLength(1));
  });

  test('clearAllUserData removes all check-ins and reflections', () async {
    final storage = StorageService();
    await storage.saveCheckIn(CheckIn(
      id: '1',
      date: DateTime.now(),
      stressLevel: 'Full',
      supportNeeded: 'Clearer thoughts',
      intention: 'Be kind to myself',
    ));
    await storage.saveDailyReflection(DailyReflection(
      id: '1',
      date: DateTime.now(),
      prompt: 'What is one thing you can release for now?',
      chipResponse: 'I\'m thinking about it',
      textResponse: '',
    ));

    await storage.clearAllUserData();

    expect(await storage.getCheckIns(), isEmpty);
    expect(await storage.getDailyReflections(), isEmpty);
  });
}
