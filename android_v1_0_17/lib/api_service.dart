import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String defaultSupabaseUrl =
      'https://ffufcwoblqufbpketeaa.supabase.co';
  static const String defaultSupabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZmdWZjd29ibHF1ZmJwa2V0ZWFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk4MjkxOTMsImV4cCI6MjEwNTQwNTE5M30.lMzRXSW0V9Gcbx0ZkrE_1u_tVnDy_00AhwQl3F9XW5c';
  static const String mobileSyncClientKey =
      'e--ZgaYU7RoG2sVpKJM8FHRaaeFMThas5lV1d6ZZY-Y';
  static const String snapshotId = 'kumar-foods-erp-main';

  static const _cacheKey = 'kumar_foods_mobile_snapshot_v1017';
  static const _urlKey = 'kumar_foods_mobile_supabase_url';
  static const _anonKey = 'kumar_foods_mobile_supabase_anon';

  static Future<Map<String, dynamic>> loadSnapshot({bool allowCache = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString(_urlKey)?.trim().isNotEmpty == true
        ? prefs.getString(_urlKey)!.trim()
        : defaultSupabaseUrl;
    final anon = prefs.getString(_anonKey)?.trim().isNotEmpty == true
        ? prefs.getString(_anonKey)!.trim()
        : defaultSupabaseAnonKey;

    try {
      final endpoint = Uri.parse('$url/functions/v1/erp-mobile-sync?id=$snapshotId');
      final response = await http.get(endpoint, headers: {
        'apikey': anon,
        'Authorization': 'Bearer $anon',
        'x-erp-mobile-key': mobileSyncClientKey,
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final payload = decoded['payload'];
          if (payload is Map<String, dynamic>) {
            final result = <String, dynamic>{
              ...payload,
              '_cloudUpdatedAt': decoded['updated_at'],
              '_cloudDevice': decoded['device'],
              '_offline': false,
            };
            await prefs.setString(_cacheKey, jsonEncode(result));
            return result;
          }
        }
      }
      throw HttpException('Cloud returned ${response.statusCode}: ${response.body}');
    } catch (_) {
      if (!allowCache) rethrow;
      final cached = prefs.getString(_cacheKey);
      if (cached != null && cached.isNotEmpty) {
        final decoded = jsonDecode(cached);
        if (decoded is Map<String, dynamic>) {
          return {...decoded, '_offline': true};
        }
      }
      rethrow;
    }
  }

  static Future<void> saveConnection({required String url, required String anonKey}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_urlKey, url.trim());
    await prefs.setString(_anonKey, anonKey.trim());
  }

  static Future<void> resetConnection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_urlKey);
    await prefs.remove(_anonKey);
  }

  static List<Map<String, dynamic>> table(Map<String, dynamic> snapshot, String key) {
    final raw = snapshot[key];
    if (raw is List) {
      return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return const [];
  }

  static num amount(dynamic value) {
    if (value is num) return value;
    return num.tryParse('${value ?? ''}') ?? 0;
  }

  static String text(dynamic value) => '${value ?? ''}'.trim();
}
