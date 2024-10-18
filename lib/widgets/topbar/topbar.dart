import 'package:fr0gsite/widgets/topbar/connectionoverviewtopbar.dart';
import 'package:fr0gsite/widgets/topbar/searchbutton.dart';
import 'package:fr0gsite/widgets/topbar/setflag.dart';
import 'package:fr0gsite/widgets/topbar/trustertool.dart';
import 'package:fr0gsite/widgets/topbar/uploadbutton.dart';
import 'package:fr0gsite/widgets/topbar/loginbutton.dart';
import 'package:flutter/material.dart';

class Topbar extends StatefulWidget {
  const Topbar({super.key});

  @override
  State<Topbar> createState() => TopbarState();
}

class TopbarState extends State<Topbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ConnectionOverviewtopbar(),
        SetFlag(),
        TrusterTool(),
        SearchButton(),
        UploadButton(),
        LoginButton()
      ],
    );
  }
}
