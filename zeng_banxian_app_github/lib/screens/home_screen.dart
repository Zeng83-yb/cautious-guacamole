import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fortune_model.dart';
import '../providers/fortune_provider.dart';

/// 首页 - 生辰八字输入界面
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  String _selectedGender = 'male';

  final List<String> _timeOptions = [
    '子时 (23:00-01:00)',
    '丑时 (01:00-03:00)',
    '寅时 (03:00-05:00)',
    '卯时 (05:00-07:00)',
    '辰时 (07:00-09:00)',
    '巳时 (09:00-11:00)',
    '午时 (11:00-13:00)',
    '未时 (13:00-15:00)',
    '申时 (15:00-17:00)',
    '酉时 (17:00-19:00)',
    '戌时 (19:00-21:00)',
    '亥时 (21:00-23:00)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2C1810),
              const Color(0xFF5D4037),
              const Color(0xFF8B4513),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // 标题区域
                _buildHeader(),
                
                const SizedBox(height: 30),
                
                // 表单区域
                _buildForm(),
                
                const SizedBox(height: 30),
                
                // 提交按钮
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // 八卦图案装饰
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.amber, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 60,
            color: Colors.amber,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // 应用名称
        const Text(
          '曾半仙',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
            letterSpacing: 8,
          ),
        ),
        
        const SizedBox(height: 10),
        
        const Text(
          '精通八字命理 洞察人生玄机',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 姓名输入
          _buildInputField(
            controller: _nameController,
            label: '姓名',
            hint: '请输入您的姓名',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入姓名';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 20),
          
          // 性别选择
          _buildGenderSelector(),
          
          const SizedBox(height: 20),
          
          // 出生日期选择
          _buildDatePicker(),
          
          const SizedBox(height: 20),
          
          // 出生时辰选择
          _buildTimePicker(),
          
          const SizedBox(height: 20),
          
          // 八字显示预览
          _buildBaziPreview(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.amber),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.amber),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.amber),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.amber, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.amber, width: 2),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '性别',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Text('男'),
                selected: _selectedGender == 'male',
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedGender = 'male';
                    });
                  }
                },
                selectedColor: Colors.amber,
                labelStyle: TextStyle(
                  color: _selectedGender == 'male' 
                      ? Colors.brown[900] 
                      : Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ChoiceChip(
                label: const Text('女'),
                selected: _selectedGender == 'female',
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedGender = 'female';
                    });
                  }
                },
                selectedColor: Colors.amber,
                labelStyle: TextStyle(
                  color: _selectedGender == 'female' 
                      ? Colors.brown[900] 
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: '出生日期',
          labelStyle: const TextStyle(color: Colors.amber),
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.amber),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.amber),
          ),
        ),
        child: Text(
          '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return InkWell(
      onTap: _selectTime,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: '出生时辰（可选）',
          labelStyle: const TextStyle(color: Colors.amber),
          prefixIcon: const Icon(Icons.access_time, color: Colors.amber),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.amber),
          ),
        ),
        child: Text(
          _selectedTime ?? '请选择时辰',
          style: TextStyle(
            color: _selectedTime == null 
                ? Colors.white54 
                : Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBaziPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '生辰八字预览',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBaziColumn('年柱', '??'),
              _buildBaziColumn('月柱', '??'),
              _buildBaziColumn('日柱', '??'),
              _buildBaziColumn('时柱', _selectedTime == null ? '未知' : '??'),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '* 点击"开始算命"后将自动生成完整八字',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaziColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final provider = Provider.of<FortuneProvider>(context);

    if (provider.isLoading) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.brown[900],
          elevation: 8,
          shadowColor: Colors.amber.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          '开始算命',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.amber,
              onPrimary: Colors.brown,
              surface: Color(0xFF2C1810),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF2C1810),
      builder: (context) {
        return ListView.builder(
          itemCount: _timeOptions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                _timeOptions[index],
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context, _timeOptions[index]);
              },
            );
          },
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // 提取时辰的小时数
      String? timeHour;
      if (_selectedTime != null) {
        final timeStr = _selectedTime!.split(' ')[0];
        timeHour = '$timeStr:00';
      }

      // 创建生辰信息对象
      final birthInfo = BirthInfo(
        name: _nameController.text,
        birthDate: _selectedDate,
        birthTime: timeHour,
        gender: _selectedGender,
      );

      // 保存到状态管理器
      final provider = Provider.of<FortuneProvider>(context, listen: false);
      provider.setBirthInfo(birthInfo);

      // 生成算命结果
      provider.generateFortune();

      // 导航到结果页面
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushNamed(context, '/result');
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
