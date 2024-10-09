import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  NotFoundPageState createState() => NotFoundPageState();
}

class NotFoundPageState extends State<NotFoundPage>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  bool reverse = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this)
      ..duration = const Duration(
          seconds: 6) // Die Dauer der Animation entsprechend einstellen
      ..addListener(() {
        if (controller.isCompleted && !reverse) {
          reverse = true;
          controller.reverse();
        } else if (controller.value == 0 && reverse) {
          reverse = false;
          controller.forward();
        }
      });
    controller.forward(); // Starten Sie die Animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pagenotfound),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            }),
      ),
      body: Container(
        color: Colors.black, // Ändern Sie dies entsprechend Ihrer AppColor
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/404animation.json',
                    controller: controller,
                    width: 800,
                    height: 400,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
              Text(
                AppLocalizations.of(context)!.pagenotfound,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!
                    .thepageyouarelookingfordoesnotexist,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.white)))),
                onPressed: () {
                  //Navigator.of(context).pop(); // Navigieren Sie zur vorherigen Seite oder zum Startbildschirm
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text(AppLocalizations.of(context)!.goback),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
