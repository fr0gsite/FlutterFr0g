import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fr0gsite/widgets/postviewer/subscriptionicon.dart';
import 'package:fr0gsite/widgets/topbar/topbar.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import '../resources/resourceviewertopbar.dart';

class PostViewerTopBar extends StatefulWidget {
  const PostViewerTopBar({super.key});

  @override
  State<PostViewerTopBar> createState() => _PostViewerTopBarState();
}

class _PostViewerTopBarState extends State<PostViewerTopBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostviewerStatus>(
      builder: (context, postviewerstatus, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              color: AppColor.niceblack,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.nicegrey.withAlpha((0.5 * 255).toInt()),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.backspace_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () {
                        final bool canPop = Navigator.canPop(context);
                        final bool hasHistory = !kIsWeb || html.window.history.length > 1;
                        if (canPop && hasHistory) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 30,
                    width: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint(
                          'Open profile of ${postviewerstatus.getcurrentupload().autor}');

                      Provider.of<PostviewerStatus>(context, listen: false)
                          .pause();
                      Navigator.pushNamed(context,
                          '/${AppConfig.profileurlpath}/${postviewerstatus.getcurrentupload().autor}',
                          arguments: {
                            'accountname':
                                postviewerstatus.getcurrentupload().autor
                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: iconsize,
                        ),
                        AutoSizeText(
                          postviewerstatus.getcurrentupload().autor,
                          maxFontSize: textsize,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SubscriptionIcon(username: postviewerstatus.getcurrentupload().autor),
                  const Spacer(),
                  if (constraints.maxWidth > 600) ...[
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: ResourceViewerTopBar(
                          cpu: true, ram: false, net: true, act: true),
                    ),
                  ],
                  if (constraints.maxWidth > 400) const Topbar(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}



