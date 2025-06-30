import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/globalnotifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';

class UploadInfo extends StatefulWidget {
  const UploadInfo({super.key, required this.upload});
  final Upload upload;

  @override
  State<UploadInfo> createState() => _UploadInfoState();
}

class _UploadInfoState extends State<UploadInfo> {
  double titleSize = 15;
  double subtitleSize = 20;

  Color titlecolor = Colors.grey;
  Color subtitlecolor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: ListView(
        children: [
          ListTile(
            title: AutoSizeText(
              "${AppLocalizations.of(context)!.uploadtext}:",
              minFontSize: titleSize,
              style: TextStyle(color: titlecolor),
            ),
            subtitle: InkWell(
              onTap: () {
                final textToCopy = widget.upload.uploadtext.substring(0, 47);
                Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
                  Globalnotifications().copytoClipboard(context);
                });
              },
              child: AutoSizeText(
                widget.upload.uploadtext.length > 50
                    ? "${widget.upload.uploadtext.substring(0, 47)}..."
                    : widget.upload.uploadtext,
                minFontSize: subtitleSize,
                style: TextStyle(color: subtitlecolor),
              ),
            ),
          ),
          ListTile(
            title: AutoSizeText("${AppLocalizations.of(context)!.uploadid}:",
                minFontSize: titleSize, style: TextStyle(color: titlecolor)),
            subtitle: AutoSizeText(widget.upload.uploadid.toString(),
                minFontSize: subtitleSize,
                style: TextStyle(color: subtitlecolor)),
          ),
          ListTile(
            title: AutoSizeText("${AppLocalizations.of(context)!.popularid}:",
                minFontSize: titleSize, style: TextStyle(color: titlecolor)),
            subtitle: AutoSizeText(widget.upload.popularid.toString(),
                minFontSize: subtitleSize,
                style: TextStyle(color: subtitlecolor)),
          ),
          ListTile(
            title: AutoSizeText(
                "${AppLocalizations.of(context)!.trendingvalue}:",
                minFontSize: titleSize,
                style: TextStyle(color: titlecolor)),
            subtitle: AutoSizeText(widget.upload.token.toString(),
                minFontSize: subtitleSize,
                style: TextStyle(color: subtitlecolor)),
          ),
          ListTile(
            title: AutoSizeText(
                "${AppLocalizations.of(context)!.numofcomments}:",
                minFontSize: titleSize,
                style: TextStyle(color: titlecolor)),
            subtitle: AutoSizeText(widget.upload.numofcomments.toString(),
                minFontSize: subtitleSize,
                style: TextStyle(color: subtitlecolor)),
          ),
          ListTile(
            title: AutoSizeText(
                "${AppLocalizations.of(context)!.numoffavorites}:",
                minFontSize: titleSize,
                style: TextStyle(color: titlecolor)),
            subtitle: AutoSizeText(widget.upload.numoffavorites.toString(),
                minFontSize: subtitleSize,
                style: TextStyle(color: subtitlecolor)),
          ),
          ListTile(
            title: AutoSizeText(
              "${AppLocalizations.of(context)!.uploadipfshash}:",
              minFontSize: titleSize,
              style: TextStyle(color: titlecolor),
            ),
            subtitle: InkWell(
              onTap: () {
                final textToCopy = widget.upload.uploadipfshash.toString();
                Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
                  Globalnotifications().copytoClipboard(context);
                });
              },
              child: AutoSizeText(
                "${widget.upload.uploadipfshash.toString().substring(0, 8)}...${widget.upload.uploadipfshash.toString().substring(widget.upload.uploadipfshash.toString().length - 8)}",
                minFontSize: subtitleSize,
                style: TextStyle(color: subtitlecolor),
              ),
            ),
          ),
          ListTile(
            title: AutoSizeText(
                "${AppLocalizations.of(context)!.uploadipfshashfiletyp}:",
                minFontSize: titleSize,
                style: TextStyle(color: titlecolor)),
            subtitle: AutoSizeText(
                widget.upload.uploadipfshashfiletyp.toString(),
                minFontSize: subtitleSize,
                style: TextStyle(color: subtitlecolor)),
          ),
          ListTile(
            title: AutoSizeText(
              "${AppLocalizations.of(context)!.thumbipfshash}:",
              minFontSize: titleSize,
              style: TextStyle(color: titlecolor),
            ),
            subtitle: InkWell(
              onTap: () {
                final textToCopy = widget.upload.thumbipfshash.toString();
                Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
                  Globalnotifications().copytoClipboard(context);
                });
              },
              child: AutoSizeText(
                "${widget.upload.thumbipfshash.toString().substring(0, 8)}...${widget.upload.thumbipfshash.toString().substring(widget.upload.thumbipfshash.toString().length - 8)}",
                minFontSize: subtitleSize,
                style: TextStyle(color: subtitlecolor),
              ),
            ),
          ),
          ListTile(
            title: AutoSizeText(
                "${AppLocalizations.of(context)!.thumbipfshashfiletyp}:",
                minFontSize: titleSize,
                style: TextStyle(color: titlecolor)),
            subtitle: AutoSizeText(
                widget.upload.thumbipfshashfiletyp.toString(),
                minFontSize: subtitleSize,
                style: TextStyle(color: subtitlecolor)),
          ),
        ],
      ),
    );
  }
}
