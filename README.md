# Fr0gsite Flutter App

<p align="center">
  <img src="assets/frogwebp/84.webp" alt="Fr0gsite mascot" width="200"/>
</p>

<p align="center">
  <strong>Open-source, decentralized, self-managed community platform.</strong><br/>
  <strong>Freedom of speech for everyone.</strong>
</p>

<p align="center">
  <a href=""><img src="https://img.shields.io/badge/-black.svg?logo=X" alt="X"></a>
  <a href=""><img src="https://img.shields.io/badge/Android-black.svg?logo=Android" alt="Android"></a>
  <a href=""><img src="https://img.shields.io/badge/iOS-black.svg?logo=Apple" alt="Apple"></a>
  <a href=""><img src="https://img.shields.io/badge/Telegram-gray.svg?logo=telegram" alt="Telegram"></a>
  <a href=""><img src="https://img.shields.io/badge/Discussions-gray.svg?logo=github" alt="GitHub Discussions"></a>
  <a href="http://doc.fr0g.site/"><img src="https://img.shields.io/badge/Doc-blue.svg" alt="Documentation"></a>
  <a href=""><img src="https://img.shields.io/badge/Website-blue.svg" alt="Website"></a>
</p>

## Overview

This repository contains the official Flutter client for **Fr0g**, delivering the same codebase to the web, Android, and iOS.

Visit running Fr0g instances:
- [Fr0g.site](https://fr0g.site)

For details about the project processes, read the [documentation](http://doc.fr0g.site/). If you want to run your own instance, follow the [participation guide](https://doc.fr0g.site/participate/overview/) and make sure to comply with the [rules](https://doc.fr0g.site/rules/).

## Installation

To build the app locally, install Flutter and then run:

```bash
git clone https://github.com/fr0gsite/FlutterFr0g
cd FlutterFr0g
flutter pub get
flutter build web       # or flutter build apk for Android
```

## Localization

Translations live under [`lib/l10n`](lib/l10n). Feel free to contribute translations for your language.

## Running Web Integration Tests

Chrome or Chromium must be installed. Execute:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/web_app_test.dart \
  -d chrome
```

This launches the app in Chrome and performs basic interactions such as clicking the disclaimer button.

Report issues in the [issue tracker](https://github.com/fr0gsite/FlutterFr0g/issues).

## Self-hosting

You are welcome to host your own Fr0g instance and share it with the community.

### Legal Notice

Depending on local regulations, you may need an imprint.
To keep your Impressum details private, create a local file `assets/impressum.txt` containing your legal information. The file is ignored by git (see `.gitignore`). An example is provided in `assets/impressum.template.txt`.
