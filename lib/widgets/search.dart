import 'package:fr0gsite/config.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String> countries = [];

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
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Material(
              color: AppColor.nicegrey,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  side: BorderSide(
                      color: Colors.white, width: 6, strokeAlign: 4.0)),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                      suggestionStyle: const TextStyle(color: Colors.white),
                      maxSuggestionsInViewPort: 5,
                      searchInputDecoration: InputDecoration(
                        hintText: "Search",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.grey,
                        filled: true,
                        hintStyle: const TextStyle(color: Colors.white),
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      suggestionItemDecoration: BoxDecoration(
                        color: AppColor.nicegrey,
                        border: Border.all(color: Colors.white, width: 0.5),
                      ),
                      hint: "Search",
                      suggestions: countries.map<SearchFieldListItem>((e) {
                        return SearchFieldListItem(
                          e,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              e,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }).toList()),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      AppLocalizations.of(context)!
                          .thisfeatureisnotavailableyet,
                      style: const TextStyle(color: Colors.white)),
                ),
              ]),
            ),
          ),
        )
      ],
    );
  }
}
