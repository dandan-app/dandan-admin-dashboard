import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static SupabaseClient? _client;
  
  // إعدادات Supabase - مشروع dandan-admin
  static const String supabaseUrl = 'https://lhhlysnqflbsfdjdgavu.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxoaGx5c25xZmxic2ZkamRnYXZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzNjM3MjcsImV4cCI6MjA3NDkzOTcyN30.KrX4tKeSxBQaVUrwE8_w0pExjwbyNF6XBZsl0b5-B0U';
  
  // تهيئة Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }
  
  // الحصول على مثيل Supabase
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase لم يتم تهيئته بعد. يرجى استدعاء initialize() أولاً.');
    }
    return _client!;
  }
  
  // التحقق من حالة التهيئة
  static bool get isInitialized => _client != null;
  
  // الحصول على Auth
  static GoTrueClient get auth => client.auth;
  
  // الحصول على Database
  static SupabaseQueryBuilder get database => client.from('');
}
