import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/widgets/truster/trustercaseoverview.dart';
import 'package:fr0gsite/widgets/truster/trusterconfigview.dart';
import 'package:fr0gsite/widgets/truster/actionboard.dart';
import 'package:flutter/material.dart';

class TrusterView extends StatefulWidget {
  const TrusterView({super.key});

  @override
  TrusterViewState createState() => TrusterViewState();
}

class TrusterViewState extends State<TrusterView> {
  Null get countries => null;
  int _refreshId = 0;

  void _refreshData() {
    setState(() {
      _refreshId++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.black38,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            child: Material(
              color: AppColor.nicegrey,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  side: BorderSide(
                      color: Colors.red, width: 6, strokeAlign: 4.0)),
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: AppColor.nicegrey,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text(
                    'Truster',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _refreshData,
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      verticalDirection: VerticalDirection.down,
                      spacing: 10,
                      runSpacing: 10,
                      direction: Axis.horizontal,
                      children: [
                        SizedBox(
                          height: 600,
                          width: 600,
                          child: ReportsWidget(key: ValueKey('reports_$_refreshId')),
                        ),
                        SizedBox(
                          height: 600,
                          width: 600,
                          child: StatusOverview(key: ValueKey('status_$_refreshId')),
                        ),
                        const SizedBox(
                          height: 220,
                          width: 600,
                          child: ActionBoard(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<bool> getData() async {
    return true;
  }
}
