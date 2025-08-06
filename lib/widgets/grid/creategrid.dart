import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/widgets/cube/cube.dart';
import 'package:fr0gsite/widgets/cube/classicitem.dart';
import 'package:fr0gsite/datatypes/gridstatus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGrid extends StatefulWidget {
  final List<Upload> uploadlist;
  final Function loadmorecallback;
  const CreateGrid(
      {super.key, required this.uploadlist, required this.loadmorecallback});

  @override
  State<CreateGrid> createState() => _CreateGridState();
}

class _CreateGridState extends State<CreateGrid> {
  List<Widget> items = [];
  int minRow = 1;
  bool lastclassic = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    lastclassic = Provider.of<GridStatus>(context, listen: false).showclassic;
    for (var upload in widget.uploadlist) {
      items.add(lastclassic
          ? ClassicItem(
              upload: upload,
            )
          : Cube(
              upload: upload,
            ));
    }
    _scrollController.addListener(_scrollListenerLoadMore);
    _scrollController.addListener(_scrollListenerExpandNavigationBar);
  }

  void checkGridRows() {
    debugPrint("checkGridRows");
    int crossAxisCount = resize();
    int numberOfRows = (items.length / crossAxisCount).ceil();
    if (numberOfRows < minRow) {
      widget.loadmorecallback();
    }
  }

  void _scrollListenerLoadMore() {
    var buffer = 400;
    if ((_scrollController.position.maxScrollExtent - buffer) <=_scrollController.position.pixels &&
        (_scrollController.position.pixels - buffer)          <= _scrollController.position.maxScrollExtent) {
            if(items.isNotEmpty){
                widget.loadmorecallback();
            }
    }
  }

  void _scrollListenerExpandNavigationBar() {
    if (_scrollController.position.pixels > 10) {
      if (Provider.of<GlobalStatus>(context, listen: false)
          .expandhomenavigationbar) {
        debugPrint("setexpandhomenavigationbar false");
        Provider.of<GlobalStatus>(context, listen: false)
            .setexpandhomenavigationbar(false);
      }
    } else {
      Provider.of<GlobalStatus>(context, listen: false)
          .setexpandhomenavigationbar(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showclassic = Provider.of<GridStatus>(context, listen: true).showclassic;
    checkforupdates();
    if (!showclassic) {
      checkGridRows();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: showclassic ? getlistview() : getgridview(),
    );
  }

  int resize() {
    int div = MediaQuery.of(context).size.width > AppConfig.thresholdValueForMobileLayout ? 200 : 165;

    return (MediaQuery.of(context).size.width / div).floor();
  }

  void checkforupdates() {
    bool showclassic = Provider.of<GridStatus>(context, listen: false).showclassic;
    if (items.length != widget.uploadlist.length || showclassic != lastclassic) {
      setState(() {
        lastclassic = showclassic;
        items = [];
        for (var upload in widget.uploadlist) {
          items.add(showclassic
              ? ClassicItem(
                  upload: upload,
                )
              : Cube(
                  upload: upload,
                ));
        }
      });
    }
  }

    void scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(milliseconds: 600), () {
      Provider.of<GlobalStatus>(context, listen: false).setexpandhomenavigationbar(true);
    });
  }

  ScrollConfiguration getgridview() {
    var corssAxisCount = resize();
    var grid = ScrollConfiguration(
      behavior: AppScrollBehavior(),
      child: Stack(
        children: [
          GridView.builder(
          itemCount: items.length,
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: corssAxisCount),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(child: items[index]),
              ),
            );
          },
        ),
        
        Positioned(
          right: 10,
          top: 10,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withAlpha((0.6 * 255).toInt()),
              shadowColor: Colors.transparent,
              // For more "glass" feeling, possibly without shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              scrollToTop();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        
        ]
      ),
    );
    return grid;
  }

  ScrollConfiguration getlistview() {
    var list = ScrollConfiguration(
      behavior: AppScrollBehavior(),
      child: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.1))),
                child: items[index],
              );
            },
          ),
          Positioned(
            right: 10,
            top: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withAlpha((0.6 * 255).toInt()),
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                scrollToTop();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return list;
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
