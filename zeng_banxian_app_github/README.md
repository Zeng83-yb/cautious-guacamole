# 曾半仙算命 APP

一个基于 Flutter 开发的娱乐性算命应用，提供生辰八字排盘、五行分析、运势详解等功能。

## 功能特点

- 📝 姓名和生辰八字输入
- 🔮 自动八字排盘（天干地支计算）
- 🌟 五行分析
- 📊 运势详解（事业/爱情/财运/健康）
- 🍀 幸运元素推荐

## 技术栈

- **框架**: Flutter
- **状态管理**: Provider
- **网络请求**: Dio
- **本地存储**: SharedPreferences

## 构建说明

### 使用 Codemagic 在线构建

1. 将此仓库连接到 [Codemagic](https://codemagic.io/)
2. 配置 Flutter 工作流
3. 触发构建
4. 下载生成的 APK 文件

### 本地构建

```bash
flutter pub get
flutter build apk --release
```

生成的 APK 位于：`build/app/outputs/flutter-apk/app-release.apk`

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── api/                      # API 接口
├── config/                   # 配置文件
├── models/                   # 数据模型
├── providers/                # 状态管理
├── screens/                  # 页面
└── widgets/                  # 组件

android/                      # Android 平台配置
```

## 注意事项

- ⚠️ 本应用仅供娱乐参考
- 🔒 不存储用户个人信息
- 🚫 避免封建迷信宣传

## 许可证

MIT License
