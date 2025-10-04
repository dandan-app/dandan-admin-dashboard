import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/supabase_database_service.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String selectedPeriod = 'week';
  bool isLoading = true;
  
  Map<String, dynamic> analyticsData = {};

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // تحميل البيانات التحليلية
      await Future.delayed(const Duration(seconds: 1)); // محاكاة تحميل البيانات
      
      setState(() {
        analyticsData = {
          'revenue': {
            'total': 125000,
            'growth': 12.5,
            'daily': [1200, 1500, 800, 2000, 1800, 2500, 2200],
          },
          'orders': {
            'total': 156,
            'growth': 8.3,
            'daily': [12, 15, 8, 20, 18, 25, 22],
          },
          'users': {
            'total': 89,
            'growth': 15.2,
            'daily': [5, 8, 3, 12, 9, 15, 11],
          },
          'conversion': {
            'rate': 68.5,
            'growth': 5.2,
          }
        };
        isLoading = false;
      });
    } catch (e) {
      print('خطأ في تحميل البيانات التحليلية: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحليلات المتقدمة'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          DropdownButton<String>(
            value: selectedPeriod,
            underline: Container(),
            style: const TextStyle(color: Colors.white),
            items: const [
              DropdownMenuItem(value: 'day', child: Text('اليوم')),
              DropdownMenuItem(value: 'week', child: Text('الأسبوع')),
              DropdownMenuItem(value: 'month', child: Text('الشهر')),
              DropdownMenuItem(value: 'year', child: Text('السنة')),
            ],
            onChanged: (value) {
              setState(() {
                selectedPeriod = value!;
              });
              _loadAnalyticsData();
            },
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
                  _buildKPICards(),
                  const SizedBox(height: 24),
                  _buildChartsSection(),
                  const SizedBox(height: 24),
                  _buildDetailedAnalytics(),
                ],
              ),
            ),
    );
  }

  Widget _buildKPICards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المؤشرات الرئيسية',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildKPICard('الإيرادات', '${analyticsData['revenue']['total']}', 'ر.س', Colors.green, analyticsData['revenue']['growth'])),
            const SizedBox(width: 12),
            Expanded(child: _buildKPICard('الطلبات', '${analyticsData['orders']['total']}', 'طلب', Colors.blue, analyticsData['orders']['growth'])),
            const SizedBox(width: 12),
            Expanded(child: _buildKPICard('المستخدمين', '${analyticsData['users']['total']}', 'مستخدم', Colors.orange, analyticsData['users']['growth'])),
            const SizedBox(width: 12),
            Expanded(child: _buildKPICard('معدل التحويل', '${analyticsData['conversion']['rate']}', '%', Colors.purple, analyticsData['conversion']['growth'])),
          ],
        ),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, String unit, Color color, double growth) {
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
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: growth > 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${growth > 0 ? '+' : ''}$growth%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: growth > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
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
              unit,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الرسوم البيانية',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildLineChart(
                'الإيرادات اليومية',
                analyticsData['revenue']['daily'],
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLineChart(
                'الطلبات اليومية',
                analyticsData['orders']['daily'],
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildBarChart('نمو المستخدمين', analyticsData['users']['daily'], Colors.orange),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPieChart('توزيع الطلبات', Colors.purple),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLineChart(String title, List<int> data, Color color) {
    final spots = data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList();
    
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
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
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

  Widget _buildBarChart(String title, List<int> data, Color color) {
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
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: data.reduce((a, b) => a > b ? a : b).toDouble() + 5,
                  barGroups: data.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.toDouble(),
                          color: color,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(String title, Color color) {
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
                  sections: [
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
                  ],
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedAnalytics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تحليلات مفصلة',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                'أفضل أوقات الطلبات',
                Icons.access_time,
                Colors.blue,
                ['10:00 - 12:00', '14:00 - 16:00', '19:00 - 21:00'],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAnalyticsCard(
                'أكثر المناطق طلباً',
                Icons.location_on,
                Colors.green,
                ['الرياض', 'جدة', 'الدمام', 'مكة'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                'أنواع الطلبات',
                Icons.category,
                Colors.orange,
                ['طعام: 45%', 'توصيل: 35%', 'خدمات: 20%'],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAnalyticsCard(
                'معدل الرضا',
                Icons.sentiment_satisfied,
                Colors.purple,
                ['ممتاز: 78%', 'جيد: 18%', 'مقبول: 4%'],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(String title, IconData icon, Color color, List<String> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
