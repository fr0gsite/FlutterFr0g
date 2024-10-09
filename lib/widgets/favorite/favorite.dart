import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/favorite/favoritecommentsview.dart';
import 'package:fr0gsite/widgets/favorite/favoritetagsview.dart';
import 'package:fr0gsite/widgets/favorite/favoriteuploadview.dart';
import 'package:fr0gsite/widgets/infoscreens/pleaselogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> tabBarViews = [
    const FavoriteUploadView(),
    const FavoriteCommentsView(),
    const FavoriteTagsView(),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      Tab(
        icon: const Icon(Icons.favorite),
        text: AppLocalizations.of(context)!.posts,
      ),
      Tab(
        icon: const Icon(Icons.comment),
        text: AppLocalizations.of(context)!.comments,
      ),
      Tab(
        icon: const Icon(Icons.tag),
        text: AppLocalizations.of(context)!.tags,
      ),
    ];

    return Container(
      color: AppColor.nicegrey,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              indicatorColor: Colors.transparent,
              unselectedLabelColor: Colors.grey[500],
              labelColor: Colors.white,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.2),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: tabs,
            ),
            Expanded(child: Consumer<GlobalStatus>(
              builder: (context, userstatus, child) {
                if (userstatus.isLoggedin) {
                  return TabBarView(
                    children: tabBarViews,
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 50,
                        runSpacing: 50,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: AppColor.niceblack,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: const Pleaselogin()),
                        ],
                      ),
                    ),
                  );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
