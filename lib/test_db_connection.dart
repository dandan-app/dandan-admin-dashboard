import 'package:flutter/material.dart';
import 'config/supabase_config.dart';
import 'services/supabase_database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('🔄 جاري تهيئة Supabase...');
    await SupabaseConfig.initialize();
    print('✅ تم الاتصال مع Supabase بنجاح!');
    
    // اختبار الاتصال بجميع الجداول
    await testDatabaseConnection();
    
  } catch (e) {
    print('❌ خطأ في الاتصال مع Supabase: $e');
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'اختبار قاعدة البيانات',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: DatabaseTestPage(),
    );
  }
}

class DatabaseTestPage extends StatefulWidget {
  @override
  _DatabaseTestPageState createState() => _DatabaseTestPageState();
}

class _DatabaseTestPageState extends State<DatabaseTestPage> {
  List<String> testResults = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    runTests();
  }

  Future<void> runTests() async {
    setState(() {
      isLoading = true;
      testResults.clear();
    });

    try {
      // اختبار جدول المستخدمين
      addResult('🔄 اختبار جدول المستخدمين...');
      final users = await SupabaseConfig.client.from('users').select().limit(5);
      addResult('✅ جدول المستخدمين: ${users.length} مستخدم');

      // اختبار جدول الموظفين
      addResult('🔄 اختبار جدول الموظفين...');
      final employees = await SupabaseConfig.client.from('employees').select().limit(5);
      addResult('✅ جدول الموظفين: ${employees.length} موظف');

      // اختبار جدول السائقين
      addResult('🔄 اختبار جدول السائقين...');
      final drivers = await SupabaseConfig.client.from('drivers').select().limit(5);
      addResult('✅ جدول السائقين: ${drivers.length} سائق');

      // اختبار جدول الطلبات
      addResult('🔄 اختبار جدول الطلبات...');
      final orders = await SupabaseConfig.client.from('orders').select().limit(5);
      addResult('✅ جدول الطلبات: ${orders.length} طلب');

      // اختبار الإحصائيات
      addResult('🔄 اختبار الإحصائيات...');
      final userStats = await SupabaseDatabaseService.getUserStats();
      final employeeStats = await SupabaseDatabaseService.getEmployeeStats();
      final driverStats = await SupabaseDatabaseService.getDriverStats();
      final orderStats = await SupabaseDatabaseService.getOrderStats();

      addResult('📊 إحصائيات المستخدمين: ${userStats['total']} إجمالي، ${userStats['active']} نشط');
      addResult('📊 إحصائيات الموظفين: ${employeeStats['total']} إجمالي، ${employeeStats['active']} نشط');
      addResult('📊 إحصائيات السائقين: ${driverStats['total']} إجمالي، ${driverStats['available']} متاح');
      addResult('📊 إحصائيات الطلبات: ${orderStats['total']} إجمالي، ${orderStats['completed']} مكتمل');

      addResult('🎉 تم اختبار جميع الجداول بنجاح!');

    } catch (e) {
      addResult('❌ خطأ في الاختبار: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  void addResult(String result) {
    setState(() {
      testResults.add(result);
    });
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اختبار قاعدة البيانات'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: runTests,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                Icon(
                  Icons.storage,
                  size: 48,
                  color: Colors.blue,
                ),
                SizedBox(height: 8),
                Text(
                  'اختبار اتصال قاعدة البيانات Supabase',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'URL: https://lhhlysnqflbsfdjdgavu.supabase.co',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('جاري اختبار قاعدة البيانات...'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: testResults.length,
                    itemBuilder: (context, index) {
                      final result = testResults[index];
                      final isSuccess = result.contains('✅');
                      final isError = result.contains('❌');
                      final isInfo = result.contains('📊');

                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            isSuccess
                                ? Icons.check_circle
                                : isError
                                    ? Icons.error
                                    : isInfo
                                        ? Icons.analytics
                                        : Icons.info,
                            color: isSuccess
                                ? Colors.green
                                : isError
                                    ? Colors.red
                                    : isInfo
                                        ? Colors.blue
                                        : Colors.orange,
                          ),
                          title: Text(
                            result,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : runTests,
              icon: Icon(Icons.refresh),
              label: Text('إعادة الاختبار'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> testDatabaseConnection() async {
  try {
    print('🔄 بدء اختبار الاتصال...');
    
    // اختبار الاتصال الأساسي
    final response = await SupabaseConfig.client.from('users').select().limit(1);
    print('✅ تم الاتصال بنجاح مع Supabase');
    
    // اختبار الجداول الأساسية
    final tables = ['users', 'employees', 'drivers', 'orders', 'notifications', 'app_settings'];
    
    for (String table in tables) {
      try {
        final result = await SupabaseConfig.client.from(table).select().limit(1);
        print('✅ جدول $table: متاح');
      } catch (e) {
        print('❌ جدول $table: خطأ - $e');
      }
    }
    
  } catch (e) {
    print('❌ خطأ في اختبار الاتصال: $e');
  }
}

