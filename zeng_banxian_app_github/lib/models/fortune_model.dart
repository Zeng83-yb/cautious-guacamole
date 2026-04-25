/// 生辰八字数据模型
class BirthInfo {
  String name;
  DateTime birthDate;
  String? birthTime; // 可选的出生时辰
  String gender; // 'male' or 'female'
  
  // 农历信息
  late String lunarYear;
  late String lunarMonth;
  late String lunarDay;
  
  // 八字
  late String yearGanZhi;
  late String monthGanZhi;
  late String dayGanZhi;
  late String hourGanZhi;

  BirthInfo({
    required this.name,
    required this.birthDate,
    this.birthTime,
    required this.gender,
  }) {
    _calculateLunarAndBazi();
  }

  void _calculateLunarAndBazi() {
    // 简化版的天干地支计算
    final heavenlyStems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    final earthlyBranches = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
    
    // 年柱计算
    int yearIndex = (birthDate.year - 4) % 60;
    int stemIndex = yearIndex % 10;
    int branchIndex = yearIndex % 12;
    yearGanZhi = '${heavenlyStems[stemIndex]}${earthlyBranches[branchIndex]}';
    
    // 月柱计算（简化）
    int monthIndex = ((birthDate.year - 4) % 5) * 12 + birthDate.month - 1;
    stemIndex = monthIndex % 10;
    branchIndex = (birthDate.month + 2) % 12;
    monthGanZhi = '${heavenlyStems[stemIndex]}${earthlyBranches[branchIndex]}';
    
    // 日柱计算（简化，实际需要查表）
    int dayOffset = birthDate.difference(DateTime(birthDate.year, 1, 1)).inDays;
    stemIndex = (birthDate.year + dayOffset) % 10;
    branchIndex = (birthDate.year + dayOffset) % 12;
    dayGanZhi = '${heavenlyStems[stemIndex < 0 ? stemIndex + 10 : stemIndex]}${earthlyBranches[branchIndex < 0 ? branchIndex + 12 : branchIndex]}';
    
    // 时柱计算
    if (birthTime != null) {
      int hour = int.parse(birthTime!.split(':')[0]);
      int timeBranch = ((hour + 1) ~/ 2) % 12;
      int timeStem = (stemIndex * 2 + timeBranch) % 10;
      hourGanZhi = '${heavenlyStems[timeStem]}${earthlyBranches[timeBranch]}';
    } else {
      hourGanZhi = '未知';
    }
    
    // 农历年月日（简化显示）
    lunarYear = '$birthDate 年';
    lunarMonth = '${birthDate.month}月';
    lunarDay = '${birthDate.day}日';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'birthTime': birthTime,
      'gender': gender,
      'lunarYear': lunarYear,
      'lunarMonth': lunarMonth,
      'lunarDay': lunarDay,
      'bazi': {
        'year': yearGanZhi,
        'month': monthGanZhi,
        'day': dayGanZhi,
        'hour': hourGanZhi,
      },
    };
  }
}

/// 算命结果数据模型
class FortuneResult {
  String overallScore; // 综合评分
  String fortuneType; // 运势类型
  String career; // 事业运
  String love; // 爱情运
  String wealth; // 财运
  String health; // 健康运
  String advice; // 建议
  String luckyNumber; // 幸运数字
  String luckyColor; // 幸运颜色
  String taboo; // 禁忌

  FortuneResult({
    required this.overallScore,
    required this.fortuneType,
    required this.career,
    required this.love,
    required this.wealth,
    required this.health,
    required this.advice,
    required this.luckyNumber,
    required this.luckyColor,
    required this.taboo,
  });

  factory FortuneResult.fromJson(Map<String, dynamic> json) {
    return FortuneResult(
      overallScore: json['overall_score'] ?? '待定',
      fortuneType: json['fortune_type'] ?? '普通',
      career: json['career'] ?? '平稳发展',
      love: json['love'] ?? '感情和睦',
      wealth: json['wealth'] ?? '财运亨通',
      health: json['health'] ?? '身体健康',
      advice: json['advice'] ?? '顺其自然',
      luckyNumber: json['lucky_number'] ?? '8',
      luckyColor: json['lucky_color'] ?? '红色',
      taboo: json['taboo'] ?? '无特殊禁忌',
    );
  }
}
