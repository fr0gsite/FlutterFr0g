import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/userconfig.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:fr0gsite/config.dart';

class TrusterCriteriaView extends StatefulWidget {
  const TrusterCriteriaView({super.key});

  @override
  State<TrusterCriteriaView> createState() => _TrusterCriteriaViewState();
}

class _TrusterCriteriaViewState extends State<TrusterCriteriaView> {
  bool _loading = true;
  bool _yearOk = false;
  bool _uploadOk = false;
  bool _commentOk = false;

  @override
  void initState() {
    super.initState();
    _loadCriteria();
  }

  Future<void> _loadCriteria() async {
    final globalStatus = Provider.of<GlobalStatus>(context, listen: false);
    final chain = Chainactions();
    UserConfig config = await chain.getuserconfig(globalStatus.username);
    setState(() {
      _yearOk = DateTime.now().difference(config.creationtime).inDays >= 365;
      _uploadOk = config.numofuploads >= 20;
      _commentOk = config.numofcomments >= 20;
      _loading = false;
    });
  }

  Widget _buildRow(String text, bool ok) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(ok ? Icons.check : Icons.close,
              color: ok ? Colors.green : Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
        child: Material(
          color: AppColor.nicegrey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              side: BorderSide(color: Colors.white, width: 6)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                AppLocalizations.of(context)!.applyasatruster,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            body: _loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _buildRow(
                        AppLocalizations.of(context)!.criteriayear,
                        _yearOk,
                      ),
                      _buildRow(
                        AppLocalizations.of(context)!.criteriauploads,
                        _uploadOk,
                      ),
                      _buildRow(
                        AppLocalizations.of(context)!.criteriacomments,
                        _commentOk,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: _yearOk && _uploadOk && _commentOk
                              ? () async {
                                  final status = Provider.of<GlobalStatus>(context,
                                      listen: false);
                                  final chain = Chainactions()
                                    ..setusernameandpermission(
                                        status.username, status.permission);
                                  final messenger =
                                      ScaffoldMessenger.of(context);
                                  bool value = await chain.applyfortrusterrole(
                                      status.username);
                                  if (!mounted) return;
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(value
                                          ? AppLocalizations.of(context)!
                                              .applysuccessful
                                          : AppLocalizations.of(context)!
                                              .sorrysomethingwentwrong),
                                    ),
                                  );
                                  if (value) Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _yearOk && _uploadOk && _commentOk
                                ? Colors.blue
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(AppLocalizations.of(context)!.apply,
                              style: const TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
