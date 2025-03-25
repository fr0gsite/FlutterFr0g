import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProducervoteDialog extends StatefulWidget {
  const ProducervoteDialog({super.key});

  @override
  State<ProducervoteDialog> createState() => _ProducervoteDialogState();
}

class _ProducervoteDialogState extends State<ProducervoteDialog> {
  final TextEditingController _producerController = TextEditingController();
  final List<String> _producerNames = [];

  // FocusNode to manage the focus on the TextField
  final FocusNode _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus on the TextField after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    _producerController.dispose();
    super.dispose();
  }

  /// Function to add a new producer name
  void _addProducerName() {
    final text = _producerController.text.trim().toLowerCase();
    if (text.isNotEmpty) {
      // Abort if the name is already in the list
      if (_producerNames.contains(text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.settings,)),
        );
        return;
      }
      // Retrieve account info
      Chainactions().getaccountinfo(text).then((value) {
        // If account is found
        if (value.accountName != "notfound") {
          setState(() {
            _producerNames.add(text);
          });
          _producerController.clear();
          _textFocusNode.requestFocus();
        } else {
          // Show error message if the account doesn't exist
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.usernotfound),
              backgroundColor: Colors.red,
            ),
          );
        }
      }).catchError((error) {
        // General error (e.g., network problems)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.sorrysomethingwentwrong),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // The button should be clickable (green) only if the list is not empty
    final bool canVote = _producerNames.isNotEmpty;

    return Dialog(
      // Subtle shadow around the dialog
      elevation: 10,
      // Make the dialog background transparent so the white container design is visible
      backgroundColor: Colors.transparent,
      // Wrap the main container in a ConstrainedBox to limit width to 600px
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Scaffold(
              backgroundColor: AppColor.nicegrey,
              appBar: AppBar(
                backgroundColor: Colors.blueAccent,
                // Close icon to exit the dialog
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(AppLocalizations.of(context)!.voteforblockproducers),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Input + add button
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: TextField(
                                controller: _producerController,
                                focusNode: _textFocusNode,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.enterproducername,
                                ),
                                cursorColor: Colors.white,
                                onSubmitted: (_) => _addProducerName(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: _addProducerName,
                          ),
                        ],
                      ),
                      // Show the list header and the list only if at least one name is present
                      if (_producerNames.isNotEmpty) ...[
                        const SizedBox(height: 24),
                         Text(
                          AppLocalizations.of(context)!.listofproducers,
                          style: const TextStyle(fontSize: 16),
                        ),
                        ..._producerNames.map((name) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Producer name
                                Text(
                                  name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                // Remove button (X icon)
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _producerNames.remove(name);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                      const SizedBox(height: 24),
                      // Vote button
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            canVote ? Colors.green : Colors.grey,
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (!canVote) {
                            // The list is empty => show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.thelistisempty),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            // Do vote
                            String username = Provider.of<GlobalStatus>(context, listen: false).username;
                            String permission = Provider.of<GlobalStatus>(context, listen: false).permission;
                            Chainactions chain = Chainactions();
                            chain.setusernameandpermission(username, permission);
                            chain.voteproducer(_producerNames).then(
                              (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!.votesuccessful),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.of(context).pop(_producerNames);
                              },
                            ).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${AppLocalizations.of(context)!.error}: $error"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            );
                            
                            
                            //Navigator.of(context).pop(_producerNames);
                          }
                        },
                        child: const Text(
                          "Vote",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
