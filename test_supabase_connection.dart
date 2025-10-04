// ملف اختبار الاتصال مع Supabase
// يمكنك تشغيل هذا الكود في main.dart مؤقتاً للاختبار

import 'package:flutter/material.dart';
import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await SupabaseConfig.initialize();
    print('✅ تم الاتصال مع Supabase بنجاح!');
    
    // اختبار الاتصال بجدول الموظفين
    final response = await SupabaseConfig.client
        .from('employees')
        .select()
        .limit(1);
    
    print('✅ تم الوصول لجدول الموظفين بنجاح!');
    print('عدد الموظفين: ${response.length}');
    
  } catch (e) {
    print('❌ خطأ في الاتصال مع Supabase: $e');
  }
  
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('اختبار Supabase')),
      body: Center(
        child: Text('تحقق من Console للنتائج'),
      ),
    ),
  ));
}
