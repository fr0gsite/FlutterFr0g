import 'package:flutter/material.dart';
import 'package:fr0gsite/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GridFilterView extends StatefulWidget {
  const GridFilterView({super.key});

  @override
  State<GridFilterView> createState() => _GridFilterViewState();
}

class _GridFilterViewState extends State<GridFilterView> {

  double filterrating = 0;
  List<String> filtertags = [];
  TextEditingController tagtextcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.nicegrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(
          color: Colors.white,
          width: 2,
        ),
      ),
      title: Text(AppLocalizations.of(context)!.filter),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Rating min: $filterrating"),
            Slider(
              value: filterrating,
              onChanged: (double value) {setState(() {
                filterrating = value;
              });},
              min: 0.0,
              max: 1000,
              divisions: 5,
              label: filterrating.toString(),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Tags"),
            ),
            TextField(
              controller: tagtextcontroller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tags',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  //filtertags = [];
                  //filtertags = tagtextcontroller.text.split(",").map((e) => e.trim()).where((element) => element.isNotEmpty).toList();
                  //Provider.of<GridStatus>(context, listen: true).setfilter(filterrating, filtertags);
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}