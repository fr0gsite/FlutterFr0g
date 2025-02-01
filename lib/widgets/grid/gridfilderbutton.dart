import 'package:flutter/material.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/widgets/grid/gridfilterview.dart';
import 'package:fr0gsite/widgets/topbar/setflag.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fr0gsite/datatypes/gridstatus.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';

class GridFilterButton extends StatefulWidget {
  const GridFilterButton(this.uploadorder, {super.key});
  final UploadOrderTemplate uploadorder;

  @override
  State<GridFilterButton> createState() => _GridFilterButtonState();
}

class _GridFilterButtonState extends State<GridFilterButton> {
  bool isSmallScreen = false;

  @override
  Widget build(BuildContext context) {
    isSmallScreen = MediaQuery.of(context).size.width < AppConfig.thresholdValueForMobileLayout;

    return isSmallScreen ? _buildBurgerMenu() : _buildButtonRow();
  }

  // Big Screen
  Widget _buildButtonRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterButton(
            context,
            label: AppLocalizations.of(context)!.pictures,
            icon: Icons.photo_size_select_actual_rounded,
            isActive: Provider.of<GridStatus>(context, listen: true).showpicture,
            onPressed: () {
              Provider.of<GridStatus>(context, listen: false).togglepicture();
              widget.uploadorder.showpictures(
                  Provider.of<GridStatus>(context, listen: false).showpicture);
            },
          ),
          _buildFilterButton(
            context,
            label: AppLocalizations.of(context)!.videos,
            icon: Icons.video_camera_back_sharp,
            isActive: Provider.of<GridStatus>(context, listen: true).showvideo,
            onPressed: () {
              Provider.of<GridStatus>(context, listen: false).togglevideo();
              widget.uploadorder.showvideos(
                  Provider.of<GridStatus>(context, listen: false).showvideo);
            },
          ),
          _buildFilterButton(
            context,
            label: AppLocalizations.of(context)!.info,
            icon: Icons.info_sharp,
            isActive: Provider.of<GridStatus>(context, listen: true).showinfowithouthover,
            onPressed: () {
              Provider.of<GridStatus>(context, listen: false).toggleinfowithouthover();
            },
          ),
          _buildFilterButton(
            context,
            label: "Rating",
            icon: Icons.sort,
            isActive: true,
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context) {
                return const GridFilterView();
              });
            },
          ),
        ],
      ),
    );
  }

  // Small Screen
  Widget _buildBurgerMenu() {
    return Align(
      alignment: Alignment.centerLeft,
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.menu, color: Colors.white),
        onSelected: (String value) {
          switch (value) {
            case "pictures":
              Provider.of<GridStatus>(context, listen: false).togglepicture();
              widget.uploadorder.showpictures(Provider.of<GridStatus>(context, listen: false).showpicture);
              break;
            case "videos":
              Provider.of<GridStatus>(context, listen: false).togglevideo();
              widget.uploadorder.showvideos(Provider.of<GridStatus>(context, listen: false).showvideo);
              break;
            case "info":
              Provider.of<GridStatus>(context, listen: false).toggleinfowithouthover();
              break;
            case "rating":
              showDialog(context: context, builder: (BuildContext context) {
                return const GridFilterView();
              });
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          _buildMenuItem("pictures", AppLocalizations.of(context)!.pictures, Icons.photo_size_select_actual_rounded, Provider.of<GridStatus>(context, listen: false).showpicture),
          _buildMenuItem("videos", AppLocalizations.of(context)!.videos, Icons.video_camera_back_sharp, Provider.of<GridStatus>(context, listen: false).showvideo),
          _buildMenuItem("info", AppLocalizations.of(context)!.info, Icons.info_sharp, Provider.of<GridStatus>(context, listen: false).showinfowithouthover),
          _buildMenuItem("rating", "Rating", Icons.sort,  true),
        ],
      ),
    );
  }

  // Filter Button Big Screen
  Widget _buildFilterButton(BuildContext context, {required String label, required IconData icon, required bool isActive, required VoidCallback onPressed}) {
    Color backgroundColoractivated = Colors.blue.withAlpha((0.8 * 255).toInt());
    Color backgroundColordeactivated = Colors.blue.withAlpha((0.3 * 255).toInt());
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: FloatingActionButton.extended(
        heroTag: label,
        onPressed: onPressed,
        backgroundColor: isActive ? backgroundColoractivated : backgroundColordeactivated,
        label: Text(label, style: const TextStyle(color: Colors.white)),
        icon: Icon(icon, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Popup Menu Small Screen
  PopupMenuItem<String> _buildMenuItem(String value, String text, IconData icon, bool isActive) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: isActive ? Colors.blue : Colors.grey),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
