import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/gridstatus.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:fr0gsite/l10n/app_localizations.dart';
import 'package:fr0gsite/serachmodes/searchgeneral.dart';
import 'package:fr0gsite/widgets/grid/creategrid.dart';
import 'package:fr0gsite/widgets/grid/gridfilderbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  UploadOrderTemplate? uploadorder;
  Future<bool>? futureSearch;

  Future<bool> startSearch(String q) async {
    uploadorder = SearchGeneral(q);
    await uploadorder!.initsearch();
    return true;
  }

  Future<bool> loadmorecallback() async {
    if (uploadorder == null) return false;
    await uploadorder!.searchnext();
    setState(() {});
    return true;
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
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Material(
              color: AppColor.nicegrey,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  side: BorderSide(color: Colors.white, width: 6, strokeAlign: 4.0)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.search,
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey,
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isEmpty) return;
                        setState(() {
                          futureSearch = startSearch(value.trim());
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: futureSearch == null
                        ? Center(
                            child: Text(
                              AppLocalizations.of(context)!.searchforauser,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : MultiProvider(
                            providers: [
                              ChangeNotifierProvider<GridStatus>(create: (context) => GridStatus()),
                            ],
                            builder: (context, child) {
                              if (uploadorder != null) {
                                Provider.of<GridStatus>(context, listen: false).setSearch(uploadorder!);
                              }
                              return FutureBuilder(
                                future: futureSearch,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    if (uploadorder == null || uploadorder!.currentviewuploadlist.isEmpty) {
                                      return Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.nouploadsfound,
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GridFilterButton(uploadorder!),
                                        ),
                                        Expanded(
                                          child: CreateGrid(
                                            uploadlist: uploadorder!.currentviewuploadlist,
                                            loadmorecallback: loadmorecallback,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 15,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
