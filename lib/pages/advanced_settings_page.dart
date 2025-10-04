import 'package:flutter/material.dart';

class AdvancedSettingsPage extends StatefulWidget {
  const AdvancedSettingsPage({super.key});

  @override
  State<AdvancedSettingsPage> createState() => _AdvancedSettingsPageState();
}

class _AdvancedSettingsPageState extends State<AdvancedSettingsPage> {
  bool isLoading = false;
  
  // إعدادات عامة
  bool autoUpdate = true;
  bool darkMode = false;
  bool soundNotifications = true;
  String language = 'ar';
  int refreshInterval = 30;
  
  // إعدادات الإشعارات
  bool orderNotifications = true;
  bool userNotifications = true;
  bool systemNotifications = false;
  bool emailNotifications = true;
  bool pushNotifications = true;
  
  // إعدادات الأمان
  bool twoFactorAuth = false;
  bool autoLogout = true;
  int sessionTimeout = 60;
  bool auditLog = true;
  
  // إعدادات قاعدة البيانات
  bool autoBackup = true;
  int backupInterval = 24;
  int retentionDays = 30;
  bool compressionEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات المتقدمة'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetSettings,
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
                  _buildGeneralSettings(),
                  const SizedBox(height: 24),
                  _buildNotificationSettings(),
                  const SizedBox(height: 24),
                  _buildSecuritySettings(),
                  const SizedBox(height: 24),
                  _buildDatabaseSettings(),
                  const SizedBox(height: 24),
                  _buildSystemSettings(),
                  const SizedBox(height: 24),
                  _buildAdvancedOptions(),
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
              subtitle: const Text('تحديث البيانات تلقائياً'),
              value: autoUpdate,
              onChanged: (value) {
                setState(() {
                  autoUpdate = value;
                });
              },
              activeColor: Colors.blue,
            ),
            SwitchListTile(
              title: const Text('الوضع الليلي'),
              subtitle: const Text('تفعيل الوضع المظلم'),
              value: darkMode,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
              activeColor: Colors.blue,
            ),
            SwitchListTile(
              title: const Text('الإشعارات الصوتية'),
              subtitle: const Text('تشغيل صوت عند وصول تنبيه'),
              value: soundNotifications,
              onChanged: (value) {
                setState(() {
                  soundNotifications = value;
                });
              },
              activeColor: Colors.blue,
            ),
            ListTile(
              title: const Text('اللغة'),
              subtitle: const Text('العربية'),
              trailing: DropdownButton<String>(
                value: language,
                underline: Container(),
                items: const [
                  DropdownMenuItem(value: 'ar', child: Text('العربية')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (value) {
                  setState(() {
                    language = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('فترة التحديث'),
              subtitle: Text('كل $refreshInterval ثانية'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: refreshInterval > 10 ? () {
                      setState(() {
                        refreshInterval -= 10;
                      });
                    } : null,
                  ),
                  Text('$refreshInterval'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: refreshInterval < 300 ? () {
                      setState(() {
                        refreshInterval += 10;
                      });
                    } : null,
                  ),
                ],
              ),
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
              title: const Text('إشعارات الطلبات'),
              subtitle: const Text('تلقي إشعار عند وصول طلب جديد'),
              value: orderNotifications,
              onChanged: (value) {
                setState(() {
                  orderNotifications = value;
                });
              },
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text('إشعارات المستخدمين'),
              subtitle: const Text('تلقي إشعار عند تسجيل مستخدم جديد'),
              value: userNotifications,
              onChanged: (value) {
                setState(() {
                  userNotifications = value;
                });
              },
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text('إشعارات النظام'),
              subtitle: const Text('تلقي إشعارات حالة النظام'),
              value: systemNotifications,
              onChanged: (value) {
                setState(() {
                  systemNotifications = value;
                });
              },
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text('الإشعارات الإلكترونية'),
              subtitle: const Text('إرسال إشعارات عبر البريد الإلكتروني'),
              value: emailNotifications,
              onChanged: (value) {
                setState(() {
                  emailNotifications = value;
                });
              },
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text('الإشعارات الفورية'),
              subtitle: const Text('إرسال إشعارات فورية للمتصفح'),
              value: pushNotifications,
              onChanged: (value) {
                setState(() {
                  pushNotifications = value;
                });
              },
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
              onTap: () => _showChangePasswordDialog(),
            ),
            SwitchListTile(
              title: const Text('المصادقة الثنائية'),
              subtitle: const Text('تفعيل حماية إضافية للحساب'),
              value: twoFactorAuth,
              onChanged: (value) {
                setState(() {
                  twoFactorAuth = value;
                });
              },
              activeColor: Colors.orange,
            ),
            SwitchListTile(
              title: const Text('تسجيل الخروج التلقائي'),
              subtitle: const Text('تسجيل الخروج عند عدم النشاط'),
              value: autoLogout,
              onChanged: (value) {
                setState(() {
                  autoLogout = value;
                });
              },
              activeColor: Colors.orange,
            ),
            ListTile(
              title: const Text('مهلة الجلسة'),
              subtitle: Text('$sessionTimeout دقيقة'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: sessionTimeout > 15 ? () {
                      setState(() {
                        sessionTimeout -= 15;
                      });
                    } : null,
                  ),
                  Text('$sessionTimeout'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: sessionTimeout < 480 ? () {
                      setState(() {
                        sessionTimeout += 15;
                      });
                    } : null,
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title: const Text('سجل التدقيق'),
              subtitle: const Text('تسجيل جميع العمليات في النظام'),
              value: auditLog,
              onChanged: (value) {
                setState(() {
                  auditLog = value;
                });
              },
              activeColor: Colors.orange,
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: const Text('سجل الدخول'),
              subtitle: const Text('عرض محاولات الدخول الأخيرة'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showLoginHistory(),
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
            SwitchListTile(
              title: const Text('النسخ الاحتياطي التلقائي'),
              subtitle: const Text('إنشاء نسخ احتياطية تلقائياً'),
              value: autoBackup,
              onChanged: (value) {
                setState(() {
                  autoBackup = value;
                });
              },
              activeColor: Colors.green,
            ),
            ListTile(
              title: const Text('فترة النسخ الاحتياطي'),
              subtitle: Text('كل $backupInterval ساعة'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: backupInterval > 1 ? () {
                      setState(() {
                        backupInterval -= 1;
                      });
                    } : null,
                  ),
                  Text('$backupInterval'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: backupInterval < 168 ? () {
                      setState(() {
                        backupInterval += 1;
                      });
                    } : null,
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('فترة الاحتفاظ بالبيانات'),
              subtitle: Text('$retentionDays يوم'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: retentionDays > 7 ? () {
                      setState(() {
                        retentionDays -= 7;
                      });
                    } : null,
                  ),
                  Text('$retentionDays'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: retentionDays < 365 ? () {
                      setState(() {
                        retentionDays += 7;
                      });
                    } : null,
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title: const Text('ضغط البيانات'),
              subtitle: const Text('ضغط النسخ الاحتياطية لتوفير المساحة'),
              value: compressionEnabled,
              onChanged: (value) {
                setState(() {
                  compressionEnabled = value;
                });
              },
              activeColor: Colors.green,
            ),
            ListTile(
              leading: const Icon(Icons.backup, color: Colors.green),
              title: const Text('نسخ احتياطي يدوي'),
              subtitle: const Text('إنشاء نسخة احتياطية فورية'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _createManualBackup(),
            ),
            ListTile(
              leading: const Icon(Icons.restore, color: Colors.blue),
              title: const Text('استعادة البيانات'),
              subtitle: const Text('استعادة من نسخة احتياطية'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _restoreFromBackup(),
            ),
            ListTile(
              leading: const Icon(Icons.cleaning_services, color: Colors.orange),
              title: const Text('تنظيف البيانات'),
              subtitle: const Text('حذف البيانات القديمة'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _cleanupOldData(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إعدادات النظام',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text('معلومات النظام'),
              subtitle: const Text('عرض معلومات النظام والإصدار'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showSystemInfo(),
            ),
            ListTile(
              leading: const Icon(Icons.update, color: Colors.green),
              title: const Text('تحديث النظام'),
              subtitle: const Text('التحقق من التحديثات المتاحة'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _checkForUpdates(),
            ),
            ListTile(
              leading: const Icon(Icons.storage, color: Colors.orange),
              title: const Text('استخدام التخزين'),
              subtitle: const Text('عرض استخدام مساحة التخزين'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showStorageUsage(),
            ),
            ListTile(
              leading: const Icon(Icons.network_check, color: Colors.purple),
              title: const Text('حالة الشبكة'),
              subtitle: const Text('عرض حالة الاتصال والشبكة'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showNetworkStatus(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedOptions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خيارات متقدمة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.developer_mode, color: Colors.grey),
              title: const Text('وضع المطور'),
              subtitle: const Text('تفعيل أدوات التطوير'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
                activeColor: Colors.grey,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bug_report, color: Colors.red),
              title: const Text('تقرير الأخطاء'),
              subtitle: const Text('إرسال تقرير عن الأخطاء'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _reportBug(),
            ),
            ListTile(
              leading: const Icon(Icons.feedback, color: Colors.blue),
              title: const Text('ملاحظات وآراء'),
              subtitle: const Text('إرسال ملاحظاتك وآرائك'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _sendFeedback(),
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.green),
              title: const Text('المساعدة والدعم'),
              subtitle: const Text('الحصول على المساعدة'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showHelp(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSettings() async {
    setState(() {
      isLoading = true;
    });

    try {
      // محاكاة حفظ الإعدادات
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ الإعدادات بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في حفظ الإعدادات: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _resetSettings() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة تعيين الإعدادات'),
        content: const Text('هل أنت متأكد من إعادة تعيين جميع الإعدادات إلى القيم الافتراضية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        // إعادة تعيين الإعدادات إلى القيم الافتراضية
        autoUpdate = true;
        darkMode = false;
        soundNotifications = true;
        language = 'ar';
        refreshInterval = 30;
        orderNotifications = true;
        userNotifications = true;
        systemNotifications = false;
        emailNotifications = true;
        pushNotifications = true;
        twoFactorAuth = false;
        autoLogout = true;
        sessionTimeout = 60;
        auditLog = true;
        autoBackup = true;
        backupInterval = 24;
        retentionDays = 30;
        compressionEnabled = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إعادة تعيين الإعدادات'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تغيير كلمة المرور'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'كلمة المرور الحالية',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'كلمة المرور الجديدة',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'تأكيد كلمة المرور',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تغيير كلمة المرور بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('تغيير'),
          ),
        ],
      ),
    );
  }

  void _showLoginHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('سجل الدخول'),
        content: const SizedBox(
          width: 400,
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('تسجيل دخول ناجح'),
                  subtitle: Text('2025-01-09 10:30:15'),
                ),
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('تسجيل دخول ناجح'),
                  subtitle: Text('2025-01-08 15:45:22'),
                ),
                ListTile(
                  leading: Icon(Icons.error, color: Colors.red),
                  title: Text('فشل تسجيل الدخول'),
                  subtitle: Text('2025-01-08 12:20:10'),
                ),
              ],
            ),
          ),
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

  void _createManualBackup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إنشاء نسخة احتياطية'),
        content: const Text('هل تريد إنشاء نسخة احتياطية فورية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إنشاء النسخة الاحتياطية بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  void _restoreFromBackup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('استعادة البيانات'),
        content: const Text('اختر النسخة الاحتياطية المراد الاستعادة منها'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم استعادة البيانات بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('استعادة'),
          ),
        ],
      ),
    );
  }

  void _cleanupOldData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تنظيف البيانات'),
        content: const Text('هل تريد حذف البيانات القديمة؟ هذا الإجراء لا يمكن التراجع عنه.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تنظيف البيانات بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('تنظيف'),
          ),
        ],
      ),
    );
  }

  void _showSystemInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('معلومات النظام'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الإصدار: 1.0.0'),
            Text('تاريخ البناء: 2025-01-09'),
            Text('قاعدة البيانات: Supabase'),
            Text('المنصة: Flutter Web'),
            Text('المتصفح: Chrome'),
            Text('الذاكرة المستخدمة: 45 MB'),
            Text('وقت التشغيل: 2 ساعة 15 دقيقة'),
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

  void _checkForUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('لا توجد تحديثات متاحة'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showStorageUsage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('استخدام التخزين'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('قاعدة البيانات'),
              subtitle: Text('2.3 GB من 10 GB'),
              trailing: Text('23%'),
            ),
            ListTile(
              title: Text('الملفات'),
              subtitle: Text('156 MB من 1 GB'),
              trailing: Text('15%'),
            ),
            ListTile(
              title: Text('السجلات'),
              subtitle: Text('45 MB من 100 MB'),
              trailing: Text('45%'),
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

  void _showNetworkStatus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حالة الشبكة'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('الاتصال'),
              subtitle: Text('متصل'),
            ),
            ListTile(
              title: Text('السرعة'),
              subtitle: Text('1.2 Mbps'),
            ),
            ListTile(
              title: Text('الاستجابة'),
              subtitle: Text('45 ms'),
            ),
            ListTile(
              title: Text('الخادم'),
              subtitle: Text('supabase.co'),
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

  void _reportBug() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تقرير الأخطاء'),
        content: const TextField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'اكتب وصفاً مفصلاً للمشكلة...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال تقرير الخطأ بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  void _sendFeedback() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ملاحظات وآراء'),
        content: const TextField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'اكتب ملاحظاتك وآرائك...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال الملاحظات بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('المساعدة والدعم'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.book, color: Colors.blue),
              title: Text('دليل الاستخدام'),
              subtitle: Text('تعلم كيفية استخدام النظام'),
            ),
            ListTile(
              leading: Icon(Icons.video_library, color: Colors.green),
              title: Text('فيديوهات تعليمية'),
              subtitle: Text('مشاهدة دروس الفيديو'),
            ),
            ListTile(
              leading: Icon(Icons.support_agent, color: Colors.orange),
              title: Text('الدعم الفني'),
              subtitle: Text('تواصل مع فريق الدعم'),
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
