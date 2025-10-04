import 'package:flutter/material.dart';
import 'config/supabase_config.dart';
import 'services/supabase_database_service.dart';
import 'pages/orders_management_page.dart';
import 'pages/users_management_page.dart';
import 'pages/employees_management_page.dart';
import 'pages/advanced_dashboard_page.dart';
import 'pages/analytics_page.dart';
import 'pages/system_monitoring_page.dart';
import 'pages/advanced_settings_page.dart';
import 'pages/notifications_management_page.dart';
import 'pages/reports_system_page.dart';
import 'utils/sample_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const SimpleAdminApp());
}

class SimpleAdminApp extends StatelessWidget {
  const SimpleAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام دندن الإداري',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
        useMaterial3: true,
      ),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, int> orderStats = {
    'total': 0,
    'pending': 0,
    'confirmed': 0,
    'inProgress': 0,
    'completed': 0,
    'cancelled': 0,
  };
  
  Map<String, int> userStats = {
    'total': 0,
    'active': 0,
    'inactive': 0,
  };
  
  Map<String, int> driverStats = {
    'total': 0,
    'available': 0,
    'busy': 0,
    'offline': 0,
    'suspended': 0,
  };
  
  Map<String, int> employeeStats = {
    'total': 0,
    'active': 0,
    'inactive': 0,
    'suspended': 0,
    'terminated': 0,
  };
  
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final orders = await SupabaseDatabaseService.getOrderStats();
      final users = await SupabaseDatabaseService.getUserStats();
      final drivers = await SupabaseDatabaseService.getDriverStats();
      final employees = await SupabaseDatabaseService.getEmployeeStats();
      
      setState(() {
        orderStats = orders;
        userStats = users;
        driverStats = drivers;
        employeeStats = employees;
        isLoading = false;
      });
    } catch (e) {
      print('خطأ في تحميل الإحصائيات: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> _addSampleData() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      await SampleData.addAllSampleData();
      await _loadStats();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إضافة البيانات التجريبية بنجاح!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('خطأ في إضافة البيانات التجريبية: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إضافة البيانات: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نظام دندن الإداري'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: _addSampleData,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStats,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رسالة ترحيب
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.dashboard,
                      size: 64,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'مرحباً بك في نظام دندن الإداري',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'لوحة تحكم شاملة لإدارة التطبيق',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // الإحصائيات
            Text(
              'الإحصائيات',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'الطلبات',
                    isLoading ? '...' : orderStats['total'].toString(),
                    Icons.shopping_cart,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'المستخدمين',
                    isLoading ? '...' : userStats['total'].toString(),
                    Icons.people,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'السائقين',
                    isLoading ? '...' : driverStats['total'].toString(),
                    Icons.drive_eta,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'الموظفين',
                    isLoading ? '...' : employeeStats['total'].toString(),
                    Icons.badge,
                    Colors.indigo,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'الطلبات المكتملة',
                    isLoading ? '...' : orderStats['completed'].toString(),
                    Icons.check_circle,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'الموظفين النشطين',
                    isLoading ? '...' : employeeStats['active'].toString(),
                    Icons.person,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // المميزات
            Text(
              'المميزات المتاحة',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              'إدارة الطلبات',
              'عرض وإدارة جميع الطلبات',
              Icons.shopping_cart,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersManagementPage()),
              ),
            ),
            
            _buildFeatureCard(
              'إدارة المستخدمين',
              'عرض وإدارة المستخدمين والسائقين',
              Icons.people,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UsersManagementPage()),
              ),
            ),
            
            _buildFeatureCard(
              'إدارة الموظفين',
              'عرض وإدارة موظفي الشركة',
              Icons.badge,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmployeesManagementPage()),
              ),
            ),
            
            _buildFeatureCard(
              'لوحة التحكم المتقدمة',
              'لوحة تحكم شاملة مع إحصائيات تفاعلية',
              Icons.dashboard,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdvancedDashboardPage()),
              ),
            ),
            
            _buildFeatureCard(
              'التحليلات المتقدمة',
              'تحليلات مفصلة ومخططات بيانية',
              Icons.analytics,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnalyticsPage()),
              ),
            ),
            
            _buildFeatureCard(
              'مراقبة النظام',
              'مراقبة حالة النظام والأداء',
              Icons.monitor,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SystemMonitoringPage()),
              ),
            ),
            
            _buildFeatureCard(
              'الإعدادات المتقدمة',
              'إعدادات شاملة للنظام',
              Icons.settings,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdvancedSettingsPage()),
              ),
            ),
            
            _buildFeatureCard(
              'إدارة الإشعارات',
              'إدارة الإشعارات والتواصل',
              Icons.notifications,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsManagementPage()),
              ),
            ),
            
            _buildFeatureCard(
              'نظام التقارير',
              'تقارير مفصلة وإحصائيات تفصيلية',
              Icons.description,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportsSystemPage()),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // معلومات النظام
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معلومات النظام',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('الإصدار', '1.0.0'),
                    _buildInfoRow('التاريخ', 'سبتمبر 2025'),
                    _buildInfoRow('المطور', 'فريق دندن'),
                    _buildInfoRow('الحالة', 'يعمل بشكل طبيعي'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue.shade700),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
  
  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('قريباً'),
        content: const Text('هذه الميزة قيد التطوير وستكون متاحة قريباً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
