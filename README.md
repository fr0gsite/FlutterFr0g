<p align="center">
  <img src="assets/frogwebp/84.webp" alt="Fr0gsite mascot" width="200"/>
</p>

<p align="center">
  <strong>Open-source, decentralized, self-managed community platform</strong><br/>
  <strong>Freedom of speech for everyone</strong>
</p>

<p align="center">
  <a href="https://github.com/fr0gsite/FlutterFr0g/releases"><img src="https://img.shields.io/github/v/release/fr0gsite/FlutterFr0g?style=flat-square" alt="Release"></a>
  <a href="https://github.com/fr0gsite/FlutterFr0g/blob/main/LICENSE"><img src="https://img.shields.io/github/license/fr0gsite/FlutterFr0g?style=flat-square" alt="License"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.35.5-blue.svg?style=flat-square&logo=flutter" alt="Flutter"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.9.2-blue.svg?style=flat-square&logo=dart" alt="Dart"></a>
  <a href="https://updown.io/p/zl73e"><img src="https://img.shields.io/badge/Status-Monitoring-green.svg?style=flat-square" alt="Server Status"></a>
</p>

<p align="center">
  <a href="https://fr0g.site"><img src="https://img.shields.io/badge/🌐_Live_Demo-fr0g.site-blue.svg?style=for-the-badge" alt="Live Demo"></a>
  <a href="https://t.me/fr0gsite"><img src="https://img.shields.io/badge/💬_Telegram-Community-blue.svg?style=for-the-badge&logo=telegram" alt="Telegram"></a>
  <a href="https://doc.fr0g.site/"><img src="https://img.shields.io/badge/📖_Documentation-Read_Docs-blue.svg?style=for-the-badge" alt="Documentation"></a>
</p>

# 🐸 Fr0g.site Flutter App

## 🎯 About the Project

Fr0g.site is a **decentralized, open-source community platform** based on blockchain technology and IPFS. The Flutter app enables users to share, comment on, and rate content - all without central control or censorship.

**Key Features:**
- 🔗 **Decentralized**: Based on blockchain and IPFS
- 🌍 **Cross-Platform**: Web, Android, iOS from a single codebase
- 🔒 **Privacy**: Private keys are stored locally
- 💰 **Token Economy**: ACT, FAME and TRUST tokens for various actions
- 🗳️ **Community Governance**: Self-management through Trusters and Block Producers
- 🌐 **Multilingual**: 14 languages supported

## 🚀 Quick Start (30 seconds)

```bash
# 1. Clone repository
git clone https://github.com/fr0gsite/FlutterFr0g.git
cd FlutterFr0g

# 2. Install dependencies  
flutter pub get

# 3. Start web version
flutter run -d chrome

# Alternative: Build APK for Android
flutter build apk
```

**Prerequisites:**
- Flutter 3.35.5+
- Dart 3.9.2+
- Chrome/Chromium (for Web)
- Android Studio (for Android)
- Xcode (for iOS)

## 📦 Installation & Setup

### Development Environment

1. **Install Flutter SDK:**
   ```bash
   # Via official Flutter website or
   git clone https://github.com/flutter/flutter.git -b stable
   export PATH="$PATH:`pwd`/flutter/bin"
   ```

2. **Project Setup:**
   ```bash
   git clone https://github.com/fr0gsite/FlutterFr0g.git
   cd FlutterFr0g
   flutter pub get
   flutter doctor  # Checks the installation
   ```

## 💻 Usage & Examples

### Internationalization

The app supports 14 languages. To add new translations:

```bash
# 1. Create ARB file
cp lib/l10n/app_en.arb lib/l10n/app_[LANGUAGE_CODE].arb

# 2. Add translations
# 3. Generate localizations
flutter gen-l10n
```

### Docker Deployment

```bash
# Production web build
flutter build web --release

# Create Docker image
docker build -t fr0gsite-flutter .

# Start container
docker run -p 80:80 fr0gsite-flutter
```

## ⚙️ Configuration

### Important Configuration Files

| File | Purpose |
|------|---------|
| `lib/config.dart` | Main configuration, URLs, blockchain nodes |
| `lib/config_debug.dart` | Debug login credentials (not versioned) |
| `pubspec.yaml` | Dependencies and app metadata |
| `analysis_options.yaml` | Dart linting rules |
| `l10n.yaml` | Internationalization configuration |


### Integration Tests
```bash
# Web Integration Tests (Chrome required)
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/web_app_test.dart \
  -d chrome

# Android Integration Tests
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d android
```

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Quick Contribution Guide

1. **Fork & Clone**
   ```bash
   git clone https://github.com/YOUR_USERNAME/FlutterFr0g.git
   cd FlutterFr0g
   ```

2. **Create Branch**
   ```bash
   git checkout -b feature/new-feature
   ```

3. **Develop & Test**
   ```bash
   flutter test
   flutter analyze
   ```

4. **Create Pull Request**

### Areas for Contribution

| Area | Description | Difficulty |
|------|-------------|------------|
| 🌐 **Translations** | Add new languages | Easy |
| 🐛 **Bug Fixes** | Issues from tracker | Easy-Medium |
| 🎨 **UI/UX** | Design improvements | Medium |
| ⚡ **Performance** | Optimizations | Medium-Hard |
| 🔗 **Blockchain** | Smart contract integration | Hard |

### Code Standards

- **Dart Style**: Use `dart format`
- **Linting**: `flutter analyze` must be clean
- **Tests**: New features need tests
- **Documentation**: Code should be documented

### Contributing Translations

```bash
# 1. Create ARB file for your language
cp lib/l10n/app_en.arb lib/l10n/app_[YOUR_LANGUAGE_CODE].arb

# 2. Translate & test
flutter gen-l10n
flutter run

# 3. Create pull request
```

Detailed guide: [CONTRIBUTING.md](CONTRIBUTING.md)

## 📜 License

This project is licensed under the **GNU General Public License v3.0**.

```
Copyright (C) 2024 Fr0gsite Contributors

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
```

See [LICENSE](LICENSE) for the full license text.

**What does this mean?**
- ✅ Commercial use
- ✅ Modification
- ✅ Distribution
- ✅ Private use
- ❌ Liability & Warranty
- ⚠️ Changes must be published under the same license

## 🆘 Support & Security

### Community Support

- 💬 **Telegram**: [https://t.me/fr0gsite](https://t.me/fr0gsite)
- 🐛 **Issues**: [GitHub Issues](https://github.com/fr0gsite/FlutterFr0g/issues)
- 📖 **Documentation**: [doc.fr0g.site](https://doc.fr0g.site/)
- 🌐 **Website**: On [fr0g.site](https://fr0g.site)

### FAQ

**Q: Where are my private keys stored?**
A: [Locally in secure storage](https://doc.fr0g.site/faq/#where-is-the-private-key-stored)

**Q: What's the difference between Active and Owner Permission?**
A: [See FAQ](https://doc.fr0g.site/faq/#what-is-the-difference-between-active-and-owner-permission)

**Q: How can I run my own node?**
A: [Participation Guide](https://doc.fr0g.site/participate/overview/)

### Security

🔒 **Report security issues**: Send an email to security@fr0g.site

**Security Guidelines:**
- Private keys are stored only locally
- All blockchain transactions are transparent
- IPFS content is publicly accessible
- No central storage of user data

## 🏆 Credits & Acknowledgments

### Main Developers
- **Fr0gsite Team** - Core development and concept

### Open Source Libraries
- **Flutter Team** - Cross-Platform Framework
- **EOSIO** - Blockchain Technology  
- **IPFS** - Decentralized Storage
- **Lottie** - Animations
- All dependencies in [pubspec.yaml](pubspec.yaml)

### Community
- All translators and contributors
- Beta testers and feedback providers
- Open Source Community

### Tools & Services
- **GitHub** - Repository Hosting
- **Updown.io** - Server Monitoring
- **VSCode** - Development Environment

---

<p align="center">
  <strong>🐸 Fr0g.site - Freedom of Speech for Everyone</strong><br/>
  Made with ❤️ by the Open Source Community
</p>

<p align="center">
  <a href="https://fr0g.site">🌐 Live Demo</a> •
  <a href="https://doc.fr0g.site/">📖 Docs</a> •
  <a href="https://github.com/fr0gsite">🐙 GitHub</a> •
  <a href="https://t.me/fr0gsite">💬 Community</a>
</p>
