import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/fortune_model.dart';

/// 算命 API 服务类
/// 提供从互联网免费获取算命数据的功能
class FortuneApi {
  
  // 多个免费的算命数据源（示例 URL，实际使用需要替换为真实可用的 API）
  static const List<String> _apiEndpoints = [
    // 这里可以配置多个免费的算命 API 接口
    // 例如：一些提供黄历、八字查询的公开 API
    'https://api.example1.com/fortune',
    'https://api.example2.com/bazi',
    'https://api.example3.com/divination',
  ];

  /// 获取算命结果
  static Future<FortuneResult> getFortune(BirthInfo birthInfo) async {
    // 尝试从多个 API 端点获取数据
    for (String endpoint in _apiEndpoints) {
      try {
        final result = await _callApi(endpoint, birthInfo);
        if (result != null) {
          return result;
        }
      } catch (e) {
        // 尝试下一个 API
        continue;
      }
    }

    // 如果所有 API 都失败，使用本地算法生成结果
    return _generateLocalFortune(birthInfo);
  }

  /// 调用单个 API 端点
  static Future<FortuneResult?> _callApi(String endpoint, BirthInfo birthInfo) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(birthInfo.toJson()),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return FortuneResult.fromJson(data);
      }
    } catch (e) {
      // API 调用失败
    }
    return null;
  }

  /// 本地生成算命结果（备用方案）
  /// 基于传统命理学算法生成结果
  static FortuneResult _generateLocalFortune(BirthInfo birthInfo) {
    // 根据八字生成五行属性
    final wuxing = _calculateWuXing(birthInfo);
    
    // 根据五行和姓名生成各项运势
    final career = _interpretCareer(wuxing, birthInfo.name);
    final love = _interpretLove(wuxing, birthInfo.gender);
    final wealth = _interpretWealth(wuxing);
    final health = _interpretHealth(wuxing);
    
    // 生成幸运数字和颜色
    final luckyNumber = _getLuckyNumber(wuxing);
    final luckyColor = _getLuckyColor(wuxing);
    
    // 生成建议
    final advice = _getAdvice(wuxing);
    final taboo = _getTaboo(wuxing);

    return FortuneResult(
      overallScore: _calculateOverallScore(wuxing),
      fortuneType: _getFortuneType(wuxing),
      career: career,
      love: love,
      wealth: wealth,
      health: health,
      advice: advice,
      luckyNumber: luckyNumber,
      luckyColor: luckyColor,
      taboo: taboo,
    );
  }

  /// 计算五行属性
  static String _calculateWuXing(BirthInfo birthInfo) {
    // 根据天干地支计算五行
    final bazi = '${birthInfo.yearGanZhi}${birthInfo.monthGanZhi}${birthInfo.dayGanZhi}';
    
    int metal = 0, wood = 0, water = 0, fire = 0, earth = 0;
    
    for (int i = 0; i < bazi.length; i++) {
      final char = bazi[i];
      // 天干五行
      if ('甲乙'.contains(char)) wood++;
      else if ('丙丁'.contains(char)) fire++;
      else if ('戊己'.contains(char)) earth++;
      else if ('庚辛'.contains(char)) metal++;
      else if ('壬癸'.contains(char)) water++;
      // 地支五行
      else if ('寅卯'.contains(char)) wood++;
      else if ('巳午'.contains(char)) fire++;
      else if ('辰戌丑未'.contains(char)) earth++;
      else if ('申酉'.contains(char)) metal++;
      else if ('亥子'.contains(char)) water++;
    }

    // 返回最旺的五行
    final elements = {
      '金': metal,
      '木': wood,
      '水': water,
      '火': fire,
      '土': earth,
    };
    
    var maxElement = '金';
    var maxValue = metal;
    
    elements.forEach((key, value) {
      if (value > maxValue) {
        maxElement = key;
        maxValue = value;
      }
    });

    return maxElement;
  }

  /// 解读事业运
  static String _interpretCareer(String wuxing, String name) {
    switch (wuxing) {
      case '金':
        return '事业如金石般坚固，适合从事金融、法律、管理等职业。近期有晋升机会，宜把握。';
      case '木':
        return '事业发展如树木生长，适合教育、文化、艺术领域。创意灵感丰富，宜多展现才华。';
      case '水':
        return '事业灵活多变，适合贸易、物流、咨询行业。人际关系良好，贵人相助。';
      case '火':
        return '事业热情似火，适合销售、演艺、餐饮行业。表现欲强，易获关注。';
      case '土':
        return '事业稳健踏实，适合房地产、农业、建筑行业。基础牢固，长期发展佳。';
      default:
        return '事业平稳发展，努力工作必有回报。';
    }
  }

  /// 解读爱情运
  static String _interpretLove(String wuxing, String gender) {
    switch (wuxing) {
      case '金':
        return gender == 'male' 
            ? '感情专一，对伴侣忠诚。宜主动表达心意，避免过于严肃。'
            : '感情坚定，择偶标准高。宜放下戒备，多给彼此机会。';
      case '木':
        return '感情丰富细腻，善解人意。单身者易遇良缘，有伴侣者感情和睦。';
      case '水':
        return '感情温柔体贴，懂得包容。桃花运旺，但需谨防烂桃花。';
      case '火':
        return '感情热烈直接，敢爱敢恨。注意控制情绪，避免冲动行事。';
      case '土':
        return '感情稳定可靠，重视家庭。宜增加浪漫元素，让感情更有情趣。';
      default:
        return '感情运势平稳，珍惜眼前人。';
    }
  }

  /// 解读财运
  static String _interpretWealth(String wuxing) {
    switch (wuxing) {
      case '金':
        return '正财运佳，适合稳健投资。偏财运一般，不宜冒险投机。';
      case '木':
        return '财运渐长，适合长期投资。可通过学习新技能增加收入。';
      case '水':
        return '财运流动，有意外之财可能。宜理财规划，避免挥霍。';
      case '火':
        return '财运旺盛，但开销也大。宜量入为出，做好储蓄计划。';
      case '土':
        return '财运稳定，适合不动产投资。勤劳致富，积少成多。';
      default:
        return '财运亨通，努力必有收获。';
    }
  }

  /// 解读健康运
  static String _interpretHealth(String wuxing) {
    switch (wuxing) {
      case '金':
        return '注意呼吸系统和肺部保养。宜多运动，增强免疫力。';
      case '木':
        return '注意肝胆功能，保持心情舒畅。宜早睡早起，规律作息。';
      case '水':
        return '注意肾脏和泌尿系统。宜多喝水，避免熬夜。';
      case '火':
        return '注意心血管健康，避免过度劳累。宜清淡饮食，适量运动。';
      case '土':
        return '注意脾胃消化功能。宜规律饮食，少吃生冷食物。';
      default:
        return '身体健康，保持良好生活习惯即可。';
    }
  }

  /// 获取幸运数字
  static String _getLuckyNumber(String wuxing) {
    switch (wuxing) {
      case '金':
        return '4、9';
      case '木':
        return '3、8';
      case '水':
        return '1、6';
      case '火':
        return '2、7';
      case '土':
        return '5、0';
      default:
        return '8';
    }
  }

  /// 获取幸运颜色
  static String _getLuckyColor(String wuxing) {
    switch (wuxing) {
      case '金':
        return '白色、金色';
      case '木':
        return '绿色、青色';
      case '水':
        return '黑色、蓝色';
      case '火':
        return '红色、紫色';
      case '土':
        return '黄色、棕色';
      default:
        return '红色';
    }
  }

  /// 获取建议
  static String _getAdvice(String wuxing) {
    switch (wuxing) {
      case '金':
        return '保持刚毅果断，但也要学会柔软变通。多与人沟通，增进人际关系。';
      case '木':
        return '发挥创造力，勇于尝试新事物。注意劳逸结合，避免过度消耗精力。';
      case '水':
        return '保持灵活智慧，顺势而为。坚定信心，不要优柔寡断。';
      case '火':
        return '保持热情活力，但要注意控制脾气。学会倾听他人意见。';
      case '土':
        return '保持诚信稳重，脚踏实地。适当突破舒适区，迎接新挑战。';
      default:
        return '顺其自然，保持积极心态。';
    }
  }

  /// 获取禁忌
  static String _getTaboo(String wuxing) {
    switch (wuxing) {
      case '金':
        return '忌西方出行，忌穿戴过多红色饰品。';
      case '木':
        return '忌西方发展，忌砍伐树木，忌过度饮酒。';
      case '水':
        return '忌西南方出行，忌暴饮暴食，忌熬夜。';
      case '火':
        return '忌北方发展，忌辛辣刺激食物，忌情绪激动。';
      case '土':
        return '忌东方出行，忌生冷食物，忌久坐不动。';
      default:
        return '无特殊禁忌';
    }
  }

  /// 计算综合评分
  static String _calculateOverallScore(String wuxing) {
    // 根据五行平衡程度给出评分
    switch (wuxing) {
      case '金':
      case '木':
        return '85 分 - 运势上佳';
      case '水':
      case '火':
        return '80 分 - 运势良好';
      case '土':
        return '78 分 - 运势平稳';
      default:
        return '75 分 - 运势普通';
    }
  }

  /// 获取运势类型
  static String _getFortuneType(String wuxing) {
    switch (wuxing) {
      case '金':
        return '金刚运势';
      case '木':
        return '木茂运势';
      case '水':
        return '水润运势';
      case '火':
        return '火旺运势';
      case '土':
        return '土厚运势';
      default:
        return '普通运势';
    }
  }
}
