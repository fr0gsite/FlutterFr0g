import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/infoscreens/pleaselogin.dart';
import 'package:fr0gsite/widgets/wallet/walletreceive.dart';
import 'package:fr0gsite/widgets/wallet/walletsend.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../config.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  List<Widget> tabBarViews = [
    const WalletSend(),
    const Walletreceive(),
  ];

  @override
  void initState() {
    super.initState();
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
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
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
                      ? TabBarView(
                          children: tabBarViews,
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
                                Container(
                                    decoration: BoxDecoration(
                                        color: AppColor.niceblack,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey[400]!)),
                                    child: Container() //Wallet example Video,
                                    ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Walletinfo extends StatefulWidget {
  const Walletinfo({super.key});

  @override
  State<Walletinfo> createState() => _WalletinfoState();
}

class _WalletinfoState extends State<Walletinfo> {
  double textsize = 20;
  double iconsize = 20;
  double iconpadding = 8;
  Color iconcolour = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalStatus>(builder: (context, userstatus, child) {
      return Container(
        color: AppColor.nicegrey,
        child: Column(
          children: [
            Row(
              children: [
                Lottie.asset('assets/lottie/wallet.json',
                    fit: BoxFit.fill, repeat: false, height: 150),
              ],
            ),
          ],
        ),
      );
    });
  }

  Row walletrow(String label, String value, Icon icon) {
    return Row(
      children: [
        const Text("label: ", style: TextStyle(fontSize: 20)),
        Text(value, style: const TextStyle(fontSize: 20)),
      ],
    );
  }
}
