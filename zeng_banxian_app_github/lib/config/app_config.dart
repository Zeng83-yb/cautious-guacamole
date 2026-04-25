/// 应用配置类
class AppConfig {
  // 应用信息
  static const String appName = '曾半仙';
  static const String appVersion = '1.0.0';
  static const String appDescription = '精通八字命理 洞察人生玄机';

  // API 配置
  static const int apiTimeoutSeconds = 5;
  static const int maxRetryAttempts = 3;
  
  // 缓存配置
  static const int cacheDurationHours = 24;
  
  // UI 配置
  static const String primaryFontFamily = 'MaShanZheng';
  
  // 颜色主题
  static const int primaryColorValue = 0xFF8B4513;
  static const int accentColorValue = 0xFFFFC107;
  
  // 分享配置
  static const String shareTitle = '曾半仙算命 - 我的运势分析';
  static const String shareText = '快来试试曾半仙算命，看看你的运势如何！';
}
