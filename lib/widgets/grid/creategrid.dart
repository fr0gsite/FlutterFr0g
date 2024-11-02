import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/widgets/cube/cube.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    for (var upload in widget.uploadlist) {
      items.add(Cube(
        informationaboutupload: upload.toJson(),
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
    checkforupdates();
    checkGridRows();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: getgridview(),
    );
  }

  int resize() {
    int div = MediaQuery.of(context).size.width > 640 ? 200 : 165;

    return (MediaQuery.of(context).size.width / div).floor();
  }

  void checkforupdates() {
    if (items.length != widget.uploadlist.length) {
      setState(() {
        items = [];
        for (var upload in widget.uploadlist) {
          items.add(Cube(
            informationaboutupload: upload.toJson(),
          ));
        }
      });
    }
  }

  Container getgridview() {
    var corssAxisCount = resize();
    var grid = Container(
      child: ScrollConfiguration(
        behavior: AppScrollBehavior(),
        child: GridView.builder(
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
      ),
    );
    return grid;
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
