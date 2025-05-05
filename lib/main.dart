
import 'package:fr0gsite/datatypes/followstatus.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/locationandlanguage.dart';
import 'package:fr0gsite/datatypes/networkstatus.dart';
import 'package:fr0gsite/datatypes/trusterstatus.dart';
import 'package:fr0gsite/datatypes/walletstatus.dart';
import 'package:fr0gsite/localstorage.dart';
import 'package:fr0gsite/widgets/infoscreens/informations.dart';
import 'package:fr0gsite/widgets/status/status.dart';
import 'package:fr0gsite/widgets/resources/resourceviewer.dart';
import 'package:fr0gsite/widgets/home/home.dart';
import 'package:fr0gsite/widgets/topbar/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_strategy/url_strategy.dart';

import 'config.dart';
import 'datatypes/postviewerstatus.dart';
import 'l10n/l10n.dart';
import 'widgets/favorite/favorite.dart';
import 'widgets/follow/follow.dart';
import 'widgets/games/games.dart';
import 'widgets/routes.dart';
import 'widgets/settings/settings.dart';
import 'widgets/wallet/wallet.dart';

var navigationRailwidth = 0.0;

void main() {
  setPathUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalStatus>(
            create: (context) => GlobalStatus()),
        ChangeNotifierProvider<LocationandLanguage>(
            create: (context) => LocationandLanguage()),
        ChangeNotifierProvider<PostviewerStatus>(
            create: (context) => PostviewerStatus()),
        ChangeNotifierProvider<FollowStatus>(
            create: (context) => FollowStatus()),
        ChangeNotifierProvider<WalletStatus>(
            create: (context) => WalletStatus()),
        ChangeNotifierProvider<NetworkStatus>(
            create: (context) => NetworkStatus()),
        ChangeNotifierProvider<TrusterStatus>(
            create: (context) => TrusterStatus()),
      ],
      builder: (context, child) {
        return const App();
      },
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _MyAppState();
}

class _MyAppState extends State<App> {
  @override
  void initState() {
    super.initState();
    debugPrint("Setup Router");
    Mainrouter.setupRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'fr0gsite',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: AppColor.niceblack,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.niceblack,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Colors.blue,
          ),
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(Colors.white),
          ),
          textTheme: GoogleFonts.mitrTextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        supportedLocales: L10n.all,
        locale: Provider.of<LocationandLanguage>(context).locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        initialRoute: '/home',
        onGenerateRoute: Mainrouter.router.generator);
  }
}

class Fr0gsiteApp extends StatefulWidget {
  final String? page;

  const Fr0gsiteApp({super.key, this.page});

  @override
  State<Fr0gsiteApp> createState() => StartPoint();
}

var _selectedIndex = 0;

class StartPoint extends State<Fr0gsiteApp> {
  List<String> pages = [
    "home",
    "follow",
    "favorite",
    "wallet",
    "settings",
    "games",
    "status",
    "resource",
    "information",
  ];

  List<IconData> pageicons = [
    Icons.home,
    Icons.people,
    Icons.favorite,
    Icons.account_balance_wallet,
    Icons.settings,
    Icons.sports_esports,
    Icons.area_chart,
    Icons.network_check_rounded,
    Icons.info_outline,
  ];

  final List<Widget> screens = [
    const Home(),
    const Follow(),
    const Favorite(),
    const Wallet(),
    const Settings(),
    const Games(),
    const Status(),
    const ResourceViewer(),
    const Informations(),
  ];

  void _onItemTapped(int index) {
    Provider.of<GlobalStatus>(context, listen: false).currentpage = index;
    Navigator.pushReplacementNamed(context, '/${pages[index]}');
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        //Check if there are any saved credentials
        loginwhencredentialsarestored(context);
        if (navigationRailwidth == 0.0) {
          setState(
            () {
              debugPrint("set navigationRailwidth");
              navigationRailwidth = getNavigationRailDestinationWidth();
            },
          );
        }
      },
    );
    getappversion();
  }

  String appversion = "";
  void getappversion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        appversion = packageInfo.version;
      });
    }
  }

  final GlobalKey navigationRailDestinationKey = GlobalKey();

  double getNavigationRailDestinationWidth() {
    final RenderObject? renderBox =
        navigationRailDestinationKey.currentContext?.findRenderObject();
    return renderBox?.paintBounds.size.width ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build fr0gsiteApp");
    return Consumer<GlobalStatus>(
      builder: (context, userstatus, child) {
        //_selectedIndex = userstatus.currentpage;
        if (widget.page == null) {
          _selectedIndex = userstatus.currentpage;
        } else {
          _selectedIndex = pages.indexOf(widget.page!);
          if (_selectedIndex == -1) {
            _selectedIndex = 0;
          }
          Provider.of<GlobalStatus>(context, listen: false).currentpage =
              pages.indexOf(widget.page!);
        }

        List<String> pagelabels = [
          AppLocalizations.of(context)!.home,
          AppLocalizations.of(context)!.follow,
          AppLocalizations.of(context)!.favorites,
          AppLocalizations.of(context)!.wallet,
          AppLocalizations.of(context)!.settings,
          AppLocalizations.of(context)!.games,
          AppLocalizations.of(context)!.status,
          AppLocalizations.of(context)!.resources,
        ];

        return Scaffold(
          appBar: AppBar(
            actions: const [Topbar()],
            leadingWidth: 1,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(
                      "assets/images/logo_g.png",
                      width: 50,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                  MediaQuery.of(context).size.width > AppConfig.thresholdValueForMobileLayout
                      ? const Text(AppConfig.appname,
                          style: TextStyle(fontSize: 50, color: Colors.green))
                      : const Text(AppConfig.appname,
                          style: TextStyle(fontSize: 20, color: Colors.green)),
                  const SizedBox(width: 10),
                  Text(
                    "Beta",
                    style: TextStyle(color: Colors.orange, fontSize: MediaQuery.of(context).size.width > AppConfig.thresholdValueForMobileLayout ? 20 : 8),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            backgroundColor: AppColor.niceblack,
            leading: Container(),
          ),
          bottomNavigationBar: MediaQuery.of(context).size.width < AppConfig.thresholdValueForMobileLayout
              ? BottomNavigationBar(
                  backgroundColor: AppColor.niceblack,
                  items: pages.take(6).map((e) {
                    return createBottomNavigationBarItem(
                        pageicons[pages.indexOf(e)],
                        pagelabels[pages.indexOf(e)]);
                  }).toList(),
                  currentIndex: _selectedIndex < 6 ? _selectedIndex : 0,
                  selectedItemColor: Colors.amber[800],
                  unselectedItemColor: Colors.white,
                  onTap: _onItemTapped,
                )
              : null,
          body: SafeArea(
            child: Row(
              children: <Widget>[
                LayoutBuilder(
                  builder: (context, constraint) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraint.maxHeight),
                        child: IntrinsicHeight(
                            child: MediaQuery.of(context).size.width >= AppConfig.thresholdValueForMobileLayout
                                ? NavigationRail(
                                    key: navigationRailDestinationKey,
                                    trailing: Column(
                                      children: [
                                        IconButton(
                                          icon: _selectedIndex == 8
                                              ? Icon(Icons.info_outline,
                                                  color: Colors.amber[800])
                                              : const Icon(Icons.info_outline,
                                                  color: Colors.grey),
                                          onPressed: () {
                                            _selectedIndex = 8;
                                            Navigator.pushReplacementNamed(
                                                context, '/information');
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.telegram,
                                              color: Colors.grey),
                                          onPressed: () {
                                            launchUrl(Uri.parse(telegramurl));
                                          },
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            launchUrl(Uri.parse(githuburl));
                                          },
                                          child: Text("v$appversion",
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                        )
                                      ],
                                    ),
                                    labelType: NavigationRailLabelType.all,
                                    backgroundColor: AppColor.niceblack,
                                    selectedIconTheme:
                                        IconThemeData(color: Colors.amber[800]),
                                    indicatorColor:
                                        IconThemeData(color: Colors.grey[800])
                                            .color!,
                                    unselectedIconTheme: const IconThemeData(
                                        color: Colors.white),
                                    unselectedLabelTextStyle:
                                        const TextStyle(color: Colors.white),
                                    selectedLabelTextStyle:
                                        TextStyle(color: Colors.amber[800]),
                                    destinations: pages.take(8).map((e) {
                                      return createNavigationRailDestination(
                                          pageicons[pages.indexOf(e)],
                                          pagelabels[pages.indexOf(e)]);
                                    }).toList(),
                                    selectedIndex:
                                        _selectedIndex < 8 ? _selectedIndex : 0,
                                    onDestinationSelected: _onItemTapped,
                                  )
                                : null),
                      ),
                    );
                  },
                ),
                Expanded(child: screens[_selectedIndex]),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

BottomNavigationBarItem createBottomNavigationBarItem(
    IconData icon, String label) {
  return BottomNavigationBarItem(
      icon: Icon(icon), label: label, backgroundColor: AppColor.niceblack);
}

NavigationRailDestination createNavigationRailDestination(
    IconData icon, String label) {
  return NavigationRailDestination(icon: Icon(icon), label: Text(label));
}
