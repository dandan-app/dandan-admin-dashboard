import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/supabase_database_service.dart';

class OrdersManagementPage extends StatefulWidget {
  const OrdersManagementPage({super.key});

  @override
  State<OrdersManagementPage> createState() => _OrdersManagementPageState();
}

class _OrdersManagementPageState extends State<OrdersManagementPage> {
  String _selectedFilter = 'all';
  String _selectedSort = 'newest';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الطلبات المتقدمة'),
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
            // شريط البحث والفلترة
            _buildSearchAndFilterBar(context),
            
            const SizedBox(height: 24),
            
            // إحصائيات سريعة
            _buildQuickStats(context),
            
            const SizedBox(height: 24),
            
            // قائمة الطلبات
            _buildOrdersList(context),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSearchAndFilterBar(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Column(
          children: [
            // شريط البحث
            TextField(
              decoration: InputDecoration(
                hintText: 'البحث في الطلبات...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // الفلاتر والترتيب
            isMobile ? Column(
              children: [
                // فلتر الحالة
                DropdownButtonFormField<String>(
                  value: _selectedFilter,
                  decoration: const InputDecoration(
                    labelText: 'فلتر الحالة',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('جميع الطلبات')),
                    DropdownMenuItem(value: 'pending', child: Text('معلقة')),
                    DropdownMenuItem(value: 'confirmed', child: Text('مؤكدة')),
                    DropdownMenuItem(value: 'in_progress', child: Text('قيد التنفيذ')),
                    DropdownMenuItem(value: 'completed', child: Text('مكتملة')),
                    DropdownMenuItem(value: 'cancelled', child: Text('ملغية')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                  },
                ),
                
                const SizedBox(height: 12),
                
                // ترتيب
                DropdownButtonFormField<String>(
                  value: _selectedSort,
                  decoration: const InputDecoration(
                    labelText: 'ترتيب',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'newest', child: Text('الأحدث أولاً')),
                    DropdownMenuItem(value: 'oldest', child: Text('الأقدم أولاً')),
                    DropdownMenuItem(value: 'price_high', child: Text('أعلى سعر')),
                    DropdownMenuItem(value: 'price_low', child: Text('أقل سعر')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSort = value!;
                    });
                  },
                ),
              ],
            ) : Row(
              children: [
                // فلتر الحالة
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedFilter,
                    decoration: const InputDecoration(
                      labelText: 'فلتر الحالة',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('جميع الطلبات')),
                      DropdownMenuItem(value: 'pending', child: Text('معلقة')),
                      DropdownMenuItem(value: 'confirmed', child: Text('مؤكدة')),
                      DropdownMenuItem(value: 'in_progress', child: Text('قيد التنفيذ')),
                      DropdownMenuItem(value: 'completed', child: Text('مكتملة')),
                      DropdownMenuItem(value: 'cancelled', child: Text('ملغية')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                      });
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // ترتيب
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSort,
                    decoration: const InputDecoration(
                      labelText: 'ترتيب',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'newest', child: Text('الأحدث أولاً')),
                      DropdownMenuItem(value: 'oldest', child: Text('الأقدم أولاً')),
                      DropdownMenuItem(value: 'price_high', child: Text('أعلى سعر')),
                      DropdownMenuItem(value: 'price_low', child: Text('أقل سعر')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedSort = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickStats(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            title: 'إجمالي الطلبات',
            value: '156',
            icon: Icons.shopping_cart,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'طلبات اليوم',
            value: '24',
            icon: Icons.today,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'قيد التنفيذ',
            value: '8',
            icon: Icons.hourglass_empty,
            color: Colors.orange,
          ),
        ),
        if (!isMobile) ...[
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              title: 'مكتملة',
              value: '142',
              icon: Icons.check_circle,
              color: Colors.purple,
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          children: [
            Icon(icon, color: color, size: isMobile ? 24 : 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 18 : 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: isMobile ? 10 : 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildOrdersList(BuildContext context) {
    return StreamBuilder<List<OrderModel>>(
      stream: SupabaseDatabaseService.getOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text('خطأ في تحميل الطلبات: ${snapshot.error}'),
          );
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('لا يوجد طلبات'),
          );
        }
        
        List<OrderModel> orders = snapshot.data!;
        
        // تطبيق الفلترة
        if (_selectedFilter != 'all') {
          orders = orders.where((order) {
            switch (_selectedFilter) {
              case 'pending':
                return order.status == OrderStatus.pending;
              case 'confirmed':
                return order.status == OrderStatus.confirmed;
              case 'in_progress':
                return order.status == OrderStatus.inProgress;
              case 'completed':
                return order.status == OrderStatus.completed;
              case 'cancelled':
                return order.status == OrderStatus.cancelled;
              default:
                return true;
            }
          }).toList();
        }
        
        // تطبيق البحث
        if (_searchQuery.isNotEmpty) {
          orders = orders.where((order) {
            return order.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   order.pickupAddress.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   order.deliveryAddress.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();
        }
        
        // تطبيق الترتيب
        switch (_selectedSort) {
          case 'newest':
            orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            break;
          case 'oldest':
            orders.sort((a, b) => a.createdAt.compareTo(b.createdAt));
            break;
          case 'price_high':
            orders.sort((a, b) => b.price.compareTo(a.price));
            break;
          case 'price_low':
            orders.sort((a, b) => a.price.compareTo(b.price));
            break;
        }
        
        return Card(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderCard(context, order);
            },
          ),
        );
      },
    );
  }
  
  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Card(
      margin: const EdgeInsets.all(8),
      child: isMobile ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(order.status).withOpacity(0.1),
              child: Icon(
                Icons.shopping_cart,
                color: _getStatusColor(order.status),
                size: 20,
              ),
            ),
            title: Text(
              'طلب #${order.id.substring(0, 8)}',
              style: const TextStyle(fontSize: 14),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(
                  label: Text(
                    order.statusText,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getStatusColor(order.status).withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleOrderAction(context, order, value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'view', child: Text('عرض التفاصيل')),
                    const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                    const PopupMenuItem(value: 'assign', child: Text('تعيين سائق')),
                    const PopupMenuItem(value: 'track', child: Text('تتبع')),
                    const PopupMenuItem(value: 'cancel', child: Text('إلغاء')),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'العميل: ${order.customerName}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'من: ${order.pickupAddress}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'إلى: ${order.deliveryAddress}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'السعر: ${order.price.toStringAsFixed(2)} ر.س',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  _getTimeAgo(order.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ) : ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(order.status).withOpacity(0.1),
          child: Icon(
            Icons.shopping_cart,
            color: _getStatusColor(order.status),
          ),
        ),
        title: Text('طلب #${order.id.substring(0, 8)}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('العميل: ${order.customerName}'),
            Text('من: ${order.pickupAddress}'),
            Text('إلى: ${order.deliveryAddress}'),
            Text('السعر: ${order.price.toStringAsFixed(2)} ر.س'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(order.statusText),
              backgroundColor: _getStatusColor(order.status).withOpacity(0.1),
              labelStyle: TextStyle(
                color: _getStatusColor(order.status),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _getTimeAgo(order.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) => _handleOrderAction(context, order, value),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'view', child: Text('عرض التفاصيل')),
                const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                const PopupMenuItem(value: 'assign', child: Text('تعيين سائق')),
                const PopupMenuItem(value: 'track', child: Text('تتبع')),
                const PopupMenuItem(value: 'cancel', child: Text('إلغاء')),
              ],
              child: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
  
  void _handleOrderAction(BuildContext context, OrderModel order, String action) {
    switch (action) {
      case 'view':
        _showOrderDetails(context, order);
        break;
      case 'edit':
        _editOrder(context, order);
        break;
      case 'assign':
        _assignDriver(context, order);
        break;
      case 'track':
        _trackOrder(context, order);
        break;
      case 'cancel':
        _cancelOrder(context, order);
        break;
    }
  }
  
  void _showOrderDetails(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الطلب #${order.id.substring(0, 8)}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('العميل', order.customerName),
              _buildDetailRow('رقم الطلب', order.id),
              _buildDetailRow('من', order.pickupAddress),
              _buildDetailRow('إلى', order.deliveryAddress),
              _buildDetailRow('السعر', '${order.price.toStringAsFixed(2)} ر.س'),
              _buildDetailRow('الحالة', order.statusText),
              _buildDetailRow('تاريخ الإنشاء', order.createdAt.toString()),
              if (order.completedAt != null)
                _buildDetailRow('تاريخ الإكمال', order.completedAt.toString()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _editOrder(context, order);
            },
            child: const Text('تعديل'),
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
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  void _editOrder(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعديل الطلب #${order.id.substring(0, 8)}'),
        content: const Text('ميزة تعديل الطلب قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
  
  void _assignDriver(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعيين سائق للطلب #${order.id.substring(0, 8)}'),
        content: const Text('ميزة تعيين السائق قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
  
  void _trackOrder(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تتبع الطلب #${order.id.substring(0, 8)}'),
        content: const Text('ميزة تتبع الطلب قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
  
  void _cancelOrder(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الطلب'),
        content: const Text('هل أنت متأكد من إلغاء هذا الطلب؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إلغاء الطلب')),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
  
  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.inProgress:
        return Colors.purple;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
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
}
