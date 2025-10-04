import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../services/supabase_database_service.dart';
import '../config/supabase_config.dart';

class EmployeesManagementPage extends StatefulWidget {
  const EmployeesManagementPage({super.key});

  @override
  State<EmployeesManagementPage> createState() => _EmployeesManagementPageState();
}

class _EmployeesManagementPageState extends State<EmployeesManagementPage> {
  List<EmployeeModel> employees = [];
  bool isLoading = true;
  String searchQuery = '';
  EmployeeStatus? statusFilter;
  Department? departmentFilter;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEmployees() async {
    try {
      setState(() {
        isLoading = true;
      });

      // استخدام SupabaseConfig.client مباشرة
      final response = await SupabaseConfig.client
          .from('employees')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        employees = response
            .map((item) => EmployeeModel.fromMap(item, item['id']))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('خطأ في تحميل الموظفين: $e');
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('خطأ في تحميل الموظفين: $e');
    }
  }

  List<EmployeeModel> get filteredEmployees {
    return employees.where((employee) {
      final matchesSearch = employee.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          employee.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
          employee.employeeId.toLowerCase().contains(searchQuery.toLowerCase());
      
      final matchesStatus = statusFilter == null || employee.status == statusFilter;
      final matchesDepartment = departmentFilter == null || employee.department == departmentFilter;
      
      return matchesSearch && matchesStatus && matchesDepartment;
    }).toList();
  }

  Future<void> _addEmployee() async {
    print('فتح نافذة إضافة موظف جديد...');
    
    final result = await showDialog<EmployeeModel>(
      context: context,
      builder: (context) => const AddEditEmployeeDialog(),
    );

    print('نتيجة النافذة: $result');

    if (result != null) {
      print('تم استلام بيانات الموظف من النافذة');
      try {
        print('محاولة إضافة الموظف إلى قاعدة البيانات...');
        final success = await SupabaseDatabaseService.addEmployee(result);
        
        if (success) {
          print('تم إضافة الموظف بنجاح، إعادة تحميل القائمة...');
          await _loadEmployees();
          _showSuccessMessage('تم إضافة الموظف بنجاح');
        } else {
          print('فشل في إضافة الموظف إلى قاعدة البيانات');
          _showErrorDialog('فشل في إضافة الموظف إلى قاعدة البيانات');
        }
      } catch (e) {
        print('خطأ في إضافة الموظف: $e');
        _showErrorDialog('خطأ في إضافة الموظف: $e');
      }
    } else {
      print('تم إلغاء إضافة الموظف أو لم يتم إدخال بيانات');
    }
  }

  Future<void> _editEmployee(EmployeeModel employee) async {
    final result = await showDialog<EmployeeModel>(
      context: context,
      builder: (context) => AddEditEmployeeDialog(employee: employee),
    );

    if (result != null) {
      try {
        await SupabaseDatabaseService.updateEmployee(result);
        
        await _loadEmployees();
        _showSuccessMessage('تم تحديث بيانات الموظف بنجاح');
      } catch (e) {
        _showErrorDialog('خطأ في تحديث بيانات الموظف: $e');
      }
    }
  }

  Future<void> _deleteEmployee(EmployeeModel employee) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الموظف ${employee.name}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await SupabaseDatabaseService.deleteEmployee(employee.id);
        
        await _loadEmployees();
        _showSuccessMessage('تم حذف الموظف بنجاح');
      } catch (e) {
        _showErrorDialog('خطأ في حذف الموظف: $e');
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الموظفين'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEmployees,
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث والفلترة
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              children: [
                // شريط البحث
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'البحث في الموظفين...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                
                // فلاتر
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<EmployeeStatus>(
                        value: statusFilter,
                        decoration: InputDecoration(
                          labelText: 'الحالة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('جميع الحالات'),
                          ),
                          ...EmployeeStatus.values.map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.displayName),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            statusFilter = value;
                          });
                        },
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: DropdownButtonFormField<Department>(
                        value: departmentFilter,
                        decoration: InputDecoration(
                          labelText: 'القسم',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('جميع الأقسام'),
                          ),
                          ...Department.values.map(
                            (department) => DropdownMenuItem(
                              value: department,
                              child: Text(department.displayName),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            departmentFilter = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // قائمة الموظفين
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredEmployees.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_search,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد نتائج',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'جرب تغيير معايير البحث أو الفلترة',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadEmployees,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredEmployees.length,
                          itemBuilder: (context, index) {
                            final employee = filteredEmployees[index];
                            return _buildEmployeeCard(employee);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmployeeCard(EmployeeModel employee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // صورة الموظف أو أيقونة افتراضية
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blue.shade100,
                  child: employee.profileImageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            employee.profileImageUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                color: Colors.blue.shade700,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: Colors.blue.shade700,
                        ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'رقم الموظف: ${employee.employeeId}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        employee.role.displayName,
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // حالة الموظف
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(employee.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(employee.status),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    employee.status.displayName,
                    style: TextStyle(
                      color: _getStatusColor(employee.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // معلومات إضافية
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    Icons.email,
                    employee.email,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    Icons.phone,
                    employee.phone,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    Icons.business,
                    employee.department.displayName,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    Icons.calendar_today,
                    'منذ ${employee.yearsOfService} سنة',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // أزرار الإجراءات
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editEmployee(employee),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('تعديل'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteEmployee(employee),
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('حذف'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red.shade300),
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

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(EmployeeStatus status) {
    switch (status) {
      case EmployeeStatus.active:
        return Colors.green;
      case EmployeeStatus.inactive:
        return Colors.orange;
      case EmployeeStatus.suspended:
        return Colors.red;
      case EmployeeStatus.terminated:
        return Colors.grey;
    }
  }
}

class AddEditEmployeeDialog extends StatefulWidget {
  final EmployeeModel? employee;

  const AddEditEmployeeDialog({super.key, this.employee});

  @override
  State<AddEditEmployeeDialog> createState() => _AddEditEmployeeDialogState();
}

class _AddEditEmployeeDialogState extends State<AddEditEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _salaryController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  EmployeeRole _selectedRole = EmployeeRole.operator;
  Department _selectedDepartment = Department.operations;
  EmployeeStatus _selectedStatus = EmployeeStatus.active;
  DateTime _selectedHireDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final employee = widget.employee!;
    _nameController.text = employee.name;
    _emailController.text = employee.email;
    _phoneController.text = employee.phone;
    _employeeIdController.text = employee.employeeId;
    _nationalIdController.text = employee.nationalId ?? '';
    _salaryController.text = employee.salary?.toString() ?? '';
    _emergencyContactController.text = employee.emergencyContact ?? '';
    _emergencyPhoneController.text = employee.emergencyPhone ?? '';
    _addressController.text = employee.address ?? '';
    _notesController.text = employee.notes ?? '';
    _selectedRole = employee.role;
    _selectedDepartment = employee.department;
    _selectedStatus = employee.status;
    _selectedHireDate = employee.hireDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _employeeIdController.dispose();
    _nationalIdController.dispose();
    _salaryController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedHireDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedHireDate = date;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      try {
        print('بدء إنشاء الموظف...');
        
        final employee = EmployeeModel(
          id: widget.employee?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          employeeId: _employeeIdController.text.trim(),
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          role: _selectedRole,
          department: _selectedDepartment,
          status: _selectedStatus,
          nationalId: _nationalIdController.text.trim().isEmpty 
              ? null 
              : _nationalIdController.text.trim(),
          hireDate: _selectedHireDate,
          salary: _salaryController.text.trim().isEmpty 
              ? null 
              : double.tryParse(_salaryController.text.trim()),
          emergencyContact: _emergencyContactController.text.trim().isEmpty 
              ? null 
              : _emergencyContactController.text.trim(),
          emergencyPhone: _emergencyPhoneController.text.trim().isEmpty 
              ? null 
              : _emergencyPhoneController.text.trim(),
          address: _addressController.text.trim().isEmpty 
              ? null 
              : _addressController.text.trim(),
          notes: _notesController.text.trim().isEmpty 
              ? null 
              : _notesController.text.trim(),
          createdAt: widget.employee?.createdAt ?? DateTime.now(),
        );

        print('تم إنشاء الموظف بنجاح: ${employee.name}');
        print('بيانات الموظف: ${employee.toMap()}');
        
        Navigator.of(context).pop(employee);
      } catch (e) {
        print('خطأ في إنشاء الموظف: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إنشاء الموظف: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print('فشل التحقق من صحة النموذج');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              widget.employee == null ? 'إضافة موظف جديد' : 'تعديل بيانات الموظف',
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
                      // الصف الأول
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'الاسم الكامل *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'يرجى إدخال الاسم';
                                }
                                return null;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: TextFormField(
                              controller: _employeeIdController,
                              decoration: const InputDecoration(
                                labelText: 'رقم الموظف *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'يرجى إدخال رقم الموظف';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // الصف الثاني
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'البريد الإلكتروني *',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'يرجى إدخال البريد الإلكتروني';
                                }
                                if (!value.contains('@')) {
                                  return 'يرجى إدخال بريد إلكتروني صحيح';
                                }
                                return null;
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'رقم الهاتف *',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'يرجى إدخال رقم الهاتف';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // الصف الثالث
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<EmployeeRole>(
                              value: _selectedRole,
                              decoration: const InputDecoration(
                                labelText: 'المنصب',
                                border: OutlineInputBorder(),
                              ),
                              items: EmployeeRole.values.map((role) {
                                return DropdownMenuItem(
                                  value: role,
                                  child: Text(role.displayName),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value!;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: DropdownButtonFormField<Department>(
                              value: _selectedDepartment,
                              decoration: const InputDecoration(
                                labelText: 'القسم',
                                border: OutlineInputBorder(),
                              ),
                              items: Department.values.map((department) {
                                return DropdownMenuItem(
                                  value: department,
                                  child: Text(department.displayName),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDepartment = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // الصف الرابع
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<EmployeeStatus>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: 'الحالة',
                                border: OutlineInputBorder(),
                              ),
                              items: EmployeeStatus.values.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status.displayName),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatus = value!;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: InkWell(
                              onTap: _selectDate,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'تاريخ التعيين',
                                  border: OutlineInputBorder(),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${_selectedHireDate.day}/${_selectedHireDate.month}/${_selectedHireDate.year}',
                                      ),
                                    ),
                                    const Icon(Icons.calendar_today),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // الصف الخامس
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nationalIdController,
                              decoration: const InputDecoration(
                                labelText: 'رقم الهوية الوطنية',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: TextFormField(
                              controller: _salaryController,
                              decoration: const InputDecoration(
                                labelText: 'الراتب',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // معلومات الطوارئ
                      TextFormField(
                        controller: _emergencyContactController,
                        decoration: const InputDecoration(
                          labelText: 'جهة الاتصال في الطوارئ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _emergencyPhoneController,
                        decoration: const InputDecoration(
                          labelText: 'رقم الطوارئ',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'العنوان',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'ملاحظات',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // أزرار الحفظ والإلغاء
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
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(widget.employee == null ? 'إضافة' : 'تحديث'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
