import 'package:flutter/material.dart';
import 'package:fr0gsite/datatypes/ipfsuploadnode.dart';
import 'package:fr0gsite/datatypes/uploadfilestatus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ProviderList extends StatefulWidget {
  const ProviderList({super.key, required this.feedback});

  final void Function(IPFSUploadNode node) feedback;

  @override
  State<ProviderList> createState() => _ProviderListState();
}

class _ProviderListState extends State<ProviderList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UploadFileStatus>(
      builder: (context, uploadfilestatus, child) {
        return DataTable(
          columnSpacing: 16,
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                AppLocalizations.of(context)!.provider,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(context)!.providerlistuserslots,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                AppLocalizations.of(context)!.providerlistoffersfreeslots,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const DataColumn(
              label: Text(
                '',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          rows: List<DataRow>.generate(
            uploadfilestatus.nodes.length,
            (index) {
              final node = uploadfilestatus.nodes[index];
              return DataRow(
                cells: <DataCell>[
                  DataCell(Center(
                    child: Text(
                      node.name.length > 18
                          ? '${node.name.substring(0, 15)}...'
                          : node.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )),
                  DataCell(Center(
                    child: Text(node.userslots.toString(),
                        style: const TextStyle(color: Colors.white)),
                  )),
                  DataCell(
                    Center(
                      child: Icon(
                        node.freeslots ? Icons.check : Icons.close,
                        color: node.freeslots ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  DataCell(
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.feedback(node);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.green),
                          shape: WidgetStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.next,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
