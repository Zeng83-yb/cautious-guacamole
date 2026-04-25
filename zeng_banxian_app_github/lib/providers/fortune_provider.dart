import 'package:flutter/foundation.dart';
import '../models/fortune_model.dart';
import '../api/fortune_api.dart';

/// 算命状态管理器
class FortuneProvider extends ChangeNotifier {
  BirthInfo? _birthInfo;
  FortuneResult? _fortuneResult;
  bool _isLoading = false;
  String? _error;

  BirthInfo? get birthInfo => _birthInfo;
  FortuneResult? get fortuneResult => _fortuneResult;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 保存用户输入的生辰信息
  void setBirthInfo(BirthInfo info) {
    _birthInfo = info;
    notifyListeners();
  }

  /// 从互联网获取算命数据并生成结果
  Future<void> generateFortune() async {
    if (_birthInfo == null) {
      _error = '请先输入生辰信息';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 调用 API 获取算命结果
      _fortuneResult = await FortuneApi.getFortune(_birthInfo!);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = '获取算命结果失败：$e';
      notifyListeners();
    }
  }

  /// 清除结果
  void clear() {
    _birthInfo = null;
    _fortuneResult = null;
    _error = null;
    notifyListeners();
  }
}
