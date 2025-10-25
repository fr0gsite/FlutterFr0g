import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/config.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class AccountBalance extends StatefulWidget {
  final Account account;
  const AccountBalance({super.key, required this.account});

  @override
  State<AccountBalance> createState() => _AccountBalanceState();
}

class _AccountBalanceState extends State<AccountBalance> {
  double mintextsize = 16;
  double iconpadding = 8;
  Color iconcolour = Colors.white;
  double tableiconsize = 25;

  double liquid = 0.0;
  double totalram = 0.0;
  double totalcpu = 0.0;
  double selfDelegatedtotalcpu = 0.0;
  double totalnet = 0.0;
  double selfDelegatedtotalnet = 0.0;
  double refundcpu = 0.0;
  double refundnet = 0.0;

  int cpuLimitused = 0;
  int cpuLimitmax = 0;
  int netLimitused = 0;
  int netLimitmax = 0;
  int ramUsage = 0;
  int ramQuota = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    liquid = widget.account.coreLiquidBalance?.amount ?? 0.0;
    totalcpu = widget.account.totalResources?.cpuWeight?.amount ?? 0.0;
    totalnet = widget.account.totalResources?.netWeight?.amount ?? 0.0;
    refundcpu = widget.account.refundRequest?.cpuAmount?.amount ?? 0.0;
    refundnet = widget.account.refundRequest?.netAmount?.amount ?? 0.0;

    selfDelegatedtotalcpu =
        widget.account.selfDelegatedBandwidth?.cpuWeight?.amount ?? 0.0;
    selfDelegatedtotalnet =
        widget.account.selfDelegatedBandwidth?.netWeight?.amount ?? 0.0;

    double totalbalance = totalcpu + totalnet + refundcpu + refundnet + liquid;
    double liquidbalance = liquid;
    double stakedbalance =
        ((totalcpu + totalnet) * 10000).roundToDouble() / 10000;
    double refundbalance =
        ((refundcpu + refundnet) * 10000).roundToDouble() / 10000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 300,
            maxWidth: 400,
          ),
          child: Table(
            border: const TableBorder.symmetric(
                inside: BorderSide(width: 2, color: Colors.black)),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.withAlpha((0.3 * 255).toInt())),
                children: [
                  TableCell(
                    child: Tooltip(
                      message: AppLocalizations.of(context)!.liquidexplain,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(iconpadding),
                            child: Icon(
                              Icons.currency_exchange,
                              color: iconcolour,
                              size: tableiconsize,
                            ),
                          ),
                          AutoSizeText(
                            AppLocalizations.of(context)!.liquid,
                            minFontSize: mintextsize,
                          ),
                        ],
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                          "$liquidbalance ${AppConfig.systemtoken}",
                          textAlign: TextAlign.right,
                          minFontSize: mintextsize),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.withAlpha((0.3 * 255).toInt())),
                children: [
                  TableCell(
                    child: Tooltip(
                      message: AppLocalizations.of(context)!.stakedexplain,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(iconpadding),
                            child: Icon(
                              Icons.lock_rounded,
                              color: iconcolour,
                              size: tableiconsize,
                            ),
                          ),
                          AutoSizeText(
                            AppLocalizations.of(context)!.staked,
                            minFontSize: mintextsize,
                          ),
                        ],
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                          "$stakedbalance ${AppConfig.systemtoken}",
                          textAlign: TextAlign.right,
                          minFontSize: mintextsize),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.withAlpha((0.3 * 255).toInt())),
                children: [
                  TableCell(
                    child: Tooltip(
                      message: AppLocalizations.of(context)!.refundexplain,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(iconpadding),
                            child: Icon(
                              Icons.timelapse_rounded,
                              color: iconcolour,
                              size: tableiconsize,
                            ),
                          ),
                          AutoSizeText(
                            AppLocalizations.of(context)!.refund,
                            minFontSize: mintextsize,
                          ),
                        ],
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                          "$refundbalance ${AppConfig.systemtoken}",
                          textAlign: TextAlign.right,
                          minFontSize: mintextsize),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Tooltip(
                      message: "",
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(iconpadding),
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              color: iconcolour,
                              size: tableiconsize,
                            ),
                          ),
                          AutoSizeText(
                            AppLocalizations.of(context)!.total,
                            minFontSize: mintextsize,
                          ),
                        ],
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "${totalbalance.toStringAsFixed(AppConfig.systemtokendecimalafterdot)} ${AppConfig.systemtoken}",
                        textAlign: TextAlign.right,
                        minFontSize: mintextsize,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
