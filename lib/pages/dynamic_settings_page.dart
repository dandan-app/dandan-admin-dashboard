import 'package:flutter/material.dart';
import '../services/app_settings_service.dart';
import '../services/notification_service.dart';
import '../utils/setup_initial_data.dart';

class DynamicSettingsPage extends StatefulWidget {
  const DynamicSettingsPage({super.key});

  @override
  State<DynamicSettingsPage> createState() => _DynamicSettingsPageState();
}

class _DynamicSettingsPageState extends State<DynamicSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات التطبيق الديناميكية'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: AppSettingsService.getAppSettings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = snapshot.data!;
          final general = settings['general'] ?? {};
          final pricing = settings['pricing'] ?? {};
          final features = settings['features'] ?? {};

          return Scaffold(
            appBar: AppBar(
              title: const Text('الإعدادات الديناميكية'),
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
                // رسالة تحديث
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 16 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'إعدادات التطبيق الديناميكية',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'يمكنك الآن التحكم في إعدادات التطبيق الأساسي من هذه الصفحة. أي تغيير سينعكس فوراً على جميع المستخدمين.',
                          style: TextStyle(color: Colors.blue.shade600),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _setupInitialData(),
                          icon: const Icon(Icons.settings),
                          label: const Text('إعداد البيانات الأساسية'),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // إعدادات عامة
                _buildSettingsSection(
                  context,
                  title: 'الإعدادات العامة',
                  children: [
                    _buildMaintenanceToggle(general),
                    _buildTextSetting(
                      'اسم التطبيق',
                      general['app_name'] ?? 'دندن للنقل',
                      Icons.app_settings_alt,
                      () => _editAppName(general['app_name']),
                    ),
                    _buildTextSetting(
                      'هاتف الدعم',
                      general['support_phone'] ?? '+966500000000',
                      Icons.phone,
                      () => _editSupportPhone(general['support_phone']),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // إعدادات الأسعار
                _buildSettingsSection(
                  context,
                  title: 'إعدادات الأسعار',
                  children: [
                    _buildPricingSetting(
                      'السعر الأساسي',
                      pricing['base_price'] ?? 15.0,
                      'base_price',
                    ),
                    _buildPricingSetting(
                      'السعر لكل كيلومتر',
                      pricing['price_per_km'] ?? 2.5,
                      'price_per_km',
                    ),
                    _buildPricingSetting(
                      'السعر لكل كيلو',
                      pricing['price_per_kg'] ?? 1.0,
                      'price_per_kg',
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // إعدادات الميزات
                _buildSettingsSection(
                  context,
                  title: 'ميزات التطبيق',
                  children: [
                    _buildFeatureToggle('المحادثة', 'chat_enabled', features),
                    _buildFeatureToggle('المحفظة الإلكترونية', 'wallet_enabled', features),
                    _buildFeatureToggle('تتبع الطلبات', 'tracking_enabled', features),
                    _buildFeatureToggle('الطلبات المجدولة', 'scheduled_orders', features),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // إدارة الإشعارات
                _buildSettingsSection(
                  context,
                  title: 'إدارة الإشعارات',
                  children: [
                    ListTile(
                      leading: const Icon(Icons.notifications_active),
                      title: const Text('إرسال إشعار عام'),
                      subtitle: const Text('إرسال إشعار لجميع المستخدمين'),
                      trailing: const Icon(Icons.send),
                      onTap: () => _sendGeneralNotification(),
                    ),
                    ListTile(
                      leading: const Icon(Icons.campaign),
                      title: const Text('إعلان جديد'),
                      subtitle: const Text('نشر إعلان للمستخدمين'),
                      trailing: const Icon(Icons.add),
                      onTap: () => _createAnnouncement(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // معلومات النظام
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 16 : 20),
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
                        _buildInfoRow('إصدار التطبيق', general['app_version'] ?? '1.0.0'),
                        _buildInfoRow('اسم التطبيق', general['app_name'] ?? 'دندن للنقل'),
                        _buildInfoRow('السعر الأساسي', '${pricing['base_price'] ?? 15.0} ريال'),
                        _buildInfoRow('قاعدة البيانات', 'Firebase Firestore'),
                        _buildInfoRow('الخادم', 'Firebase Hosting'),
                        const SizedBox(height: 16),
                        const Text(
                          'الميزات النشطة:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (features['chat_enabled'] == true)
                              Chip(label: const Text('المحادثة'), backgroundColor: Colors.green.shade100),
                            if (features['wallet_enabled'] == true)
                              Chip(label: const Text('المحفظة'), backgroundColor: Colors.green.shade100),
                            if (features['tracking_enabled'] == true)
                              Chip(label: const Text('التتبع'), backgroundColor: Colors.green.shade100),
                            if (general['maintenance_mode'] == true)
                              Chip(label: const Text('وضع الصيانة'), backgroundColor: Colors.red.shade100),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildSettingsSection(BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
  
  Widget _buildMaintenanceToggle(Map<String, dynamic> general) {
    bool isEnabled = general['maintenance_mode'] ?? false;
    return SwitchListTile(
      secondary: const Icon(Icons.build),
      title: const Text('وضع الصيانة'),
      subtitle: Text(isEnabled ? 'مفعل' : 'معطل'),
      value: isEnabled,
      onChanged: (value) => _toggleMaintenanceMode(value),
    );
  }
  
  Widget _buildFeatureToggle(String title, String key, Map<String, dynamic> features) {
    bool isEnabled = features[key] ?? true;
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(isEnabled ? 'مفعلة' : 'معطلة'),
      value: isEnabled,
      onChanged: (value) => _toggleFeature(key, value),
    );
  }
  
  Widget _buildTextSetting(String title, String value, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.edit),
      onTap: onTap,
    );
  }
  
  Widget _buildPricingSetting(String title, double value, String key) {
    return ListTile(
      leading: const Icon(Icons.attach_money),
      title: Text(title),
      subtitle: Text('$value ريال'),
      trailing: const Icon(Icons.edit),
      onTap: () => _editPricing(key, value),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
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
  
  // ========== دوال الإجراءات ==========
  
  Future<void> _setupInitialData() async {
    _showSnackBar('جاري إعداد البيانات الأساسية...');
    bool success = await SetupInitialData.setupAllInitialData();
    _showSnackBar(success 
      ? 'تم إعداد البيانات الأساسية بنجاح' 
      : 'فشل في إعداد البيانات الأساسية'
    );
  }
  
  Future<void> _toggleMaintenanceMode(bool enabled) async {
    String? message;
    if (enabled) {
      message = await _showTextInputDialog(
        'وضع الصيانة',
        'أدخل رسالة الصيانة:',
        'النظام تحت الصيانة، يرجى المحاولة لاحقاً',
      );
      if (message == null) return;
    }
    
    bool success = await AppSettingsService.setMaintenanceMode(enabled, message);
    _showSnackBar(success ? 'تم تحديث وضع الصيانة' : 'فشل في تحديث وضع الصيانة');
    
    if (success && enabled) {
      await NotificationService.notifyMaintenanceMode(enabled: true, message: message);
    }
  }
  
  Future<void> _editAppName(String? currentName) async {
    String? newName = await _showTextInputDialog(
      'اسم التطبيق',
      'أدخل اسم التطبيق الجديد:',
      currentName ?? 'دندن للنقل',
    );
    
    if (newName != null && newName.isNotEmpty) {
      bool success = await AppSettingsService.updateAppInfo(appName: newName);
      _showSnackBar(success ? 'تم تحديث اسم التطبيق' : 'فشل في تحديث اسم التطبيق');
    }
  }
  
  Future<void> _editSupportPhone(String? currentPhone) async {
    String? newPhone = await _showTextInputDialog(
      'هاتف الدعم',
      'أدخل رقم هاتف الدعم:',
      currentPhone ?? '+966500000000',
    );
    
    if (newPhone != null && newPhone.isNotEmpty) {
      bool success = await AppSettingsService.updateAppInfo(supportPhone: newPhone);
      _showSnackBar(success ? 'تم تحديث هاتف الدعم' : 'فشل في تحديث هاتف الدعم');
    }
  }
  
  Future<void> _editPricing(String key, double currentValue) async {
    String? newValueStr = await _showTextInputDialog(
      'تحديث السعر',
      'أدخل القيمة الجديدة:',
      currentValue.toString(),
    );
    
    if (newValueStr != null) {
      double? newValue = double.tryParse(newValueStr);
      if (newValue != null && newValue >= 0) {
        bool success = await AppSettingsService.updatePricing(
          basePrice: key == 'base_price' ? newValue : null,
          pricePerKm: key == 'price_per_km' ? newValue : null,
          pricePerKg: key == 'price_per_kg' ? newValue : null,
        );
        
        _showSnackBar(success ? 'تم تحديث السعر' : 'فشل في تحديث السعر');
        
        if (success) {
          await NotificationService.sendGeneralAnnouncement(
            title: 'تحديث الأسعار',
            body: 'تم تحديث أسعار التوصيل، يرجى مراجعة الأسعار الجديدة',
          );
        }
      } else {
        _showSnackBar('يرجى إدخال رقم صحيح');
      }
    }
  }
  
  Future<void> _toggleFeature(String featureKey, bool enabled) async {
    bool success = await AppSettingsService.updateFeatures(
      chatEnabled: featureKey == 'chat_enabled' ? enabled : null,
      walletEnabled: featureKey == 'wallet_enabled' ? enabled : null,
      trackingEnabled: featureKey == 'tracking_enabled' ? enabled : null,
      scheduledOrders: featureKey == 'scheduled_orders' ? enabled : null,
    );
    
    _showSnackBar(success ? 'تم تحديث الميزة' : 'فشل في تحديث الميزة');
  }
  
  Future<void> _sendGeneralNotification() async {
    String? title = await _showTextInputDialog('عنوان الإشعار', 'أدخل عنوان الإشعار:', '');
    if (title == null || title.isEmpty) return;
    
    String? body = await _showTextInputDialog('محتوى الإشعار', 'أدخل محتوى الإشعار:', '');
    if (body == null || body.isEmpty) return;
    
    bool success = await NotificationService.sendGeneralAnnouncement(
      title: title,
      body: body,
    );
    
    _showSnackBar(success ? 'تم إرسال الإشعار' : 'فشل في إرسال الإشعار');
  }
  
  Future<void> _createAnnouncement() async {
    String? title = await _showTextInputDialog('عنوان الإعلان', 'أدخل عنوان الإعلان:', '');
    if (title == null || title.isEmpty) return;
    
    String? body = await _showTextInputDialog('محتوى الإعلان', 'أدخل محتوى الإعلان:', '');
    if (body == null || body.isEmpty) return;
    
    bool success = await NotificationService.sendGeneralAnnouncement(
      title: title,
      body: body,
      additionalData: {'type': 'announcement', 'priority': 'high'},
    );
    
    _showSnackBar(success ? 'تم نشر الإعلان' : 'فشل في نشر الإعلان');
  }
  
  // ========== دوال مساعدة ==========
  
  Future<String?> _showTextInputDialog(String title, String hint, String initialValue) async {
    TextEditingController controller = TextEditingController(text: initialValue);
    
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
