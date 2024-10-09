import 'dart:ui';

import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globaltags.dart';
import 'package:fr0gsite/utils/utils.dart';
import 'package:flutter/material.dart';

class Populartags extends StatefulWidget {
  final int currenttabindex;
  const Populartags({super.key, required this.currenttabindex});

  @override
  State<Populartags> createState() => _PopulartagsState();
}

class _PopulartagsState extends State<Populartags> {
  double tagwidth = 150;
  double tagheight = 130;
  Future? gettagsfuture;

  @override
  void initState() {
    super.initState();
    getPlatform(context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currenttabindex == 0) {
      gettagsfuture = Chainactions().getmixedtags();
    }
    if (widget.currenttabindex == 1) {
      gettagsfuture = Chainactions().getpopularglobaltags();
    }
    if (widget.currenttabindex == 2) {
      gettagsfuture = Chainactions().gettrendingtags();
    }
    if (widget.currenttabindex == 3) {
      gettagsfuture = Chainactions().getnewtags();
    }

    return LimitedBox(
        maxHeight: tagheight,
        child: FutureBuilder(
          future: gettagsfuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<GlobalTags> taglist = snapshot.data as List<GlobalTags>;
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  int numberOfPairs = 30;
                  return ScrollConfiguration(
                    behavior: AppScrollBehavior(),
                    child: Center(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (taglist.length / 2).ceil(),
                        itemBuilder: (context, index) {
                          if (index < numberOfPairs) {
                            return SizedBox(
                              width: tagwidth,
                              child: Wrap(
                                spacing: 10,
                                runAlignment: WrapAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: buildButton(
                                        taglist[index * 2].text,
                                        taglist[index * 2]
                                            .globaltagid
                                            .toString()),
                                  ),
                                  if (index * 2 + 1 < snapshot.data!.length)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: buildButton(
                                          taglist[index * 2 + 1].text,
                                          taglist[index * 2 + 1]
                                              .globaltagid
                                              .toString()),
                                    ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ));
  }

  MaterialButton buildButton(String text, String globaltagid) {
    return MaterialButton(
      onPressed: () {
        debugPrint('Show Globaltag $text ');
        Navigator.pushNamed(context, '/globaltag/$globaltagid',
            arguments: {'text': text, 'globaltagid': globaltagid});
      },
      shape: const _OctagonBorder(),
      color: AppColor.tagcolor,
      hoverColor: Colors.blue,
      child: SizedBox(
        width: tagwidth,
        height: 35,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _OctagonBorder extends ShapeBorder {
  final double sideLength;

  const _OctagonBorder({this.sideLength = 10.0});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(sideLength);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double flatSize = 5.0;
    final Path path = Path()
      ..moveTo(rect.left + flatSize, rect.top) // Startpunkt
      ..lineTo(rect.right - flatSize, rect.top)
      ..lineTo(rect.right, rect.top + flatSize)
      ..lineTo(rect.right, rect.bottom - flatSize)
      ..lineTo(rect.right - flatSize, rect.bottom)
      ..lineTo(rect.left + flatSize, rect.bottom)
      ..lineTo(rect.left, rect.bottom - flatSize)
      ..lineTo(rect.left, rect.top + flatSize)
      ..close(); // Schließt den Pfad

    return path;
  }

  @override
  ShapeBorder scale(double t) => _OctagonBorder(sideLength: sideLength * t);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
