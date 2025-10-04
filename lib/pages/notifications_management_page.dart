import 'package:flutter/material.dart';

class NotificationsManagementPage extends StatefulWidget {
  const NotificationsManagementPage({super.key});

  @override
  State<NotificationsManagementPage> createState() => _NotificationsManagementPageState();
}

class _NotificationsManagementPageState extends State<NotificationsManagementPage> {
  bool isLoading = false;
  String selectedFilter = 'all';
  String selectedSort = 'newest';

  List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'title': 'طلب جديد',
      'message': 'تم استلام طلب جديد #1234 من العميل أحمد محمد',
      'type': 'order',
      'priority': 'high',
      'status': 'unread',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'sender': 'النظام',
      'icon': Icons.shopping_cart,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'title': 'مستخدم جديد',
      'message': 'انضم مستخدم جديد إلى النظام: سارة أحمد',
      'type': 'user',
      'priority': 'medium',
      'status': 'read',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'sender': 'النظام',
      'icon': Icons.person_add,
      'color': Colors.green,
    },
    {
      'id': '3',
      'title': 'تنبيه نظام',
      'message': 'استخدام التخزين وصل إلى 80% من السعة المتاحة',
      'type': 'system',
      'priority': 'high',
      'status': 'unread',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'sender': 'مراقب النظام',
      'icon': Icons.warning,
      'color': Colors.orange,
    },
    {
      'id': '4',
      'title': 'سائق متاح',
      'message': 'السائق محمد علي أصبح متاحاً لاستلام طلبات جديدة',
      'type': 'driver',
      'priority': 'low',
      'status': 'read',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'sender': 'النظام',
      'icon': Icons.drive_eta,
      'color': Colors.purple,
    },
    {
      'id': '5',
      'title': 'تحديث النظام',
      'message': 'تم تحديث النظام بنجاح إلى الإصدار 1.0.1',
      'type': 'system',
      'priority': 'medium',
      'status': 'read',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'sender': 'فريق التطوير',
      'icon': Icons.update,
      'color': Colors.blue,
    },
    {
      'id': '6',
      'title': 'تقرير يومي',
      'message': 'تقرير الأداء اليومي: 45 طلب مكتمل، 12 طلب معلق',
      'type': 'report',
      'priority': 'low',
      'status': 'read',
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
      'sender': 'النظام',
      'icon': Icons.analytics,
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الإشعارات'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: _markAllAsRead,
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearAllNotifications,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showNotificationSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: _buildNotificationsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNotification,
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedFilter,
              decoration: const InputDecoration(
                labelText: 'فلتر النوع',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('جميع الإشعارات')),
                DropdownMenuItem(value: 'unread', child: Text('غير مقروءة')),
                DropdownMenuItem(value: 'order', child: Text('الطلبات')),
                DropdownMenuItem(value: 'user', child: Text('المستخدمين')),
                DropdownMenuItem(value: 'system', child: Text('النظام')),
                DropdownMenuItem(value: 'driver', child: Text('السائقين')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedSort,
              decoration: const InputDecoration(
                labelText: 'ترتيب',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'newest', child: Text('الأحدث أولاً')),
                DropdownMenuItem(value: 'oldest', child: Text('الأقدم أولاً')),
                DropdownMenuItem(value: 'priority', child: Text('الأولوية')),
                DropdownMenuItem(value: 'type', child: Text('النوع')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedSort = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    List<Map<String, dynamic>> filteredNotifications = notifications;

    // تطبيق الفلترة
    if (selectedFilter != 'all') {
      filteredNotifications = notifications.where((notification) {
        switch (selectedFilter) {
          case 'unread':
            return notification['status'] == 'unread';
          case 'order':
          case 'user':
          case 'system':
          case 'driver':
            return notification['type'] == selectedFilter;
          default:
            return true;
        }
      }).toList();
    }

    // تطبيق الترتيب
    filteredNotifications.sort((a, b) {
      switch (selectedSort) {
        case 'newest':
          return b['timestamp'].compareTo(a['timestamp']);
        case 'oldest':
          return a['timestamp'].compareTo(b['timestamp']);
        case 'priority':
          final priorityOrder = {'high': 3, 'medium': 2, 'low': 1};
          return priorityOrder[b['priority']]!.compareTo(priorityOrder[a['priority']]!);
        case 'type':
          return a['type'].compareTo(b['type']);
        default:
          return 0;
      }
    });

    if (filteredNotifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'لا توجد إشعارات',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isUnread = notification['status'] == 'unread';
    final priority = notification['priority'];
    final timestamp = notification['timestamp'] as DateTime;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isUnread ? Colors.blue.shade50 : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: (notification['color'] as Color).withOpacity(0.1),
          child: Icon(
            notification['icon'] as IconData,
            color: notification['color'] as Color,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (priority == 'high')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'عاجل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification['message']),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  _getTimeAgo(timestamp),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.person,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  notification['sender'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleNotificationAction(notification, value),
          itemBuilder: (context) => [
            if (isUnread)
              const PopupMenuItem(
                value: 'mark_read',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read),
                    SizedBox(width: 8),
                    Text('وضع علامة مقروء'),
                  ],
                ),
              ),
            if (!isUnread)
              const PopupMenuItem(
                value: 'mark_unread',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_unread),
                    SizedBox(width: 8),
                    Text('وضع علامة غير مقروء'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'view_details',
              child: Row(
                children: [
                  Icon(Icons.info),
                  SizedBox(width: 8),
                  Text('عرض التفاصيل'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('حذف', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _viewNotificationDetails(notification),
      ),
    );
  }

  void _handleNotificationAction(Map<String, dynamic> notification, String action) {
    switch (action) {
      case 'mark_read':
        _markAsRead(notification);
        break;
      case 'mark_unread':
        _markAsUnread(notification);
        break;
      case 'view_details':
        _viewNotificationDetails(notification);
        break;
      case 'delete':
        _deleteNotification(notification);
        break;
    }
  }

  void _markAsRead(Map<String, dynamic> notification) {
    setState(() {
      notification['status'] = 'read';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم وضع علامة مقروء'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _markAsUnread(Map<String, dynamic> notification) {
    setState(() {
      notification['status'] = 'unread';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم وضع علامة غير مقروء'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['status'] = 'read';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم وضع علامة مقروء لجميع الإشعارات'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف جميع الإشعارات'),
        content: const Text('هل أنت متأكد من حذف جميع الإشعارات؟ هذا الإجراء لا يمكن التراجع عنه.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                notifications.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف جميع الإشعارات'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _deleteNotification(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الإشعار'),
        content: Text('هل أنت متأكد من حذف الإشعار "${notification['title']}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                notifications.removeWhere((n) => n['id'] == notification['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حذف الإشعار'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _viewNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['title']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    notification['icon'] as IconData,
                    color: notification['color'] as Color,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    notification['type'] == 'order' ? 'طلب' :
                    notification['type'] == 'user' ? 'مستخدم' :
                    notification['type'] == 'system' ? 'نظام' :
                    notification['type'] == 'driver' ? 'سائق' : 'تقرير',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                notification['message'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _buildDetailRow('المرسل', notification['sender']),
              _buildDetailRow('الأولوية', 
                notification['priority'] == 'high' ? 'عاجل' :
                notification['priority'] == 'medium' ? 'متوسط' : 'منخفض'
              ),
              _buildDetailRow('الحالة', 
                notification['status'] == 'read' ? 'مقروء' : 'غير مقروء'
              ),
              _buildDetailRow('الوقت', _formatDateTime(notification['timestamp'] as DateTime)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
          if (notification['status'] == 'unread')
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _markAsRead(notification);
              },
              child: const Text('وضع علامة مقروء'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

  void _createNotification() {
    showDialog(
      context: context,
      builder: (context) => _CreateNotificationDialog(
        onNotificationCreated: (notification) {
          setState(() {
            notifications.insert(0, notification);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إنشاء الإشعار بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعدادات الإشعارات'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text('الإشعارات الفورية'),
              subtitle: Text('تلقي الإشعارات فوراً'),
              trailing: Switch(value: true, onChanged: null),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('الإشعارات الإلكترونية'),
              subtitle: Text('إرسال نسخة عبر البريد'),
              trailing: Switch(value: true, onChanged: null),
            ),
            ListTile(
              leading: Icon(Icons.volume_up),
              title: Text('الأصوات'),
              subtitle: Text('تشغيل صوت عند وصول إشعار'),
              trailing: Switch(value: false, onChanged: null),
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('الوقت المثالي'),
              subtitle: Text('من 8:00 صباحاً إلى 10:00 مساءً'),
              trailing: Icon(Icons.arrow_forward_ios),
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

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _CreateNotificationDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onNotificationCreated;

  const _CreateNotificationDialog({required this.onNotificationCreated});

  @override
  State<_CreateNotificationDialog> createState() => _CreateNotificationDialogState();
}

class _CreateNotificationDialogState extends State<_CreateNotificationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _senderController = TextEditingController();
  
  String _selectedType = 'system';
  String _selectedPriority = 'medium';

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _senderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'إنشاء إشعار جديد',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'العنوان *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال العنوان';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'الرسالة *',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال الرسالة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _senderController,
                        decoration: const InputDecoration(
                          labelText: 'المرسل',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedType,
                              decoration: const InputDecoration(
                                labelText: 'النوع',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'system', child: Text('نظام')),
                                DropdownMenuItem(value: 'order', child: Text('طلب')),
                                DropdownMenuItem(value: 'user', child: Text('مستخدم')),
                                DropdownMenuItem(value: 'driver', child: Text('سائق')),
                                DropdownMenuItem(value: 'report', child: Text('تقرير')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedPriority,
                              decoration: const InputDecoration(
                                labelText: 'الأولوية',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'high', child: Text('عاجل')),
                                DropdownMenuItem(value: 'medium', child: Text('متوسط')),
                                DropdownMenuItem(value: 'low', child: Text('منخفض')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedPriority = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _createNotification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('إنشاء'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _createNotification() {
    if (_formKey.currentState!.validate()) {
      final notification = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleController.text.trim(),
        'message': _messageController.text.trim(),
        'type': _selectedType,
        'priority': _selectedPriority,
        'status': 'unread',
        'timestamp': DateTime.now(),
        'sender': _senderController.text.trim().isEmpty ? 'المدير' : _senderController.text.trim(),
        'icon': _getIconForType(_selectedType),
        'color': _getColorForType(_selectedType),
      };

      widget.onNotificationCreated(notification);
      Navigator.of(context).pop();
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_cart;
      case 'user':
        return Icons.person_add;
      case 'system':
        return Icons.warning;
      case 'driver':
        return Icons.drive_eta;
      case 'report':
        return Icons.analytics;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'order':
        return Colors.blue;
      case 'user':
        return Colors.green;
      case 'system':
        return Colors.orange;
      case 'driver':
        return Colors.purple;
      case 'report':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
