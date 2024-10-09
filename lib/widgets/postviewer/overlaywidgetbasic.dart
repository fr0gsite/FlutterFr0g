import 'dart:io';

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/globalnotifications.dart';
import 'package:fr0gsite/widgets/login/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import '../../datatypes/postviewerstatus.dart';
import '../report/report.dart';

class OverlayWidgetBasic extends StatefulWidget {
  const OverlayWidgetBasic({super.key});

  @override
  State<OverlayWidgetBasic> createState() => _OverlayWidgetBasicState();
}

class _OverlayWidgetBasicState extends State<OverlayWidgetBasic> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Provider.of<GlobalStatus>(context, listen: false).showedHomeFirstAnimation = true;

    return Consumer<GlobalStatus>(
      builder: (context, userstatus, child) {
        return overlay();
      },
    );
  }
}

Widget overlay() {
  return Consumer<GlobalStatus>(
    builder: (context, userstatus, child) {
      return Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            !userstatus.isLoggedin
                ? const Positioned(top: 50, right: 10, child: LoginButton())
                : Container(),
          ],
        ),
      );
    },
  );
}

class LoginButton extends StatefulWidget {
  const LoginButton({super.key});

  @override
  State<LoginButton> createState() => LoginButtonState();
}

class LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: ((context) {
                return const Login();
              }));
        },
        child: Tooltip(
          message: "Login",
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.nicegrey,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
              size: iconsize,
            ),
          ),
        ));
  }
}

Widget expandButton(function, int numofcomments, context) {
  return GestureDetector(
    onTap: function,
    child: Tooltip(
      message: "${AppLocalizations.of(context)!.showcomments} (C)",
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.nicegrey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          children: [
            Icon(
              Icons.comment,
              color: Colors.white.withOpacity(0.5),
              size: iconsize / 1.5,
            ),
            Text(
              numofcomments.toString(),
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget showTagsButton(function, int numoftags, context) {
  return GestureDetector(
    onTap: function,
    child: Tooltip(
      message: "${AppLocalizations.of(context)!.showtags} (T)",
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.nicegrey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          children: [
            Icon(
              Icons.tag,
              color: Colors.white.withOpacity(0.5),
              size: iconsize / 1.5,
            ),
            Text(
              numoftags.toString(),
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget reportButton(context) {
  return GestureDetector(
      onTap: () {
        debugPrint("report button pressed");
        // If video, pause video

        showDialog(
            context: context,
            builder: ((context) => Report(
                mode: "upload",
                id: Provider.of<PostviewerStatus>(context, listen: false)
                    .getcurrentupload()
                    .uploadid)));
      },
      child: Tooltip(
        message: "${AppLocalizations.of(context)!.report} (R)",
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.5),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            Icons.report,
            color: Colors.white.withOpacity(0.5),
            size: 40,
          ),
        ),
      ));
}

Widget shareButton(context) {
  return Container(
    decoration: BoxDecoration(
      color: AppColor.nicegrey.withOpacity(0.5),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Tooltip(
      message: "${AppLocalizations.of(context)!.share} (S)",
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.share_rounded,
          color: Colors.white.withOpacity(0.5),
          size: 25,
        ),
        onPressed: () async {
          Upload uploadtoshare =
              Provider.of<PostviewerStatus>(context, listen: false)
                  .getcurrentupload();
          String posturl = "$postviewerurl/${uploadtoshare.uploadid}";
          if (kIsWeb) {
            Share.share(posturl);
            return;
          }
          //Check if file is downloaded completely
          debugPrint("data: ${uploadtoshare.data}");
          if (uploadtoshare.data.length < 1000) {
            debugPrint("File not downloaded completely");
            return;
          }
          final tempDir = await getTemporaryDirectory();
          final tempPath = tempDir.path;
          DateTime now = DateTime.now();
          String formattedDate =
              "${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
          String filename =
              "${AppConfig.appname}_${formattedDate}_${uploadtoshare.uploadid}.${uploadtoshare.uploadipfshashfiletyp}";
          String filetext = "Check this out: $posturl";

          try {
            if (await File('$tempPath/$filename').exists()) {
              debugPrint("File already exists");
              await Share.shareXFiles([XFile('$tempPath/$filename')],
                  text: filetext);
              return;
            } else {
              debugPrint(
                  "File does not exist. Creating file $tempPath/$filename");
              await File('$tempPath/$filename')
                  .writeAsBytes(uploadtoshare.data);
              await Share.shareXFiles([XFile('$tempPath/$filename')],
                  text: filetext);
            }
          } catch (e) {
            Globalnotifications.shownotification(
                context,
                AppLocalizations.of(context)!.share,
                AppLocalizations.of(context)!.sorrysomethingwentwrong,
                "error");
          }
        },
      ),
    ),
  );
}

void fullscreen() {
  debugPrint("fullscreen");
}

void comment() {
  debugPrint("comment");
}

void upvote() {
  debugPrint("upvote");
}

void downvote() {
  debugPrint("downvote");
}

void tip() {
  debugPrint("tip");
}

void report() {
  debugPrint("report");
}

void share() {
  debugPrint("share");
}
