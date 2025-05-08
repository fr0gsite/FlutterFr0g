import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/widgets/home/homecubelist.dart';
import 'package:fr0gsite/widgets/home/hometabbar.dart';
import 'package:fr0gsite/widgets/home/populartags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double headlinesize = 30;
const double headlinepaddingleft = 5;
const double headlinepaddingtop = 10;
const double headlinepaddingbottom = 10;
const double headlinepaddingright = 10;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currenttabindex = 0;
  ScrollController homescrollcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    Provider.of<GlobalStatus>(context, listen: false).expandhomenavigationbar =
        true;
  }

  void tabbarPressed(int index) {
    if(index == currenttabindex) {
      return; // No need to update the state if the same tab is pressed again
    }
    setState(() {
      currenttabindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.niceblack,
      child: SingleChildScrollView(
        controller: homescrollcontroller,
        child: Column(
          children: [
            Consumer<GlobalStatus>(builder: (context, userstatus, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: userstatus.expandhomenavigationbar ? 240 : 0,
                child: userstatus.expandhomenavigationbar
                    ? getHomeBar()
                    : Container(
                        color: AppColor.niceblack,
                      ),
              );
            }),
            SizedBox(
              height: 1000,
              child: Container(
                  color: AppColor.nicegrey,
                  child: HomeCubeList(currenttabindex: currenttabindex)),
            ),
          ],
        ),
      ),
    );
  }

  Widget getHomeBar() {
    return Container(
      color: AppColor.niceblack,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: AppColor.nicegrey,
              child: HomeTabBar(
                  initialindex: currenttabindex, callback: tabbarPressed),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              color: AppColor.nicegrey,
              child: Populartags(
                currenttabindex: currenttabindex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
