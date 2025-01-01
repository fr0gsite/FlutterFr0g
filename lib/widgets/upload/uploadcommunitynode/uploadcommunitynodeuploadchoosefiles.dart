import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/uploadfeedback.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fr0gsite/datatypes/uploadfilestatus.dart';
import 'package:fr0gsite/widgets/upload/uploadcommunitynode/uploadkey.dart';
import 'package:fr0gsite/widgets/wallet/walletconfirmtransaction.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:pointycastle/pointycastle.dart' as pc;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

class UploadChooseFiles extends StatefulWidget {
  const UploadChooseFiles({super.key, required this.feedback});
  final void Function(bool success, UploadFeedback uploadfeedback) feedback;

  @override
  State<UploadChooseFiles> createState() => _UploadChooseFilesState();
}

class _UploadChooseFilesState extends State<UploadChooseFiles> {
  PlatformFile? thumbselectedFile;
  Uint8List? thumbpreview;

  PlatformFile? selectedFile;
  Uint8List? preview;

  bool isLoading = false;

  String status = '';
  final completepayment = Completer<bool>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: isLoading
            ? Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      status,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Preview
                    if (thumbpreview != null || preview != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (preview != null)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.file,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: selectedFile!.extension == 'mp4'
                                      ? const Icon(
                                          Icons.videocam,
                                          size: 200,
                                          color: Colors.white,
                                        )
                                      : Image.memory(
                                          preview!,
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ],
                            ),
                          const SizedBox(width: 20),
                          if (thumbpreview != null)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.thumb,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Image.memory(
                                    thumbpreview!,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    //FILE
                    Text(
                      AppLocalizations.of(context)!.file,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      AppLocalizations.of(context)!.max15MBfilesize,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                              selectedFile != null
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank_rounded,
                              color: selectedFile != null
                                  ? Colors.green
                                  : Colors.red),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () async {
                              pickFile();
                            },
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child:
                                Text(AppLocalizations.of(context)!.selectfile),
                          ),
                          const SizedBox(width: 20),
                          for (var fileType in AppConfig.alloweduploadfiletypes)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                '.$fileType',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Divider(
                        thickness: 3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    //THUMB

                    Text(
                      '${AppLocalizations.of(context)!.thumbexplain} ${AppLocalizations.of(context)!.thumbresolution}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                              thumbselectedFile != null
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank_rounded,
                              color: thumbselectedFile != null
                                  ? Colors.green
                                  : Colors.red),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () async {
                              await pickThumbFile();
                            },
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child:
                                Text(AppLocalizations.of(context)!.selectthumb),
                          ),
                          const SizedBox(width: 16),
                          //Show List of valid file types for thumb, created from AppConfig.allowedthumbfiletypes
                          for (var fileType in AppConfig.allowedthumbfiletypes)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                '.$fileType',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    MaterialButton(
                      color: selectedFile != null && thumbselectedFile != null
                          ? Colors.green
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () async {
                        if (selectedFile != null && thumbselectedFile != null) {
                          setState(() {isLoading = true;});

                          if (Provider.of<UploadFileStatus>(context,listen: false).choosenode.userslots <1 
                          && !Provider.of<UploadFileStatus>(context,listen: false).choosenode.freeslots) {
                            setState(() {status = "Buying Slot";});
                            await buyslot();
                          }

                          setState(() {
                            status = "Requesting Slot";
                          });

                          var keypair = Uploadkey().generateKeyPair();
                          String pubkey = Uploadkey().publicKeyToBase64(
                              keypair.publicKey as pc.ECPublicKey);

                          String privkey = Uploadkey().privateKeyToHex(
                              keypair.privateKey as pc.ECPrivateKey);

                          await Chainactions().getslot(context, "tacotoken", pubkey);
                          

                          //wait 5 seconds for chain to update
                          await Future.delayed(const Duration(seconds: 5));

                          setState(() {
                            status = "Uploading Files";
                          });

                          UploadFeedback uploadfeedback = await uploadFiles(thumbselectedFile!, selectedFile!, privkey);
                          if (uploadfeedback.success) {
                            widget.feedback(true, uploadfeedback);
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          } else {
                            widget.feedback(false, uploadfeedback);
                            setState(() {
                              isLoading = false;
                            });
                          }
                        } else {}
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(AppLocalizations.of(context)!.next,
                            style: defauldtextstyle),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<PlatformFile?> pickThumbFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: AppConfig.allowedthumbfiletypes,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        thumbselectedFile = result.files.first;
        thumbpreview = result.files.first.bytes;
      });
      return result.files.first;
    } else {
      return null;
    }
  }

  Future<PlatformFile?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: AppConfig.alloweduploadfiletypes,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      debugPrint(result.files.first.extension);

      setState(() {
        selectedFile = result.files.first;
        preview = result.files.first.bytes;
      });

      //Resize Image if it is an image an set as preview
      if (result.files.first.extension == 'jpg' ||
          result.files.first.extension == 'jpeg' ||
          result.files.first.extension == 'png') {
        //Uint8List resizedData = resizeImage(result.files.first.bytes!);
        setState(() {
          //thumbpreview = resizedData;
        });
      }
      return result.files.first;
    } else {
      return null;
    }
  }

  Uint8List resizeImage(Uint8List data) {
    Uint8List resizedData = data;
    img.Image? image = img.decodeImage(data);
    if (image == null) {
      return resizedData;
    }
    img.Image resized = img.copyResize(image, width: 128, height: 128);
    resizedData = img.encodeJpg(resized);
    return resizedData;
  }

  Future<UploadFeedback> uploadFiles(
      PlatformFile thumbFile, PlatformFile mainFile, String privkey) async {
    try {
      String uploadurl = Provider.of<UploadFileStatus>(context, listen: false)
          .choosenode
          .uploadurl();
      var request = http.MultipartRequest('POST', Uri.parse(uploadurl));

      request.files.add(http.MultipartFile.fromBytes(
        'thumb',
        thumbFile.bytes!,
        filename: thumbFile.name,
        contentType: MediaType('image', thumbFile.extension ?? 'jpeg'),
      ));

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        mainFile.bytes!,
        filename: mainFile.name,
        contentType: mainFile.extension == 'mp4'
            ? MediaType('video', 'mp4')
            : MediaType('image', mainFile.extension ?? 'jpeg'),
      ));

      request.fields['privkey'] = privkey;
      request.fields['username'] =
          Provider.of<GlobalStatus>(context, listen: false).username;

      var response = await request.send();

      if (response.statusCode == 200) {
        debugPrint('Upload successful');
        var responseString = await response.stream.bytesToString();
        var responseJson = jsonDecode(responseString);
        UploadFeedback uploadfeedback = UploadFeedback.fromJson(responseJson);
        return uploadfeedback;
      } else {
        debugPrint('Failed to upload files');
        return UploadFeedback(false, '', '', '', '');
      }
    } catch (e) {
      debugPrint('Error uploading files: $e');
      return UploadFeedback(false, '', '', '', '');
    }
  }

  Future<bool> requestslot() async {
    if (Provider.of<UploadFileStatus>(context, listen: false)
            .choosenode
            .userslots <
        1) {
      var keypair = Uploadkey().generateKeyPair();
      String pubkey =
          Uploadkey().publicKeyToBase64(keypair.publicKey as pc.ECPublicKey);

      String privkey =
          Uploadkey().privateKeyToHex(keypair.privateKey as pc.ECPrivateKey);

      bool requestslot = await Chainactions().getslot(context, "tacotoken", pubkey);

      if (requestslot) {
        if (mounted) {
          Provider.of<UploadFileStatus>(context, listen: false)
              .setkeys(pubkey, privkey);
          return true;
        } else {
          return false;
        }
      } else {
        //Failed to get slot. Buy slot
        return false;
      }
    } else {
      return true;
    }
  }

  void transactioncallback() {
    
      //requestslot();
    
  }

  Completer<void> completer = Completer<void>();

  Future<void> buyslot() async {
    int slotsprice = await Provider.of<UploadFileStatus>(context, listen: false).choosenode.getslotprice();
    String formattedSlotsPrice = NumberFormat('0.0000').format(slotsprice/10000);
    if(mounted){
      String accountname = Provider.of<UploadFileStatus>(context, listen: false).choosenode.accountname;
      String username = Provider.of<GlobalStatus>(context, listen: false).username;

      await showDialog(
        context: context,
        builder: (context) {
          return WalletConfirmTransaction(
              callback: transactioncallback,
              sendtoaccount: accountname,
              amount: formattedSlotsPrice,
              memo: "buyslot $username");
        },
      );
    }
  }
}
