import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fr0gsite/datatypes/gridstatus.dart';
import 'package:fr0gsite/datatypes/upload.dart';
import 'package:fr0gsite/datatypes/uploadordertemplate.dart';
import 'package:fr0gsite/ipfsactions.dart';
import 'package:provider/provider.dart';

class ClassicItem extends StatefulWidget {
  const ClassicItem({super.key, required this.upload});

  final Upload upload;

  @override
  State<ClassicItem> createState() => _ClassicItemState();
}

class _ClassicItemState extends State<ClassicItem> {
  late Future _imageFuture;
  Uint8List _imageBytes = Uint8List.fromList([]);

  @override
  void initState() {
    super.initState();
    _imageFuture = _fetchImage();
  }

  Future _fetchImage() async {
    _imageBytes = await IPFSActions.fetchipfsdata(context, widget.upload.thumbipfshash);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        try {
          UploadOrderTemplate uploadorder =
              Provider.of<GridStatus>(context, listen: false).getSerach();
          uploadorder.setcurrentuploadid(widget.upload.uploadid);
          Navigator.pushNamed(context, '/postviewer/${widget.upload.uploadid}',
              arguments: uploadorder);
        } catch (e) {
          Navigator.pushNamed(context, '/postviewer/${widget.upload.uploadid}',
              arguments: widget.upload);
        }
      },
      child: FutureBuilder(
        future: _imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      _imageBytes,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.upload.uploadtext,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

