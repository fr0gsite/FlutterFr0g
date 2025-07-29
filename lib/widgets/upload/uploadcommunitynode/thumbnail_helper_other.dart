import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';


Future<Uint8List> generateVideoThumbnail(PlatformFile videoFile) async {
  // Create a temporary file
  final tempDir = await getTemporaryDirectory();
  final tempPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.${videoFile.extension}';
  final file = File(tempPath);
  await file.writeAsBytes(videoFile.bytes!);

  // Generate the thumbnail
  final Uint8List? thumbnailBytes = await VideoThumbnail.thumbnailData(
    video: file.path,
    imageFormat: ImageFormat.JPEG,
    maxWidth: 128, // Example width
    maxHeight: 128, // Example height
    quality: 75, // Quality value between 0-100
  );

  return thumbnailBytes ?? Uint8List(0);
}