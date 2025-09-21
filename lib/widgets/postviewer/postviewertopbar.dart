import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/postviewerstatus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fr0gsite/widgets/postviewer/subscriptionicon.dart';
import 'package:fr0gsite/widgets/topbar/connectionoverviewtopbar.dart';
import 'package:fr0gsite/widgets/topbar/loginbutton.dart';
import 'package:fr0gsite/widgets/topbar/searchbutton.dart';
import 'package:fr0gsite/widgets/topbar/topbar.dart';
import 'package:fr0gsite/widgets/topbar/trustertool.dart';
import 'package:fr0gsite/widgets/topbar/uploadbutton.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import '../resources/resourceviewertopbar.dart';

class PostViewerTopBar extends StatefulWidget {
  const PostViewerTopBar({super.key});

  @override
  State<PostViewerTopBar> createState() => _PostViewerTopBarState();
}

class _PostViewerTopBarState extends State<PostViewerTopBar> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

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
            final bool isCompact = constraints.maxWidth <= 600;

            final List<Widget> trailingWidgets = <Widget>[
              if (!isCompact)
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: ResourceViewerTopBar(
                      cpu: true, ram: false, net: true, act: true),
                ),
              if (!isCompact) const Topbar(),
              if (isCompact) const SearchButton(),
              if (isCompact) const UploadButton(),
              if (isCompact) const LoginButton(),
              if (isCompact)
                IconButton(
                  icon: Icon(
                    _isMenuOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  onPressed: _toggleMenu,
                ),
            ];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
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
                            final bool hasHistory =
                                !kIsWeb || html.window.history.length > 1;
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
                          Navigator.pushNamed(
                              context,
                              '/profile/${postviewerstatus.getcurrentupload().autor}',
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
                      SubscriptionIcon(
                          username: postviewerstatus.getcurrentupload().autor),
                      const Spacer(),
                      ...trailingWidgets,
                    ],
                  ),
                ),
                if (isCompact && _isMenuOpen)
                  Container(
                    color: AppColor.niceblack,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: ResourceViewerTopBar(
                              cpu: true, ram: false, net: true, act: true),
                        ),
                        ConnectionOverviewtopbar(),
                        TrusterTool(),
                      ],
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
