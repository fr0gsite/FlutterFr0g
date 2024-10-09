import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/globaltag/globaltagcubelist.dart';
import 'package:fr0gsite/widgets/globaltag/globaltagtopbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlobalTag extends StatefulWidget {
  final String? globaltagid;
  const GlobalTag({super.key, this.globaltagid});

  @override
  State<GlobalTag> createState() => _GlobalTagState();
}

class _GlobalTagState extends State<GlobalTag> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          decoration: BoxDecoration(
              color: AppColor.niceblack,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[400]!)),
          child: Column(
            children: [
              Consumer<GlobalStatus>(builder: (context, userstatus, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: userstatus.expandhomenavigationbar ? 120 : 0,
                  child: userstatus.expandhomenavigationbar
                      ? GlobalTagTopBar(globaltagid: widget.globaltagid ?? "")
                      : Container(
                          color: AppColor.niceblack,
                        ),
                );
              }),
              Expanded(
                child: GlobalTagCubeList(globaltagid: widget.globaltagid ?? ""),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
