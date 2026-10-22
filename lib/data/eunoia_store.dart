import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EunoiaStore extends ChangeNotifier {
  EunoiaStore._();
  static final instance = EunoiaStore._();
  static const String _key = 'eunoia-ar-demo-v3';

  String name = '';
  String contact = '';
  bool reminders = false;
  bool dark = true;
  int breathSessions = 0;
  final List<Map<String, dynamic>> moods = [];
  final List<Map<String, dynamic>> entries = [];
  final List<Map<String, dynamic>> assessments = [];
  final List<Map<String, String>> chat = [];
  final Map<String, String> safety = {};

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    try {
      final d = jsonDecode(raw) as Map<String, dynamic>;
      name = d['name'] ?? '';
      contact = d['contact'] ?? '';
      reminders = d['reminders'] ?? false;
      dark = d['dark'] ?? true;
      breathSessions = d['breathSessions'] ?? 0;
      moods..clear()..addAll(List<Map<String, dynamic>>.from(d['moods'] ?? []));
      entries..clear()..addAll(List<Map<String, dynamic>>.from(d['entries'] ?? []));
      assessments..clear()..addAll(List<Map<String, dynamic>>.from(d['assessments'] ?? []));
      chat..clear()..addAll(List<Map<String, String>>.from((d['chat'] ?? []).map((e) => Map<String, String>.from(e))));
      safety..clear()..addAll(Map<String, String>.from(d['safety'] ?? {}));
    } catch (_) {
      // Ignore invalid local data and start with an empty private space.
    }
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode({
      'name': name, 'contact': contact, 'reminders': reminders, 'dark': dark,
      'breathSessions': breathSessions, 'moods': moods, 'entries': entries,
      'assessments': assessments, 'chat': chat, 'safety': safety,
    }));
    notifyListeners();
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    name = ''; contact = ''; reminders = false; dark = true; breathSessions = 0;
    moods.clear(); entries.clear(); assessments.clear(); chat.clear(); safety.clear();
    notifyListeners();
  }
}
