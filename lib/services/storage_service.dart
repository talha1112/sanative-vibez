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
      
      // If list is empty, let's inject some sample data for the prototype
      if (checkIns.isEmpty) {
        return _getSampleData();
      }
      
      // Sort newest first
      checkIns.sort((a, b) => b.date.compareTo(a.date));
      return checkIns;
    } catch (e) {
      debugPrint('Error getting check-ins: $e');
      return _getSampleData();
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

  List<CheckIn> _getSampleData() {
    final now = DateTime.now();
    return [
      CheckIn(id: '1', date: now.subtract(const Duration(days: 1)), stressLevel: 'Grounded', supportNeeded: 'A quiet moment', intention: 'Slow down'),
      CheckIn(id: '2', date: now.subtract(const Duration(days: 2)), stressLevel: 'Full', supportNeeded: 'Clearer thoughts', intention: 'Be kind to myself'),
      CheckIn(id: '3', date: now.subtract(const Duration(days: 3)), stressLevel: 'Weary', supportNeeded: 'More energy', intention: 'Focus on one next step'),
      CheckIn(id: '4', date: now.subtract(const Duration(days: 4)), stressLevel: 'Grounded', supportNeeded: 'Better rest', intention: 'Make space to breathe'),
      CheckIn(id: '5', date: now.subtract(const Duration(days: 5)), stressLevel: 'Weary', supportNeeded: 'A quiet moment', intention: 'Release what I cannot control'),
      CheckIn(id: '6', date: now.subtract(const Duration(days: 6)), stressLevel: 'Full', supportNeeded: 'Letting something go', intention: 'Slow down'),
    ]..sort((a, b) => b.date.compareTo(a.date));
  }
}
