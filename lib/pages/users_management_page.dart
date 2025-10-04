import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/supabase_database_service.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  String _selectedFilter = 'all';
  String _selectedSort = 'newest';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
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
            
            // قائمة المستخدمين
            _buildUsersList(context),
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
                hintText: 'البحث في المستخدمين...',
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
                    DropdownMenuItem(value: 'all', child: Text('جميع المستخدمين')),
                    DropdownMenuItem(value: 'active', child: Text('نشط')),
                    DropdownMenuItem(value: 'inactive', child: Text('غير نشط')),
                    DropdownMenuItem(value: 'super_admin', child: Text('مدير عام')),
                    DropdownMenuItem(value: 'admin', child: Text('مدير')),
                    DropdownMenuItem(value: 'regular', child: Text('مستخدم عادي')),
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
                    DropdownMenuItem(value: 'name', child: Text('الاسم')),
                    DropdownMenuItem(value: 'email', child: Text('البريد الإلكتروني')),
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
                      DropdownMenuItem(value: 'all', child: Text('جميع المستخدمين')),
                      DropdownMenuItem(value: 'active', child: Text('نشط')),
                      DropdownMenuItem(value: 'inactive', child: Text('غير نشط')),
                      DropdownMenuItem(value: 'super_admin', child: Text('مدير عام')),
                      DropdownMenuItem(value: 'admin', child: Text('مدير')),
                      DropdownMenuItem(value: 'regular', child: Text('مستخدم عادي')),
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
                      DropdownMenuItem(value: 'name', child: Text('الاسم')),
                      DropdownMenuItem(value: 'email', child: Text('البريد الإلكتروني')),
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
            title: 'إجمالي المستخدمين',
            value: '1,234',
            icon: Icons.people,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'نشط اليوم',
            value: '89',
            icon: Icons.today,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'جدد اليوم',
            value: '12',
            icon: Icons.person_add,
            color: Colors.orange,
          ),
        ),
        if (!isMobile) ...[
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              title: 'المديرين',
              value: '5',
              icon: Icons.admin_panel_settings,
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
  
  Widget _buildUsersList(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: SupabaseDatabaseService.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text('خطأ في تحميل المستخدمين: ${snapshot.error}'),
          );
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('لا يوجد مستخدمين'),
          );
        }
        
        List<UserModel> users = snapshot.data!;
        
        // تطبيق الفلترة
        if (_selectedFilter != 'all') {
          users = users.where((user) {
            switch (_selectedFilter) {
              case 'active':
                return user.isActive;
              case 'inactive':
                return !user.isActive;
              case 'super_admin':
                return user.role == UserRole.superAdmin;
              case 'admin':
                return user.role == UserRole.admin;
              case 'regular':
                return user.role == UserRole.regular;
              default:
                return true;
            }
          }).toList();
        }
        
        // تطبيق البحث
        if (_searchQuery.isNotEmpty) {
          users = users.where((user) {
            return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   user.email.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();
        }
        
        // تطبيق الترتيب
        switch (_selectedSort) {
          case 'newest':
            users.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            break;
          case 'oldest':
            users.sort((a, b) => a.createdAt.compareTo(b.createdAt));
            break;
          case 'name':
            users.sort((a, b) => a.name.compareTo(b.name));
            break;
          case 'email':
            users.sort((a, b) => a.email.compareTo(b.email));
            break;
        }
        
        return Card(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _buildUserCard(context, user);
            },
          ),
        );
      },
    );
  }
  
  Widget _buildUserCard(BuildContext context, UserModel user) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Card(
      margin: const EdgeInsets.all(8),
      child: isMobile ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: user.isActive 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: user.isActive ? Colors.green : Colors.red,
                size: 20,
              ),
            ),
            title: Text(
              user.name,
              style: const TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              user.email,
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(
                  label: Text(
                    user.role.displayName,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getRoleColor(user.role).withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: _getRoleColor(user.role),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleUserAction(context, user, value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'view', child: Text('عرض التفاصيل')),
                    const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                    const PopupMenuItem(value: 'toggle', child: Text('تفعيل/إلغاء')),
                    const PopupMenuItem(value: 'delete', child: Text('حذف')),
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
                  'الدور: ${user.role.displayName}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'الحالة: ${user.isActive ? "نشط" : "غير نشط"}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'تاريخ الإنشاء: ${user.createdAt.toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ) : ListTile(
        leading: CircleAvatar(
          backgroundColor: user.isActive 
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          child: Icon(
            Icons.person,
            color: user.isActive ? Colors.green : Colors.red,
          ),
        ),
        title: Text(user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            Text('الدور: ${user.role.displayName}'),
            Text('الحالة: ${user.isActive ? "نشط" : "غير نشط"}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(user.role.displayName),
              backgroundColor: _getRoleColor(user.role).withOpacity(0.1),
              labelStyle: TextStyle(
                color: _getRoleColor(user.role),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) => _handleUserAction(context, user, value),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'view', child: Text('عرض التفاصيل')),
                const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                const PopupMenuItem(value: 'toggle', child: Text('تفعيل/إلغاء')),
                const PopupMenuItem(value: 'delete', child: Text('حذف')),
              ],
              child: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
  
  void _handleUserAction(BuildContext context, UserModel user, String action) {
    switch (action) {
      case 'view':
        _showUserDetails(context, user);
        break;
      case 'edit':
        _editUser(context, user);
        break;
      case 'toggle':
        _toggleUserStatus(context, user);
        break;
      case 'delete':
        _deleteUser(context, user);
        break;
    }
  }
  
  void _showUserDetails(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل المستخدم: ${user.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('الاسم', user.name),
              _buildDetailRow('البريد الإلكتروني', user.email),
              _buildDetailRow('الدور', user.role.displayName),
              _buildDetailRow('الحالة', user.isActive ? "نشط" : "غير نشط"),
              _buildDetailRow('تاريخ الإنشاء', user.createdAt.toString()),
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
              _editUser(context, user);
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
  
  void _editUser(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعديل المستخدم: ${user.name}'),
        content: const Text('ميزة تعديل المستخدم قيد التطوير'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
  
  void _toggleUserStatus(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${user.isActive ? "إلغاء تفعيل" : "تفعيل"} المستخدم'),
        content: Text('هل أنت متأكد من ${user.isActive ? "إلغاء تفعيل" : "تفعيل"} ${user.name}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم ${user.isActive ? "إلغاء تفعيل" : "تفعيل"} المستخدم'),
                ),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
  
  void _deleteUser(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المستخدم'),
        content: Text('هل أنت متأكد من حذف ${user.name}؟ هذا الإجراء لا يمكن التراجع عنه.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حذف ${user.name}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
  
  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return Colors.red;
      case UserRole.admin:
        return Colors.orange;
      case UserRole.operations:
        return Colors.blue;
      case UserRole.support:
        return Colors.green;
      case UserRole.financial:
        return Colors.purple;
      case UserRole.regular:
        return Colors.grey;
    }
  }
}
