import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckIn {
  final String id;
  final DateTime date;
  final String stressLevel;
  final String supportNeeded;
  final String intention;

  CheckIn({
    required this.id,
    required this.date,
    required this.stressLevel,
    required this.supportNeeded,
    required this.intention,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date.toIso8601String(),
      'stressLevel': stressLevel,
      'supportNeeded': supportNeeded,
      'intention': intention,
    };
  }

  factory CheckIn.fromMap(Map<String, dynamic> map) {
    return CheckIn(
      id: map['id']?.toString() ?? '',
      date: map['date'] != null ? DateTime.tryParse(map['date'].toString()) ?? DateTime.now() : DateTime.now(),
      stressLevel: map['stressLevel']?.toString() ?? '',
      supportNeeded: map['supportNeeded']?.toString() ?? '',
      intention: map['intention']?.toString() ?? '',
    );
  }
}

class DailyReflection {
  final String id;
  final DateTime date;
  final String prompt;
  final String chipResponse;
  final String textResponse;

  DailyReflection({
    required this.id,
    required this.date,
    required this.prompt,
    required this.chipResponse,
    required this.textResponse,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date.toIso8601String(),
      'prompt': prompt,
      'chipResponse': chipResponse,
      'textResponse': textResponse,
    };
  }

  factory DailyReflection.fromMap(Map<String, dynamic> map) {
    return DailyReflection(
      id: map['id']?.toString() ?? '',
      date: map['date'] != null ? DateTime.tryParse(map['date'].toString()) ?? DateTime.now() : DateTime.now(),
      prompt: map['prompt']?.toString() ?? '',
      chipResponse: map['chipResponse']?.toString() ?? '',
      textResponse: map['textResponse']?.toString() ?? '',
    );
  }
}

class StorageService {
  static const String _checkInsKey = 'check_ins';
  static const String _dailyReflectionsKey = 'daily_reflections';

  Future<void> saveCheckIn(CheckIn checkIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existingStr = prefs.getStringList(_checkInsKey) ?? [];
      
      existingStr.add(jsonEncode(checkIn.toMap()));
      await prefs.setStringList(_checkInsKey, existingStr);
    } catch (e) {
      debugPrint('Error saving check-in: $e');
    }
  }

  Future<List<CheckIn>> getCheckIns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existingStr = prefs.getStringList(_checkInsKey) ?? [];
      
      final List<CheckIn> checkIns = [];
      for (String str in existingStr) {
        try {
          final decoded = jsonDecode(str);
          if (decoded is Map) {
            checkIns.add(CheckIn.fromMap(Map<String, dynamic>.from(decoded)));
          }
        } catch (e) {
          debugPrint('Error parsing check-in: $e');
        }
      }
      
      // Sort newest first
      checkIns.sort((a, b) => b.date.compareTo(a.date));
      return checkIns;
    } catch (e) {
      debugPrint('Error getting check-ins: $e');
      return [];
    }
  }

  Future<void> saveDailyReflection(DailyReflection reflection) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existingStr = prefs.getStringList(_dailyReflectionsKey) ?? [];
      
      existingStr.add(jsonEncode(reflection.toMap()));
      await prefs.setStringList(_dailyReflectionsKey, existingStr);
    } catch (e) {
      debugPrint('Error saving daily reflection: $e');
    }
  }

  Future<List<DailyReflection>> getDailyReflections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existingStr = prefs.getStringList(_dailyReflectionsKey) ?? [];
      
      final List<DailyReflection> reflections = [];
      for (String str in existingStr) {
        try {
          final decoded = jsonDecode(str);
          if (decoded is Map) {
            reflections.add(DailyReflection.fromMap(Map<String, dynamic>.from(decoded)));
          }
        } catch (e) {
          debugPrint('Error parsing daily reflection: $e');
        }
      }
      
      reflections.sort((a, b) => b.date.compareTo(a.date));
      return reflections;
    } catch (e) {
      debugPrint('Error getting daily reflections: $e');
      return [];
    }
  }

  /// Deletes all locally stored user-generated reflection data
  /// (check-ins and daily reflections). Used by the "Clear My Data" flow.
  Future<void> clearAllUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_checkInsKey);
    await prefs.remove(_dailyReflectionsKey);
  }
}
