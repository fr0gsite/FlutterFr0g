import 'package:fr0gsite/widgets/resources/resourceviewertopbar.dart';
import 'package:flutter/material.dart';

class AccountOverView extends StatefulWidget {
  const AccountOverView({super.key});

  @override
  State<AccountOverView> createState() => _AccountOverViewState();
}

class _AccountOverViewState extends State<AccountOverView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 80,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadiusDirectional.horizontal(
                  start: Radius.circular(15), end: Radius.circular(15)),
              color: Colors.grey[800]),
          child: const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ResourceViewerTopBar(
                    cpu: true, ram: true, net: true, act: false),
              )
            ],
          )),
    );
  }
}
