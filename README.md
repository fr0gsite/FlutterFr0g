# Fr0gsite Flutter App

<p align="center">
<img src="assets/frogwebp/84.webp" alt="drawing" width="200"/>
</p>
<p align="center">
    <b>Open-Source, Decentralized, Self managing community, Freedom of speech</b>
</p>
<p align="center">
    <a href=""><img src="https://img.shields.io/badge/-black.svg?logo=X" alt="X"></a>
    <a href=""><img src="https://img.shields.io/badge/Android-black.svg?logo=Android" alt="Android"></a>
    <a href=""><img src="https://img.shields.io/badge/iOS-black.svg?logo=Apple" alt="Apple"></a>
    <a href=""><img src="https://img.shields.io/badge/Telegram-gray.svg?logo=telegram" alt="Telegram"></a>
    <a href=""><img src="https://img.shields.io/badge/Discussions-gray.svg?logo=github" alt="GitHub Discussions"></a>
    <a href="http://doc.fr0g.site/"><img src="https://img.shields.io/badge/Doc-blue.svg" alt="Doc"></a>
    <a href=""><img src="https://img.shields.io/badge/Website-blue.svg" alt="Website"></a>
</p>


## Getting Started

This is the interface to **Fr0g**. Single codebase to web, android, ios.

> You can download the [Andoid]() and [iOS]() App for free.

On Web you can visit this currenlty hosted Fr0g instances:
- [Fr0g.site](https://fr0g.site)

- If you want to understand the processes, take a look at the [Documentation](http://doc.fr0g.site/).

- Feel free to run your own instance and share with the community [See how!](https://doc.fr0g.site/participate/overview/)

- Note the ***[Rules](https://doc.fr0g.site/rules/)***

If you want to build by yourself, just install flutter and clone this repo.

```shell
git clone https://github.com/fr0gsite/FlutterFr0g
cd FlutterFr0g
flutter pub get
flutter build web
#or for Android
flutter build apk
```

Feel free to translate parts of the application in your language.
> The language files are here: **lib\l10n**

### Running Web Integration Tests
To execute the integration test in a browser you need Chrome or Chromium
installed. Then run:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/web_app_test.dart \
  -d chrome
```

This will launch the app in Chrome and perform basic interactions such as
clicking the disclaimer button.

If you find an bug you can report [here]()

## Run your own instance and share with community

### Note Legal notice

Depending on where you live and regulation you may need an imprint or something similar.
To keep your Impressum details private, create a local file `assets/impressum.txt` containing your legal information. This file is ignored by git (see `.gitignore`). An example is provided in `assets/impressum.template.txt`.

