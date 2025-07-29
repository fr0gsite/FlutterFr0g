import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:universal_html/html.dart' as html;

Future<Uint8List> generateVideoThumbnail(PlatformFile file) async {
  // Obtain the bytes from the PlatformFile
  final videoBytes = file.bytes;
  if (videoBytes == null) {
    return Uint8List(0);
  }

  // 1. Create a Blob object and a Blob URL for the video
  final blob = html.Blob([videoBytes], 'video/mp4');
  final url = html.Url.createObjectUrl(blob);

  // 2. Create the <video> element
  final video = html.VideoElement()
    ..src = url
    ..autoplay = false
    ..controls = false
    ..muted = true;

  // 3. Wait for the video metadata to load
  await video.onLoadedMetadata.first;

  // 4. Jump e.g. to second 1.0 for a still frame
  video.currentTime = 1.0;
  await video.onSeeked.first;

  // 5. Create a 128×128 canvas
  final canvas = html.CanvasElement(width: 128, height: 128);
  final ctx = canvas.context2D;

  // 6. Draw (scale) the video image onto the canvas
  //    Everything is squeezed into 128x128 here
  ctx.drawImageScaled(video, 0, 0, 128, 128);

  // 7. Create a JPEG image from the canvas
  final dataUrl = canvas.toDataUrl('image/jpeg');

  // 8. Release the Blob URL again
  html.Url.revokeObjectUrl(url);

  // 9. Convert the DataURL to bytes
  //    Format: "data:image/jpeg;base64,<ENCODED>"
  const base64Header = 'data:image/jpeg;base64,';
  if (dataUrl.startsWith(base64Header)) {
    final base64string = dataUrl.substring(base64Header.length);
    final thumbnailBytes = base64Decode(base64string);
    return thumbnailBytes;
  }
  return Uint8List(0);
}