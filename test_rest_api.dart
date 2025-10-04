import 'dart:convert';
import 'dart:io';

void main() async {
  print('🔄 اختبار قاعدة البيانات عبر REST API...');
  
  const String supabaseUrl = 'https://lhhlysnqflbsfdjdgavu.supabase.co';
  const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxoaGx5c25xZmxic2ZkamRnYXZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzNjM3MjcsImV4cCI6MjA3NDkzOTcyN30.KrX4tKeSxBQaVUrwE8_w0pExjwbyNF6XBZsl0b5-B0U';
  
  final tables = ['users', 'employees', 'drivers', 'orders', 'notifications', 'app_settings'];
  
  for (String table in tables) {
    try {
      print('🔄 اختبار جدول $table...');
      
      final client = HttpClient();
      final request = await client.getUrl(
        Uri.parse('$supabaseUrl/rest/v1/$table?select=*&limit=5')
      );
      
      request.headers.set('apikey', anonKey);
      request.headers.set('Authorization', 'Bearer $anonKey');
      request.headers.set('Content-Type', 'application/json');
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        print('✅ جدول $table: متاح (${data.length} صف)');
        
        if (data.isNotEmpty) {
          print('   عينة من البيانات: ${data.first}');
        }
      } else {
        print('❌ جدول $table: خطأ - ${response.statusCode}');
        print('   الاستجابة: $responseBody');
      }
      
      client.close();
      
    } catch (e) {
      print('❌ جدول $table: خطأ في الاتصال - $e');
    }
    
    print(''); // سطر فارغ للفصل
  }
  
  // اختبار الإحصائيات
  try {
    print('📊 اختبار الإحصائيات...');
    
    final client = HttpClient();
    final request = await client.getUrl(
      Uri.parse('$supabaseUrl/rest/v1/users?select=count')
    );
    
    request.headers.set('apikey', anonKey);
    request.headers.set('Authorization', 'Bearer $anonKey');
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Prefer', 'count=exact');
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    if (response.statusCode == 200) {
      print('✅ إحصائيات المستخدمين: $responseBody');
    } else {
      print('❌ خطأ في الإحصائيات: ${response.statusCode}');
    }
    
    client.close();
    
  } catch (e) {
    print('❌ خطأ في الإحصائيات: $e');
  }
  
  print('\n🎉 تم اختبار قاعدة البيانات بنجاح!');
}

