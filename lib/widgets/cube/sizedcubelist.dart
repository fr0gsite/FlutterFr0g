import 'dart:async';
import 'dart:ui';

import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../chainactions/chainactions.dart';
import 'cube.dart';

class Sizedcubelist extends StatefulWidget {
  const Sizedcubelist(
      {super.key,
      required this.cuberowheight,
      required this.mode,
      required this.scrollDirection});

  final int cuberowheight;
  final String mode;
  final Axis scrollDirection;

  @override
  State<Sizedcubelist> createState() => _SizedcubelistState();
}

class _SizedcubelistState extends State<Sizedcubelist> {
  String contract = 'cbased';
  String scope = 'cbased';
  String table = 'uploads';
  bool reverseorder = false;
  int indexPosition = 1;
  String keyType = '';

  List<Widget> items = [];
  var position = 20;
  bool showAnimation = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    if (widget.scrollDirection == Axis.horizontal) {
      //check Global Sate if animation is already shown
      if (!(Provider.of<GlobalStatus>(context, listen: false)
          .showedHomeFirstAnimation)) {
        showAnimation = true;

        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            Provider.of<GlobalStatus>(context, listen: false)
                .showedHomeFirstAnimation = true;
          }
        });
      }
    }

    switch (widget.mode) {
      case 'new':
        contract = 'cbased';
        scope = 'cbased';
        table = 'uploads';
        reverseorder = true;
        _scrollController.addListener(() {
          if (_scrollController.position.pixels >=
              MediaQuery.of(context).size.height - 300) {
            debugPrint("Reached the bottom");
          }
        });
        break;
      case 'trend':
        contract = 'cbased';
        scope = 'cbased';
        table = 'uploads';
        reverseorder = true;
        keyType = 'i64';
        indexPosition = 2;
        break;
      default:
        contract = 'cbased';
        scope = 'cbased';
        table = 'uploads';
        break;
    }

    Chainactions()
        .geteosclient()
        .getTableRows(contract, scope, table,
            limit: 100,
            reverse: reverseorder,
            json: true,
            keyType: keyType,
            indexPosition: indexPosition)
        .then((response) {
      debugPrint("Received EOS Data: $contract, $scope, $table");
      List.generate(
          100,
          (index) => items.add(Cube(
                informationaboutupload: response.elementAt(index),
                mode: widget.mode,
              )));
      setState(() {
        position = 100;
      });
    });
  }

  void _loadMoreItems() async {
    position += 25;

    Chainactions()
        .geteosclient()
        .getTableRows(contract, scope, table,
            limit: 25,
            reverse: reverseorder,
            json: true,
            lower: position.toString())
        .then((response) {
      debugPrint("Received EOS Data $contract, $scope, $table");
      for (var index = 0; index < response.length; index++) {
        items.add(Cube(
            informationaboutupload: response.elementAt(index),
            mode: widget.mode));
      }
      setState(() {});
    });
  }

  void _scrollListener() {
    var buffer = 300;
    if ((_scrollController.position.maxScrollExtent - buffer) <=
            _scrollController.position.pixels &&
        (_scrollController.position.pixels - buffer) <=
            _scrollController.position.maxScrollExtent) {
      _loadMoreItems();
    }
  }

  int resize() {
    if (widget.scrollDirection == Axis.horizontal) {
      return widget.cuberowheight;
    }
    return (MediaQuery.of(context).size.width / 200).floor();
  }

  ScrollConfiguration getgridview() {
    var corssAxisCount = resize();
    var grid = ScrollConfiguration(
      behavior: AppScrollBehavior(),
      child: GridView.builder(
        scrollDirection: widget.scrollDirection,
        controller: _scrollController,
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: corssAxisCount),
        itemBuilder: (context, index) {
          return items[index];
        },
      ),
    );
    return grid;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.cuberowheight.toDouble() * 200.toDouble(),
        child: Stack(
          children: [
            getgridview(),
            showAnimation
                ? const Center(child: MyLottieAnimation())
                : Container()
          ],
        ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class MyLottieAnimation extends StatefulWidget {
  const MyLottieAnimation({super.key});

  @override
  MyLottieAnimationState createState() => MyLottieAnimationState();
}

class MyLottieAnimationState extends State<MyLottieAnimation> {
  bool showAnimation = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          showAnimation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return showAnimation
        ? Lottie.asset('assets/lottie/swipe.json',
            fit: BoxFit.fill, repeat: true, height: 200)
        : Container();
  }
}

// if this gridview used on flutter web need below class for scrolling
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
