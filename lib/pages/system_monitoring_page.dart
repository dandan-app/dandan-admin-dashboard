import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SystemMonitoringPage extends StatefulWidget {
  const SystemMonitoringPage({super.key});

  @override
  State<SystemMonitoringPage> createState() => _SystemMonitoringPageState();
}

class _SystemMonitoringPageState extends State<SystemMonitoringPage> {
  bool isLoading = true;
  Map<String, dynamic> systemData = {};

  @override
  void initState() {
    super.initState();
    _loadSystemData();
    
    // تحديث البيانات كل 10 ثوان
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) _loadSystemData();
    });
  }

  Future<void> _loadSystemData() async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        systemData = {
          'status': {
            'database': {'status': 'متصل', 'response': '45ms', 'color': Colors.green},
            'api': {'status': 'يعمل', 'response': '120ms', 'color': Colors.green},
            'storage': {'status': 'متاح', 'response': '80ms', 'color': Colors.green},
            'notifications': {'status': 'نشط', 'response': '25ms', 'color': Colors.green},
          },
          'performance': {
            'cpu': 45.0,
            'memory': 68.0,
            'disk': 78.0,
            'network': 32.0,
          },
          'alerts': [
            {'type': 'warning', 'message': 'استخدام التخزين عالي', 'time': 'منذ 5 دقائق'},
            {'type': 'info', 'message': 'مستخدم جديد مسجل', 'time': 'منذ 12 دقيقة'},
            {'type': 'error', 'message': 'طلب جديد يحتاج مراجعة', 'time': 'منذ 18 دقيقة'},
          ],
          'logs': [
            '2025-01-09 10:30:15 - تم تسجيل دخول مستخدم جديد',
            '2025-01-09 10:25:42 - تم إنشاء طلب جديد #1234',
            '2025-01-09 10:20:18 - تم تحديث حالة السائق',
            '2025-01-09 10:15:33 - تم إضافة موظف جديد',
            '2025-01-09 10:10:27 - تم إرسال إشعار للمستخدم',
            '2025-01-09 10:05:14 - تم تحديث قاعدة البيانات',
          ],
        };
        isLoading = false;
      });
    } catch (e) {
      print('خطأ في تحميل بيانات النظام: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مراقبة النظام'),
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
            onPressed: _loadSystemData,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showMonitoringSettings(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSystemStatus(),
                  const SizedBox(height: 24),
                  _buildPerformanceMonitoring(),
                  const SizedBox(height: 24),
                  _buildAlertsSection(),
                  const SizedBox(height: 24),
                  _buildSystemLogs(),
                  const SizedBox(height: 24),
                  _buildHealthMetrics(),
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
                  child: _buildStatusCard(
                    'قاعدة البيانات',
                    systemData['status']['database']['status'],
                    systemData['status']['database']['response'],
                    systemData['status']['database']['color'],
                    Icons.storage,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatusCard(
                    'API',
                    systemData['status']['api']['status'],
                    systemData['status']['api']['response'],
                    systemData['status']['api']['color'],
                    Icons.api,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatusCard(
                    'التخزين',
                    systemData['status']['storage']['status'],
                    systemData['status']['storage']['response'],
                    systemData['status']['storage']['color'],
                    Icons.storage,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatusCard(
                    'الإشعارات',
                    systemData['status']['notifications']['status'],
                    systemData['status']['notifications']['response'],
                    systemData['status']['notifications']['color'],
                    Icons.notifications,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, String status, String response, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
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
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            response,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
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
                  child: _buildPerformanceCard(
                    'المعالج',
                    systemData['performance']['cpu'],
                    Colors.blue,
                    Icons.memory,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPerformanceCard(
                    'الذاكرة',
                    systemData['performance']['memory'],
                    Colors.green,
                    Icons.storage,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPerformanceCard(
                    'التخزين',
                    systemData['performance']['disk'],
                    Colors.orange,
                    Icons.storage,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPerformanceCard(
                    'الشبكة',
                    systemData['performance']['network'],
                    Colors.purple,
                    Icons.network_check,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPerformanceChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(String title, double value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            '${value.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value / 100,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 20,
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
                  const times = ['10:00', '10:05', '10:10', '10:15', '10:20', '10:25', '10:30'];
                  return Text(
                    times[value.toInt() % 7],
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 42,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(fontSize: 10),
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
              spots: [
                const FlSpot(0, 45),
                const FlSpot(1, 48),
                const FlSpot(2, 42),
                const FlSpot(3, 50),
                const FlSpot(4, 47),
                const FlSpot(5, 52),
                const FlSpot(6, 45),
              ],
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
            LineChartBarData(
              spots: [
                const FlSpot(0, 68),
                const FlSpot(1, 65),
                const FlSpot(2, 70),
                const FlSpot(3, 72),
                const FlSpot(4, 68),
                const FlSpot(5, 75),
                const FlSpot(6, 68),
              ],
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'التنبيهات',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...systemData['alerts'].map<Widget>((alert) {
              Color alertColor;
              IconData alertIcon;
              
              switch (alert['type']) {
                case 'error':
                  alertColor = Colors.red;
                  alertIcon = Icons.error;
                  break;
                case 'warning':
                  alertColor = Colors.orange;
                  alertIcon = Icons.warning;
                  break;
                default:
                  alertColor = Colors.blue;
                  alertIcon = Icons.info;
              }
              
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: alertColor.withOpacity(0.1),
                  child: Icon(alertIcon, color: alertColor, size: 20),
                ),
                title: Text(alert['message']),
                subtitle: Text(alert['time']),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () {},
                ),
              );
            }).toList(),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'سجلات النظام',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('تصفية'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('تصدير'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: systemData['logs'].length,
                itemBuilder: (context, index) {
                  final log = systemData['logs'][index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            log,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildHealthMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مؤشرات الصحة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildHealthMetric('صحة النظام', 95, Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildHealthMetric('الأمان', 88, Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildHealthMetric('الأداء', 92, Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildHealthMetric('الاستقرار', 96, Colors.purple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetric(String title, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            '$value%',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          CircularProgressIndicator(
            value: value / 100,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeWidth: 8,
          ),
        ],
      ),
    );
  }

  void _showMonitoringSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعدادات المراقبة'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.update),
              title: Text('فترة التحديث'),
              subtitle: Text('10 ثوان'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('التنبيهات'),
              subtitle: Text('تفعيل التنبيهات التلقائية'),
              trailing: Switch(value: true, onChanged: null),
            ),
            ListTile(
              leading: Icon(Icons.storage),
              title: Text('حفظ السجلات'),
              subtitle: Text('حفظ السجلات لمدة 30 يوم'),
              trailing: Switch(value: true, onChanged: null),
            ),
          ],
        ),
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
