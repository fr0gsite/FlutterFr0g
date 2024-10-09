import 'package:fr0gsite/datatypes/gridstatus.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GridFilterButton extends StatefulWidget {
  const GridFilterButton(this.uploadorder, {super.key});
  final UploadOrderTemplate uploadorder;

  @override
  State<GridFilterButton> createState() => _GridFilterButtonState();
}

class _GridFilterButtonState extends State<GridFilterButton> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColoractivated = Colors.blue.withOpacity(0.8);
    Color backgroundColordeactivated = Colors.blue.withOpacity(0.3);
    Color hoverColor = Colors.blue;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                Provider.of<GridStatus>(context, listen: false).togglepicture();
                if (Provider.of<GridStatus>(context, listen: false)
                    .showpicture) {
                  widget.uploadorder.showpictures(true);
                } else {
                  widget.uploadorder.showpictures(false);
                }
              },
              hoverColor: hoverColor,
              backgroundColor:
                  Provider.of<GridStatus>(context, listen: true).showpicture
                      ? backgroundColoractivated
                      : backgroundColordeactivated,
              label: Text(AppLocalizations.of(context)!.pictures,
                  style: const TextStyle(color: Colors.white)),
              icon: const Icon(Icons.photo_size_select_actual_rounded,
                  color: Colors.white),
              shape: ShapeBorder.lerp(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  0.5),
            ),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                Provider.of<GridStatus>(context, listen: false).togglevideo();
                if (Provider.of<GridStatus>(context, listen: false).showvideo) {
                  widget.uploadorder.showvideos(true);
                } else {
                  widget.uploadorder.showvideos(false);
                }
              },
              hoverColor: hoverColor,
              backgroundColor:
                  Provider.of<GridStatus>(context, listen: true).showvideo
                      ? backgroundColoractivated
                      : backgroundColordeactivated,
              label: Text(AppLocalizations.of(context)!.videos,
                  style: const TextStyle(color: Colors.white)),
              icon: const Icon(Icons.video_camera_back_sharp,
                  color: Colors.white),
              shape: ShapeBorder.lerp(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  0.5),
            ),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                Provider.of<GridStatus>(context, listen: false)
                    .toggleinfowithouthover();
              },
              hoverColor: hoverColor,
              backgroundColor: Provider.of<GridStatus>(context, listen: true)
                      .showinfowithouthover
                  ? backgroundColoractivated
                  : backgroundColordeactivated,
              label: Text(AppLocalizations.of(context)!.info,
                  style: const TextStyle(color: Colors.white)),
              icon: const Icon(Icons.info_sharp, color: Colors.white),
              shape: ShapeBorder.lerp(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  0.5),
            ),
          ],
        ),
      ),
    );
  }
}
