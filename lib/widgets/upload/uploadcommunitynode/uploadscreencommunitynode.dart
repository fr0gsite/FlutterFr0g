import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/uploadfeedback.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UploadScreencommunitynode extends StatefulWidget {
  const UploadScreencommunitynode({super.key, required this.feedback});

  final void Function(bool success, UploadFeedback uploadfeedback) feedback;

  @override
  State<UploadScreencommunitynode> createState() =>
      _UploadScreencommunitynodeState();
}

//States
// seaching nodes
// check quota
// offer providers
// op: send token to provider
// set sec pub key
// upload with sec priv key
// get ipfs informatoin and set values in next screen

class _UploadScreencommunitynodeState extends State<UploadScreencommunitynode> {
  bool isLoading = false;

  PlatformFile? thumbselectedFile;
  Uint8List? thumbpreview;

  PlatformFile? selectedFile;
  Uint8List? preview;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          height: 800,
          child: Material(
            color: AppColor.nicegrey,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                side: BorderSide(
                  color: Colors.white,
                  width: 6,
                )),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //Preview
                            if (thumbpreview != null || preview != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (thumbpreview != null)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.thumb,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 4,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Colors.black.withOpacity(0.5),
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
                                  const SizedBox(width: 20),
                                  if (preview != null)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.file,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 4,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                          child:
                                              selectedFile!.extension == 'mp4'
                                                  ? const Icon(Icons.videocam,
                                                      size: 200,
                                                      color: Colors.white)
                                                  : Image.memory(
                                                      preview!,
                                                      width: 200,
                                                      height: 200,
                                                      fit: BoxFit.cover,
                                                    ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),

                            //THUMB
                            if (thumbpreview != null || preview != null)
                              const SizedBox(height: 16),

                            Text(
                              AppLocalizations.of(context)!.thumb,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.thumbexplain} ${AppLocalizations.of(context)!.thumbresolution}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                            const SizedBox(height: 16),

                            Row(
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
                                    PlatformFile? file = await pickThumbFile();
                                  },
                                  child: Text(AppLocalizations.of(context)!
                                      .selectthumb),
                                ),
                                const SizedBox(width: 16),
                                //Show List of valid file types for thumb, created from AppConfig.allowedthumbfiletypes
                                for (var fileType
                                    in AppConfig.allowedthumbfiletypes)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Text(
                                      '.$fileType',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            //FILE
                            Text(
                              AppLocalizations.of(context)!.file,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              AppLocalizations.of(context)!.max15MBfilesize,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            Row(
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
                                  child: Text(
                                      AppLocalizations.of(context)!.selectfile),
                                ),
                                const SizedBox(width: 20),
                                for (var fileType
                                    in AppConfig.alloweduploadfiletypes)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Text(
                                      '.$fileType',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            MaterialButton(
                              color: selectedFile != null &&
                                      thumbselectedFile != null
                                  ? Colors.green
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              onPressed: () {
                                if (selectedFile != null &&
                                    thumbselectedFile != null) {
                                  //uploadFile();
                                  UploadFeedback uploadfeedback =
                                      UploadFeedback(true, 'IPFSHASH', 'jpg',
                                          'THUMBHASH', 'jpg');
                                  widget.feedback(true, uploadfeedback);

                                  Navigator.pop(context);
                                } else {}
                              },
                              child: Text(AppLocalizations.of(context)!.next,
                                  style: defauldtextstyle),
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

  Future<void> uploadFile() async {
    if (selectedFile != null) {
      setState(() {
        isLoading = true;
      });

      //var request = http.MultipartRequest(
      //    'POST', Uri.parse('https://api.fr0g.dev/upload'));
      //request.files.add(
      //  http.MultipartFile.fromBytes(
      //    'file',
      //    selectedFile!.bytes!,
      //    filename: selectedFile!.name,
      //    contentType: MediaType('application', 'octet-stream'),
      //  ),
      //);
      //
      //var response = await request.send();
      //
      //if (response.statusCode == 200) {
      //  var responseString = await response.stream.bytesToString();
      //  var responseJson = jsonDecode(responseString);
      //  debugPrint(responseJson.toString());
    } else {
      setState(() {
        isLoading = false;
      });
      debugPrint('Failed to upload file');
    }
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
      return result.files.first;
    } else {
      return null;
    }
  }
}
