import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/walletstatus.dart';
import 'package:fr0gsite/widgets/resources/accountbalance.dart';
import 'package:fr0gsite/widgets/wallet/walletconfirmtransaction.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WalletSend extends StatefulWidget {
  const WalletSend({super.key});

  @override
  State<WalletSend> createState() => _WalletSendState();
}

class _WalletSendState extends State<WalletSend> {
  Future<Account>? getaccount;
  Account currentaccount = Account("user1", 0);
  TextEditingController sendtotextcontroller = TextEditingController();
  TextEditingController amounttextcontroller = TextEditingController();
  TextEditingController memotextcontroller = TextEditingController();
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    getaccount = getAccount();
    sendtotextcontroller.text =
        Provider.of<WalletStatus>(context, listen: false).sendtoaccountname;
    amounttextcontroller.text =
        Provider.of<WalletStatus>(context, listen: false).amount;
    memotextcontroller.text =
        Provider.of<WalletStatus>(context, listen: false).memo;
  }

  void updatebalance() {
    setState(() {
      getaccount = getAccount().then((value) => currentaccount = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    //Column order : Current balance, send to, amount, send button
    return ListView(
      children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AccountBalance(account: currentaccount),
        )),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              AutoSizeText(
                "${AppLocalizations.of(context)!.liquid}: ",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              FutureBuilder(
                future: getaccount,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Provider.of<GlobalStatus>(context, listen: false)
                        .updateuseraccount(snapshot.data as Account);
                    String balance =
                        "${Provider.of<GlobalStatus>(context, listen: false).useraccount.coreLiquidBalance?.amount ?? "0.0"} ${Provider.of<GlobalStatus>(context, listen: false).useraccount.coreLiquidBalance?.currency ?? " "}";
                    return AutoSizeText(balance,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold));
                  } else {
                    return AutoSizeText(AppLocalizations.of(context)!.loading,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold));
                  }
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 410),
                child: TextField(
                  controller: sendtotextcontroller,
                  enableSuggestions: true,
                  enableInteractiveSelection: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.accountname,
                    labelStyle: const TextStyle(color: Colors.white),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 3),
                    ),
                    filled: true,
                    fillColor: Colors.blueGrey,
                  ),
                  onSubmitted: (value) {
                    Provider.of<WalletStatus>(context, listen: false)
                        .sendtoaccountname = value;
                  },
                  onChanged: (value) {
                    Provider.of<WalletStatus>(context, listen: false)
                        .sendtoaccountname = value;
                  },
                ),
              ),
              IconButton(
                onPressed: () async {

                  try {
                    await Chainactions()
                        .geteosclient()
                        .getAccount(sendtotextcontroller.text);
                    debugPrint("Account exists");
                    if (context.mounted) {

                      Navigator.pushNamed(context,
                          "/profile?username=${sendtotextcontroller.text}",
                          arguments: sendtotextcontroller.text);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      debugPrint(e.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.usernotfound),
                        ),
                      );
                    }
                  }

                  await controller?.toggleFlash();
                  setState(() {});
                },
                icon: const Icon(Icons.search, color: Colors.white, size: 30),
              ),
              IconButton(
                onPressed: () async {
                  if (Provider.of<GlobalStatus>(context, listen: false)
                              .platform ==
                          Platformdetectionstatus.android ||
                      Provider.of<GlobalStatus>(context, listen: false)
                              .platform ==
                          Platformdetectionstatus.ios) {
                    await controller?.toggleFlash();
                    setState(
                      () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return QRView(
                              key: qrKey,
                              formatsAllowed: const [BarcodeFormat.qrcode],
                              onQRViewCreated: (controller) {
                                this.controller = controller;
                                controller.scannedDataStream.listen(
                                  (scanData) {
                                    setState(
                                      () {
                                        List<String> splitstring =
                                            scanData.code?.split(":") ??
                                                ["", ""];
                                        if (splitstring[0] == "cb" &&
                                            splitstring[1] == "actions" &&
                                            splitstring[2] == "sendto") {
                                          sendtotextcontroller.text =
                                              splitstring[3];
                                        }
                                      },
                                    );
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "${AppLocalizations.of(context)!.thisfeatureisnotsupportet}. Try Android / IOS")));
                  }
                },
                icon: const Icon(Icons.qr_code, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: TextField(
                  controller: amounttextcontroller,
                  inputFormatters: [
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) {
                        final text = newValue.text;
                        final regExp = RegExp(r'^\d*(\.?\d{0,' +
                            AppConfig.systemtokendecimalafterdot.toString() +
                            r'})?$');
                        if (regExp.hasMatch(text)) {
                          return newValue;
                        }
                        return oldValue;
                      },
                    ),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.amount,
                      suffixText: AppConfig.systemtoken,
                      hintText:
                          "${AppLocalizations.of(context)!.forexample} 6.9420",
                      labelStyle: const TextStyle(color: Colors.white),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 3),
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey),
                  onSubmitted: (value) {
                    Provider.of<WalletStatus>(context, listen: false).amount =
                        value;
                  },
                  onChanged: (value) {
                    Provider.of<WalletStatus>(context, listen: false).amount =
                        value;
                  },
                ),
              ),
            ],
          ),
        ),
        //Memo field max 256 characters
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: TextField(
                  controller: memotextcontroller,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.memo,
                      labelStyle: const TextStyle(color: Colors.white),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 3),
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey),
                  onSubmitted: (value) {
                    Provider.of<WalletStatus>(context, listen: false).memo =
                        value;
                  },
                  onChanged: (value) {
                    Provider.of<WalletStatus>(context, listen: false).memo =
                        value;
                  },
                  maxLength: 256,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () async {
              bool doesaccountexist = false;
              bool doesamountisvalid = false;

              //Check if account exists
              try {
                var response = await Chainactions()
                    .geteosclient()
                    .getAccount(sendtotextcontroller.text);
                debugPrint("Account exists");
                doesaccountexist = true;
                if (context.mounted) {
                  Provider.of<WalletStatus>(context, listen: false)
                      .sendtoaccount = response;
                }
              } catch (e) {
                if (context.mounted) {
                  debugPrint(e.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.usernotfound),
                    ),
                  );
                }
              }

              //Check if amount is valid
              try {
                double amount = double.parse(amounttextcontroller.text);
                if (amount > 0) {
                  doesamountisvalid = true;
                }
              } catch (e) {
                debugPrint(e.toString());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text(AppLocalizations.of(context)!.amountisinvalid)));
                }
              }

              if (doesaccountexist && doesamountisvalid) {
                if (context.mounted) {
                  Provider.of<WalletStatus>(context, listen: false)
                      .sendtoaccountname = sendtotextcontroller.text;
                  Provider.of<WalletStatus>(context, listen: false).amount =
                      amounttextcontroller.text;

                  showDialog(
                    context: context,
                    builder: (context) {
                      return WalletConfirmTransaction(
                          callback: transactioncallback,
                          sendtoaccount:
                              Provider.of<WalletStatus>(context, listen: false)
                                  .sendtoaccount
                                  .accountName,
                          amount:
                              Provider.of<WalletStatus>(context, listen: false)
                                  .amount,
                          memo:
                              Provider.of<WalletStatus>(context, listen: false)
                                  .memo);
                    },
                  );
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, left: 32.0, right: 32.0),
                child: Text(AppLocalizations.of(context)!.send,
                    style: const TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  transactioncallback() {
    updatebalance();
  }

  Future<Account> getAccount() async {
    Account accountinfo = await Chainactions().getaccountinfo(
        Provider.of<GlobalStatus>(context, listen: false).username);
    setState(() {
      currentaccount = accountinfo;
    });
    return accountinfo;
  }
}
