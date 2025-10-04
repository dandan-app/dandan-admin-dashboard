import 'package:flutter/material.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  // إعدادات التطبيق الرئيسي
  bool _appEnabled = true;
  bool _maintenanceMode = false;
  bool _newRegistrations = true;
  // bool _notificationsEnabled = true; // غير مستخدم حالياً
  String _appVersion = '1.0.0';
  String _minAppVersion = '1.0.0';
  
  // إعدادات الطلبات
  double _minOrderPrice = 10.0;
  double _maxOrderPrice = 1000.0;
  int _maxOrdersPerDay = 50;
  bool _autoAssignDrivers = false;
  
  // إعدادات السائقين
  double _driverCommission = 0.15; // 15%
  int _maxOrdersPerDriver = 10;
  bool _driverLocationTracking = true;
  
  // إعدادات الإشعارات
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات التطبيق'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إعدادات عامة للتطبيق
            _buildSettingsSection(
            context,
            title: 'الإعدادات العامة',
            icon: Icons.settings,
            children: [
              _buildSwitchSetting(
                context,
                title: 'تفعيل التطبيق',
                subtitle: 'إيقاف/تشغيل التطبيق للمستخدمين',
                value: _appEnabled,
                onChanged: (value) {
                  setState(() {
                    _appEnabled = value;
                  });
                },
              ),
              _buildSwitchSetting(
                context,
                title: 'وضع الصيانة',
                subtitle: 'إيقاف التطبيق مؤقتاً للصيانة',
                value: _maintenanceMode,
                onChanged: (value) {
                  setState(() {
                    _maintenanceMode = value;
                  });
                },
              ),
              _buildSwitchSetting(
                context,
                title: 'تسجيل مستخدمين جدد',
                subtitle: 'السماح بتسجيل مستخدمين جدد',
                value: _newRegistrations,
                onChanged: (value) {
                  setState(() {
                    _newRegistrations = value;
                  });
                },
              ),
              _buildTextSetting(
                context,
                title: 'إصدار التطبيق الحالي',
                subtitle: 'الإصدار المطلوب للمستخدمين',
                value: _appVersion,
                onChanged: (value) {
                  setState(() {
                    _appVersion = value;
                  });
                },
              ),
              _buildTextSetting(
                context,
                title: 'أقل إصدار مطلوب',
                subtitle: 'أقل إصدار يمكن للمستخدمين استخدامه',
                value: _minAppVersion,
                onChanged: (value) {
                  setState(() {
                    _minAppVersion = value;
                  });
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // إعدادات الطلبات
          _buildSettingsSection(
            context,
            title: 'إعدادات الطلبات',
            icon: Icons.shopping_cart,
            children: [
              _buildSliderSetting(
                context,
                title: 'أقل سعر للطلب',
                subtitle: '${_minOrderPrice.toStringAsFixed(0)} ر.س',
                value: _minOrderPrice,
                min: 5.0,
                max: 50.0,
                onChanged: (value) {
                  setState(() {
                    _minOrderPrice = value;
                  });
                },
              ),
              _buildSliderSetting(
                context,
                title: 'أعلى سعر للطلب',
                subtitle: '${_maxOrderPrice.toStringAsFixed(0)} ر.س',
                value: _maxOrderPrice,
                min: 100.0,
                max: 2000.0,
                onChanged: (value) {
                  setState(() {
                    _maxOrderPrice = value;
                  });
                },
              ),
              _buildSliderSetting(
                context,
                title: 'أقصى عدد طلبات يومياً',
                subtitle: '${_maxOrdersPerDay.toString()} طلب',
                value: _maxOrdersPerDay.toDouble(),
                min: 10.0,
                max: 200.0,
                onChanged: (value) {
                  setState(() {
                    _maxOrdersPerDay = value.round();
                  });
                },
              ),
              _buildSwitchSetting(
                context,
                title: 'تعيين السائقين تلقائياً',
                subtitle: 'تعيين أقرب سائق تلقائياً للطلب',
                value: _autoAssignDrivers,
                onChanged: (value) {
                  setState(() {
                    _autoAssignDrivers = value;
                  });
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // إعدادات السائقين
          _buildSettingsSection(
            context,
            title: 'إعدادات السائقين',
            icon: Icons.local_shipping,
            children: [
              _buildSliderSetting(
                context,
                title: 'عمولة السائق',
                subtitle: '${(_driverCommission * 100).toStringAsFixed(0)}%',
                value: _driverCommission,
                min: 0.05,
                max: 0.30,
                onChanged: (value) {
                  setState(() {
                    _driverCommission = value;
                  });
                },
              ),
              _buildSliderSetting(
                context,
                title: 'أقصى عدد طلبات للسائق',
                subtitle: '${_maxOrdersPerDriver.toString()} طلب يومياً',
                value: _maxOrdersPerDriver.toDouble(),
                min: 5.0,
                max: 50.0,
                onChanged: (value) {
                  setState(() {
                    _maxOrdersPerDriver = value.round();
                  });
                },
              ),
              _buildSwitchSetting(
                context,
                title: 'تتبع موقع السائق',
                subtitle: 'تتبع موقع السائق في الوقت الفعلي',
                value: _driverLocationTracking,
                onChanged: (value) {
                  setState(() {
                    _driverLocationTracking = value;
                  });
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // إعدادات الإشعارات
          _buildSettingsSection(
            context,
            title: 'إعدادات الإشعارات',
            icon: Icons.notifications,
            children: [
              _buildSwitchSetting(
                context,
                title: 'الإشعارات الفورية',
                subtitle: 'إرسال إشعارات فورية للمستخدمين',
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
              _buildSwitchSetting(
                context,
                title: 'إشعارات البريد الإلكتروني',
                subtitle: 'إرسال إشعارات عبر البريد الإلكتروني',
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
              _buildSwitchSetting(
                context,
                title: 'إشعارات SMS',
                subtitle: 'إرسال إشعارات عبر الرسائل النصية',
                value: _smsNotifications,
                onChanged: (value) {
                  setState(() {
                    _smsNotifications = value;
                  });
                },
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // أزرار الإجراءات
          _buildActionButtons(context),
        ],
      ),
    );
  }
  
  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 16 : 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
  
  Widget _buildSwitchSetting(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
  
  Widget _buildTextSetting(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: SizedBox(
        width: 100,
        child: TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSliderSetting(
    BuildContext context, {
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Column(
          children: [
            Text(
              'إجراءات النظام',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            if (isMobile) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveSettings,
                  icon: const Icon(Icons.save),
                  label: const Text('حفظ الإعدادات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _resetSettings,
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة تعيين'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _exportSettings,
                  icon: const Icon(Icons.download),
                  label: const Text('تصدير الإعدادات'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveSettings,
                      icon: const Icon(Icons.save),
                      label: const Text('حفظ الإعدادات'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetSettings,
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة تعيين'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _exportSettings,
                      icon: const Icon(Icons.download),
                      label: const Text('تصدير الإعدادات'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  void _saveSettings() {
    // TODO: حفظ الإعدادات في Firebase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ الإعدادات بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة تعيين الإعدادات'),
        content: const Text('هل أنت متأكد من إعادة تعيين جميع الإعدادات إلى القيم الافتراضية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _appEnabled = true;
                _maintenanceMode = false;
                _newRegistrations = true;
                _appVersion = '1.0.0';
                _minAppVersion = '1.0.0';
                _minOrderPrice = 10.0;
                _maxOrderPrice = 1000.0;
                _maxOrdersPerDay = 50;
                _autoAssignDrivers = false;
                _driverCommission = 0.15;
                _maxOrdersPerDriver = 10;
                _driverLocationTracking = true;
                _pushNotifications = true;
                _emailNotifications = true;
                _smsNotifications = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إعادة تعيين الإعدادات')),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
  
  void _exportSettings() {
    // TODO: تصدير الإعدادات
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تصدير الإعدادات')),
    );
  }
}
