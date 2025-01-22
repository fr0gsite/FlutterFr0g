import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';


Future<Uint8List> generateVideoThumbnail(PlatformFile videoFile) async {
  // Erstelle eine temporäre Datei
  final tempDir = await getTemporaryDirectory();
  final tempPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.${videoFile.extension}';
  final file = File(tempPath);
  await file.writeAsBytes(videoFile.bytes!);

  // Erzeuge das Thumbnail
  final Uint8List? thumbnailBytes = await VideoThumbnail.thumbnailData(
    video: file.path,
    imageFormat: ImageFormat.JPEG,
    maxWidth: 128, // Beispielbreite
    maxHeight: 128, // Beispielhöhe
    quality: 75, // Qualitätswert zwischen 0-100
  );

  return thumbnailBytes ?? Uint8List(0);
}