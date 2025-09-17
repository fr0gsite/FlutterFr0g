import 'dart:ui';

import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globaltags.dart';
import 'package:fr0gsite/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/widgets/home/tagbutton.dart';

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
                                    child: TagButton(
                                        text: taglist[index * 2].text,
                                        globalTagId: taglist[index * 2]
                                            .globaltagid),
                                  ),
                                  if (index * 2 + 1 < snapshot.data!.length)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TagButton(
                                          text: taglist[index * 2 + 1].text,
                                          globalTagId: taglist[index * 2 + 1]
                                              .globaltagid),
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
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
