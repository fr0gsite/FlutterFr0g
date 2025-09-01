import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/infoscreens/pleaselogin.dart';
import 'package:fr0gsite/widgets/wallet/walletreceive.dart';
import 'package:fr0gsite/widgets/wallet/walletsend.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

import '../../config.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> tabBarViews = const [
    WalletSend(),
    Walletreceive(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabBarViews.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      Tab(
        icon: const Icon(Icons.send),
        text: AppLocalizations.of(context)!.send,
      ),
      Tab(
        icon: Lottie.asset('assets/lottie/scanqr.json',
            fit: BoxFit.fill, repeat: false, height: 40),
        text: AppLocalizations.of(context)!.receive,
      ),
    ];

    return Container(
      color: AppColor.nicegrey,
      child: Consumer<GlobalStatus>(
        builder: (context, userstatus, child) {
          return Column(
            children: [
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: Colors.grey[500],
                labelColor: Colors.white,
                dividerColor: Colors.transparent,
                indicator: gloabltabindicator,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: tabs,
              ),
              Expanded(
                child: userstatus.isLoggedin
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity == null) return;
                          if (details.primaryVelocity! < 0 &&
                              _tabController.index < _tabController.length - 1) {
                            _tabController.animateTo(_tabController.index + 1);
                          } else if (details.primaryVelocity! > 0 &&
                              _tabController.index > 0) {
                            _tabController.animateTo(_tabController.index - 1);
                          }
                        },
                        child: TabBarView(
                          controller: _tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: tabBarViews,
                        ),
                      )
                    : Padding(
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
