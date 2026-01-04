import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/gridstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:fr0gsite/ipfsactions.dart';
import 'package:fr0gsite/widgets/cube/cubeloading.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'onhoverbutton.dart';

class Cube extends StatefulWidget {
  const Cube(
      {super.key, required this.upload});

  final cubeheight = 180.0;
  final cubebwidth = 180.0;

  final Upload upload;

  @override
  State<Cube> createState() => CubeState();
}

class CubeState extends State<Cube> {
  CubeState();

  late Future imagefuture;
  late String imagestring;
  Uint8List imagebytes = Uint8List.fromList([]);
  bool showinfo = false;
  bool ishover = false;
  String randomstring = "";
  double iconwidth = 15;
  double titlesize = 25;
  double textsize = 15;

  @override
  void initState() {
    randomstring = generateRandomString(10);
    super.initState();
    imagestring = widget.upload.thumbipfshash;
    imagefuture = fetchdata();
  }

  Future<int> fetchdata() async {
    imagebytes = await IPFSActions.fetchipfsdata(
        context, widget.upload.thumbipfshash);
    return 0;
  }

  Future<File> saveImage(Uint8List imageData, String id) async {
    final directory = await getApplicationDocumentsDirectory();
    final saveString = "${directory.path}/$id.jpg";
    final imageFile = File(saveString);
    await imageFile.writeAsBytes(imageData.toList());
    debugPrint("saveImage:$saveString");
    return imageFile;
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (Provider.of<GridStatus>(context, listen: true).showinfowithouthover) {
        setState(() {
          showinfo = true;
        });
      } else {
        setState(() {
          showinfo = false;
        });
      }
    } catch (e) {
      debugPrint("No GridStatus");
    }

    if (widget.upload.numoffavorites > 20) {
      iconwidth = 20;
      titlesize = 20;
      textsize = 15;
    }

    if (imagestring != widget.upload.thumbipfshash) {
      imagestring = widget.upload.thumbipfshash;
      imagefuture = fetchdata();
    }

    return SizedBox(
        height: widget.cubeheight,
        width: widget.cubebwidth,
        child: OnHoverButton(
          onHover: (value) {
            setState(() {
              ishover = value;
            });
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              try {
                UploadOrderTemplate uploadorder =
                    Provider.of<GridStatus>(context, listen: false).getSerach();
                uploadorder.setcurrentuploadid(
                    widget.upload.uploadid);
                Navigator.pushNamed(context,
                    '/${AppConfig.postviewerurlpath}/${widget.upload.uploadid}',
                    arguments: uploadorder);
              } catch (e) {
                Navigator.pushNamed(context,
                    '/${AppConfig.postviewerurlpath}/${widget.upload.uploadid}',
                    arguments: widget.upload);
              }

              //Still missing:
              //userfavorite
              //globaltag
            },
            child: FutureBuilder(
              future: imagefuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  try {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: MemoryImage(imagebytes),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            stops: const [0.1, 0.9],
                            colors: [
                              Colors.black.withAlpha((0.2 * 255).toInt()),
                              Colors.black.withAlpha((0.2 * 255).toInt()),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: showinfo || ishover
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        widget
                                            .upload.uploadid
                                            .toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        )),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.alternate_email,
                                          color: Colors.white,
                                        ),
                                        Text(
                                            widget
                                                .upload.autor
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: textsize,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                          size: iconwidth,
                                        ),
                                        Text(
                                          widget.upload.numoffavorites
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textsize,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.comment,
                                          color: Colors.white,
                                          size: iconwidth,
                                        ),
                                        Text(
                                          widget.upload.numofcomments
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textsize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      ),
                    );
                  } catch (e) {
                    return Image.asset('assets/frogwebp/1.webp');
                  }
                } else {
                  //Return Random Image from 'assets/frogwebp/'
                  return const CubeLoading();
                }
              },
            ),
          ),
        ));
  }

  double percentageof(double num, double total) {
    if (total == 0) return 0.5;
    return num / total;
  }
}

String generateRandomString(int length) {
  const chars =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}
