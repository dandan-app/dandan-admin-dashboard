import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/supabase_database_service.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../models/employee_model.dart';
import '../models/driver_model.dart';

class AdvancedDashboardPage extends StatefulWidget {
  const AdvancedDashboardPage({super.key});

  @override
  State<AdvancedDashboardPage> createState() => _AdvancedDashboardPageState();
}

class _AdvancedDashboardPageState extends State<AdvancedDashboardPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, int> orderStats = {};
  Map<String, int> userStats = {};
  Map<String, int> driverStats = {};
  Map<String, int> employeeStats = {};
  bool isLoading = true;
  
  // البيانات للمخططات
  List<FlSpot> orderTrendData = [];
  List<FlSpot> revenueData = [];
  List<FlSpot> userGrowthData = [];
  List<PieChartSectionData> orderStatusData = [];
  List<PieChartSectionData> userRoleData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDashboardData();
    
    // تحديث البيانات كل 30 ثانية
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) _loadDashboardData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // تحميل الإحصائيات
      final orders = await SupabaseDatabaseService.getOrderStats();
      final users = await SupabaseDatabaseService.getUserStats();
      final drivers = await SupabaseDatabaseService.getDriverStats();
      final employees = await SupabaseDatabaseService.getEmployeeStats();

      // تحميل البيانات التفصيلية للمخططات
      await _loadChartData();

      setState(() {
        orderStats = orders;
        userStats = users;
        driverStats = drivers;
        employeeStats = employees;
        isLoading = false;
      });
    } catch (e) {
      print('خطأ في تحميل بيانات لوحة التحكم: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadChartData() async {
    try {
      // بيانات الطلبات (7 أيام الماضية)
      orderTrendData = [
        const FlSpot(0, 12),
        const FlSpot(1, 15),
        const FlSpot(2, 8),
        const FlSpot(3, 20),
        const FlSpot(4, 18),
        const FlSpot(5, 25),
        const FlSpot(6, 22),
      ];

      // بيانات الإيرادات
      revenueData = [
        const FlSpot(0, 1200),
        const FlSpot(1, 1500),
        const FlSpot(2, 800),
        const FlSpot(3, 2000),
        const FlSpot(4, 1800),
        const FlSpot(5, 2500),
        const FlSpot(6, 2200),
      ];

      // بيانات نمو المستخدمين
      userGrowthData = [
        const FlSpot(0, 45),
        const FlSpot(1, 52),
        const FlSpot(2, 48),
        const FlSpot(3, 65),
        const FlSpot(4, 58),
        const FlSpot(5, 72),
        const FlSpot(6, 68),
      ];

      // بيانات حالات الطلبات
      orderStatusData = [
        PieChartSectionData(
          color: Colors.green,
          value: 45,
          title: 'مكتملة',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: Colors.orange,
          value: 25,
          title: 'معلقة',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: Colors.blue,
          value: 20,
          title: 'قيد التنفيذ',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: Colors.red,
          value: 10,
          title: 'ملغية',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ];

      // بيانات أدوار المستخدمين
      userRoleData = [
        PieChartSectionData(
          color: Colors.purple,
          value: 60,
          title: 'مستخدمين',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: Colors.blue,
          value: 25,
          title: 'سائقين',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: Colors.teal,
          value: 15,
          title: 'موظفين',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ];
    } catch (e) {
      print('خطأ في تحميل بيانات المخططات: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم المتقدمة'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // شريط التبويب
                Container(
                  color: Colors.grey.shade50,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: isMobile,
                    labelColor: Colors.blue.shade700,
                    unselectedLabelColor: Colors.grey.shade600,
                    indicatorColor: Colors.blue.shade700,
                    tabs: const [
                      Tab(icon: Icon(Icons.dashboard), text: 'نظرة عامة'),
                      Tab(icon: Icon(Icons.analytics), text: 'تحليلات'),
                      Tab(icon: Icon(Icons.monitor), text: 'مراقبة'),
                      Tab(icon: Icon(Icons.settings), text: 'إعدادات'),
                    ],
                  ),
                ),
                
                // محتوى التبويبات
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(),
                      _buildAnalyticsTab(),
                      _buildMonitoringTab(),
                      _buildSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // إحصائيات سريعة
          _buildQuickStats(),
          
          const SizedBox(height: 24),
          
          // مخططات سريعة
          Row(
            children: [
              Expanded(
                child: _buildMiniChart(
                  title: 'اتجاه الطلبات',
                  data: orderTrendData,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMiniChart(
                  title: 'الإيرادات',
                  data: revenueData,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // معلومات النظام
          _buildSystemInfo(),
          
          const SizedBox(height: 24),
          
          // الأنشطة الحديثة
          _buildRecentActivities(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التحليلات والإحصائيات',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // مخططات تفاعلية
          Row(
            children: [
              Expanded(
                child: _buildPieChart(
                  title: 'حالات الطلبات',
                  data: orderStatusData,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPieChart(
                  title: 'توزيع المستخدمين',
                  data: userRoleData,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // مخططات خطية
          _buildLineChart(
            title: 'اتجاه الطلبات (7 أيام)',
            data: orderTrendData,
            color: Colors.blue,
          ),
          
          const SizedBox(height: 24),
          
          _buildLineChart(
            title: 'الإيرادات اليومية',
            data: revenueData,
            color: Colors.green,
          ),
          
          const SizedBox(height: 24),
          
          // تقارير مفصلة
          _buildDetailedReports(),
        ],
      ),
    );
  }

  Widget _buildMonitoringTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مراقبة النظام',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // حالة النظام
          _buildSystemStatus(),
          
          const SizedBox(height: 24),
          
          // مراقبة الأداء
          _buildPerformanceMonitoring(),
          
          const SizedBox(height: 24),
          
          // التنبيهات
          _buildAlerts(),
          
          const SizedBox(height: 24),
          
          // سجلات النظام
          _buildSystemLogs(),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إعدادات النظام',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // إعدادات عامة
          _buildGeneralSettings(),
          
          const SizedBox(height: 24),
          
          // إعدادات الإشعارات
          _buildNotificationSettings(),
          
          const SizedBox(height: 24),
          
          // إعدادات الأمان
          _buildSecuritySettings(),
          
          const SizedBox(height: 24),
          
          // إعدادات قاعدة البيانات
          _buildDatabaseSettings(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إحصائيات سريعة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'الطلبات',
                    orderStats['total']?.toString() ?? '0',
                    Icons.shopping_cart,
                    Colors.blue,
                    '${orderStats['completed'] ?? 0} مكتملة',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'المستخدمين',
                    userStats['total']?.toString() ?? '0',
                    Icons.people,
                    Colors.green,
                    '${userStats['active'] ?? 0} نشط',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'السائقين',
                    driverStats['total']?.toString() ?? '0',
                    Icons.drive_eta,
                    Colors.orange,
                    '${driverStats['available'] ?? 0} متاح',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'الموظفين',
                    employeeStats['total']?.toString() ?? '0',
                    Icons.badge,
                    Colors.purple,
                    '${employeeStats['active'] ?? 0} نشط',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChart({
    required String title,
    required List<FlSpot> data,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart({
    required String title,
    required List<PieChartSectionData> data,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: data,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart({
    required String title,
    required List<FlSpot> data,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const days = ['أحد', 'إثن', 'ثلاث', 'أربع', 'خميس', 'جمعة', 'سبت'];
                          return Text(
                            days[value.toInt() % 7],
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: color,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemInfo() {
    return Card(
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
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem('الحالة', 'يعمل بشكل طبيعي', Colors.green),
                ),
                Expanded(
                  child: _buildInfoItem('الاستجابة', '120ms', Colors.blue),
                ),
                Expanded(
                  child: _buildInfoItem('الاستخدام', '65%', Colors.orange),
                ),
                Expanded(
                  child: _buildInfoItem('التحديث', 'منذ 5 دقائق', Colors.purple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivities() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الأنشطة الحديثة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(5, (index) {
              final activities = [
                {'icon': Icons.shopping_cart, 'title': 'طلب جديد #1234', 'time': 'منذ 5 دقائق', 'color': Colors.blue},
                {'icon': Icons.person_add, 'title': 'مستخدم جديد', 'time': 'منذ 12 دقيقة', 'color': Colors.green},
                {'icon': Icons.drive_eta, 'title': 'سائق متاح', 'time': 'منذ 18 دقيقة', 'color': Colors.orange},
                {'icon': Icons.notifications, 'title': 'تنبيه نظام', 'time': 'منذ 25 دقيقة', 'color': Colors.red},
                {'icon': Icons.badge, 'title': 'موظف جديد', 'time': 'منذ 32 دقيقة', 'color': Colors.purple},
              ];
              
              final activity = activities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: (activity['color'] as Color).withOpacity(0.1),
                  child: Icon(
                    activity['icon'] as IconData,
                    color: activity['color'] as Color,
                    size: 20,
                  ),
                ),
                title: Text(activity['title'] as String),
                subtitle: Text(activity['time'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedReports() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تقارير مفصلة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showReport(context, 'orders'),
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('تقرير الطلبات'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showReport(context, 'users'),
                    icon: const Icon(Icons.people),
                    label: const Text('تقرير المستخدمين'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showReport(context, 'revenue'),
                    icon: const Icon(Icons.attach_money),
                    label: const Text('تقرير الإيرادات'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'حالة النظام',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatusItem('قاعدة البيانات', 'متصل', Colors.green),
                ),
                Expanded(
                  child: _buildStatusItem('API', 'يعمل', Colors.green),
                ),
                Expanded(
                  child: _buildStatusItem('التخزين', 'متاح', Colors.green),
                ),
                Expanded(
                  child: _buildStatusItem('الإشعارات', 'نشط', Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String status, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            status,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMonitoring() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مراقبة الأداء',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPerformanceItem('الذاكرة', '65%', Colors.blue),
                ),
                Expanded(
                  child: _buildPerformanceItem('المعالج', '45%', Colors.green),
                ),
                Expanded(
                  child: _buildPerformanceItem('الشبكة', '30%', Colors.orange),
                ),
                Expanded(
                  child: _buildPerformanceItem('التخزين', '78%', Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAlerts() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التنبيهات',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(3, (index) {
              final alerts = [
                {'title': 'استخدام التخزين عالي', 'level': 'تحذير', 'color': Colors.orange},
                {'title': 'مستخدم جديد مسجل', 'level': 'معلومات', 'color': Colors.blue},
                {'title': 'طلب جديد يحتاج مراجعة', 'level': 'تنبيه', 'color': Colors.red},
              ];
              
              final alert = alerts[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: (alert['color'] as Color).withOpacity(0.1),
                  child: Icon(
                    Icons.warning,
                    color: alert['color'] as Color,
                    size: 20,
                  ),
                ),
                title: Text(alert['title'] as String),
                subtitle: Text(alert['level'] as String),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () {},
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemLogs() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'سجلات النظام',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  final logs = [
                    '2025-01-09 10:30:15 - تم تسجيل دخول مستخدم جديد',
                    '2025-01-09 10:25:42 - تم إنشاء طلب جديد #1234',
                    '2025-01-09 10:20:18 - تم تحديث حالة السائق',
                    '2025-01-09 10:15:33 - تم إضافة موظف جديد',
                    '2025-01-09 10:10:27 - تم إرسال إشعار للمستخدم',
                    '2025-01-09 10:05:14 - تم تحديث قاعدة البيانات',
                    '2025-01-09 10:00:08 - تم بدء تشغيل النظام',
                  ];
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      logs[index % logs.length],
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإعدادات العامة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('التحديث التلقائي'),
              subtitle: const Text('تحديث البيانات كل 30 ثانية'),
              value: true,
              onChanged: (value) {},
              activeColor: Colors.blue,
            ),
            SwitchListTile(
              title: const Text('الوضع الليلي'),
              subtitle: const Text('تفعيل الوضع المظلم'),
              value: false,
              onChanged: (value) {},
              activeColor: Colors.blue,
            ),
            SwitchListTile(
              title: const Text('الإشعارات الصوتية'),
              subtitle: const Text('تشغيل صوت عند وصول تنبيه'),
              value: true,
              onChanged: (value) {},
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إعدادات الإشعارات',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('إشعارات الطلبات الجديدة'),
              subtitle: const Text('تلقي إشعار عند وصول طلب جديد'),
              value: true,
              onChanged: (value) {},
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text('إشعارات المستخدمين'),
              subtitle: const Text('تلقي إشعار عند تسجيل مستخدم جديد'),
              value: true,
              onChanged: (value) {},
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text('إشعارات النظام'),
              subtitle: const Text('تلقي إشعارات حالة النظام'),
              value: false,
              onChanged: (value) {},
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إعدادات الأمان',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.red),
              title: const Text('تغيير كلمة المرور'),
              subtitle: const Text('تحديث كلمة مرور الحساب'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.orange),
              title: const Text('المصادقة الثنائية'),
              subtitle: const Text('تفعيل حماية إضافية للحساب'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
                activeColor: Colors.orange,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: const Text('سجل الدخول'),
              subtitle: const Text('عرض محاولات الدخول الأخيرة'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatabaseSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إعدادات قاعدة البيانات',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.backup, color: Colors.green),
              title: const Text('نسخ احتياطي'),
              subtitle: const Text('إنشاء نسخة احتياطية من البيانات'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.restore, color: Colors.blue),
              title: const Text('استعادة البيانات'),
              subtitle: const Text('استعادة من نسخة احتياطية'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.cleaning_services, color: Colors.orange),
              title: const Text('تنظيف البيانات'),
              subtitle: const Text('حذف البيانات القديمة'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الإشعارات'),
        content: const Text('لا توجد إشعارات جديدة'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showReport(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تقرير ${type == 'orders' ? 'الطلبات' : type == 'users' ? 'المستخدمين' : 'الإيرادات'}'),
        content: const Text('تقرير مفصل قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
