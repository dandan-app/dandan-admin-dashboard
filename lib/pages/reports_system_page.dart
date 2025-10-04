import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsSystemPage extends StatefulWidget {
  const ReportsSystemPage({super.key});

  @override
  State<ReportsSystemPage> createState() => _ReportsSystemPageState();
}

class _ReportsSystemPageState extends State<ReportsSystemPage> {
  bool isLoading = false;
  String selectedReportType = 'orders';
  String selectedPeriod = 'week';
  DateTimeRange? dateRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نظام التقارير'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printReport,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: _buildReportContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedReportType,
                  decoration: const InputDecoration(
                    labelText: 'نوع التقرير',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'orders', child: Text('تقرير الطلبات')),
                    DropdownMenuItem(value: 'users', child: Text('تقرير المستخدمين')),
                    DropdownMenuItem(value: 'revenue', child: Text('تقرير الإيرادات')),
                    DropdownMenuItem(value: 'performance', child: Text('تقرير الأداء')),
                    DropdownMenuItem(value: 'system', child: Text('تقرير النظام')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedReportType = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedPeriod,
                  decoration: const InputDecoration(
                    labelText: 'الفترة الزمنية',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'day', child: Text('اليوم')),
                    DropdownMenuItem(value: 'week', child: Text('الأسبوع')),
                    DropdownMenuItem(value: 'month', child: Text('الشهر')),
                    DropdownMenuItem(value: 'quarter', child: Text('الربع')),
                    DropdownMenuItem(value: 'year', child: Text('السنة')),
                    DropdownMenuItem(value: 'custom', child: Text('مخصص')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedPeriod = value!;
                      if (value == 'custom') {
                        _selectDateRange();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          if (selectedPeriod == 'custom' && dateRange != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.date_range, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    '${dateRange!.start.day}/${dateRange!.start.month}/${dateRange!.start.year} - ${dateRange!.end.day}/${dateRange!.end.month}/${dateRange!.end.year}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _selectDateRange,
                    child: const Text('تغيير'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReportContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReportHeader(),
          const SizedBox(height: 24),
          _buildReportSummary(),
          const SizedBox(height: 24),
          _buildReportCharts(),
          const SizedBox(height: 24),
          _buildDetailedData(),
        ],
      ),
    );
  }

  Widget _buildReportHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getReportIcon(),
                  size: 32,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getReportTitle(),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تم إنشاؤه في ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getPeriodText(),
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
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

  Widget _buildReportSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ملخص التقرير',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildSummaryCard('إجمالي', '156', 'طلب', Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('مكتمل', '142', 'طلب', Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('معلق', '8', 'طلب', Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildSummaryCard('ملغي', '6', 'طلب', Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, String unit, Color color) {
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
            value,
            style: TextStyle(
              fontSize: 24,
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
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCharts() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الرسوم البيانية',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildLineChart()),
                const SizedBox(width: 16),
                Expanded(child: _buildPieChart()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return Column(
      children: [
        Text(
          'اتجاه الطلبات',
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
                  spots: [
                    const FlSpot(0, 12),
                    const FlSpot(1, 15),
                    const FlSpot(2, 8),
                    const FlSpot(3, 20),
                    const FlSpot(4, 18),
                    const FlSpot(5, 25),
                    const FlSpot(6, 22),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return Column(
      children: [
        Text(
          'توزيع الحالات',
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
    );
  }

  Widget _buildDetailedData() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'البيانات التفصيلية',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchData,
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: _filterData,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('التاريخ')),
                  DataColumn(label: Text('رقم الطلب')),
                  DataColumn(label: Text('العميل')),
                  DataColumn(label: Text('الحالة')),
                  DataColumn(label: Text('المبلغ')),
                  DataColumn(label: Text('الإجراءات')),
                ],
                rows: List.generate(10, (index) {
                  return DataRow(
                    cells: [
                      DataCell(Text('2025-01-${9 + index}')),
                      DataCell(Text('#${1000 + index}')),
                      DataCell(Text('عميل ${index + 1}')),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: index % 3 == 0 ? Colors.green.shade100 : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            index % 3 == 0 ? 'مكتمل' : 'معلق',
                            style: TextStyle(
                              color: index % 3 == 0 ? Colors.green.shade700 : Colors.orange.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text('${(index + 1) * 50} ر.س')),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () => _viewDetails(index),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getReportIcon() {
    switch (selectedReportType) {
      case 'orders':
        return Icons.shopping_cart;
      case 'users':
        return Icons.people;
      case 'revenue':
        return Icons.attach_money;
      case 'performance':
        return Icons.analytics;
      case 'system':
        return Icons.computer;
      default:
        return Icons.description;
    }
  }

  String _getReportTitle() {
    switch (selectedReportType) {
      case 'orders':
        return 'تقرير الطلبات';
      case 'users':
        return 'تقرير المستخدمين';
      case 'revenue':
        return 'تقرير الإيرادات';
      case 'performance':
        return 'تقرير الأداء';
      case 'system':
        return 'تقرير النظام';
      default:
        return 'تقرير';
    }
  }

  String _getPeriodText() {
    switch (selectedPeriod) {
      case 'day':
        return 'اليوم';
      case 'week':
        return 'هذا الأسبوع';
      case 'month':
        return 'هذا الشهر';
      case 'quarter':
        return 'هذا الربع';
      case 'year':
        return 'هذا العام';
      case 'custom':
        return 'مخصص';
      default:
        return 'غير محدد';
    }
  }

  Future<void> _selectDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: dateRange,
    );
    
    if (range != null) {
      setState(() {
        dateRange = range;
      });
    }
  }

  void _exportReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصدير التقرير'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.table_chart),
              title: Text('Excel'),
              subtitle: Text('تصدير كملف Excel'),
            ),
            ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text('PDF'),
              subtitle: Text('تصدير كملف PDF'),
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('صورة'),
              subtitle: Text('تصدير كصورة'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  void _printReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال التقرير للطباعة'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _searchData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('البحث في البيانات'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'اكتب للبحث...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('بحث'),
          ),
        ],
      ),
    );
  }

  void _filterData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصفية البيانات'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('الحالة'),
              subtitle: Text('اختر حالة الطلبات'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text('المبلغ'),
              subtitle: Text('اختر نطاق المبلغ'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text('التاريخ'),
              subtitle: Text('اختر نطاق التاريخ'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('تطبيق'),
          ),
        ],
      ),
    );
  }

  void _viewDetails(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الطلب #${1000 + index}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('العميل: عميل ${index + 1}'),
            Text('التاريخ: 2025-01-${9 + index}'),
            Text('الحالة: ${index % 3 == 0 ? 'مكتمل' : 'معلق'}'),
            Text('المبلغ: ${(index + 1) * 50} ر.س'),
            Text('العنوان: عنوان ${index + 1}'),
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
