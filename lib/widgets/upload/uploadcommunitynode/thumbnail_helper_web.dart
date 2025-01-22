import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:universal_html/html.dart' as html;

Future<Uint8List> generateVideoThumbnail(PlatformFile file) async {
  // Hol dir die Bytes aus dem PlatformFile
  final videoBytes = file.bytes;
  if (videoBytes == null) {
    return Uint8List(0);
  }

  // 1. Erzeuge Blob-Objekt und eine Blob-URL für das Video
  final blob = html.Blob([videoBytes], 'video/mp4');
  final url = html.Url.createObjectUrl(blob);

  // 2. <video>-Element erstellen
  final video = html.VideoElement()
    ..src = url
    ..autoplay = false
    ..controls = false
    ..muted = true;

  // 3. Warten, bis die Metadaten des Videos geladen sind
  await video.onLoadedMetadata.first;

  // 4. Springe z.B. zu Sekunde 1.0 für ein Standbild
  video.currentTime = 1.0;
  await video.onSeeked.first;

  // 5. Erstelle ein 128×128 Canvas
  final canvas = html.CanvasElement(width: 128, height: 128);
  final ctx = canvas.context2D;

  // 6. Zeichne (skaliere) das Videobild in das Canvas
  //    Hier wird alles auf 128x128 zusammengepresst
  ctx.drawImageScaled(video, 0, 0, 128, 128);

  // 7. Erzeuge ein JPEG-Bild aus dem Canvas
  final dataUrl = canvas.toDataUrl('image/jpeg');

  // 8. Blob-URL wieder freigeben
  html.Url.revokeObjectUrl(url);

  // 9. DataURL in Bytes konvertieren
  //    Format: "data:image/jpeg;base64,<ENCODED>"
  const base64Header = 'data:image/jpeg;base64,';
  if (dataUrl.startsWith(base64Header)) {
    final base64string = dataUrl.substring(base64Header.length);
    final thumbnailBytes = base64Decode(base64string);
    return thumbnailBytes;
  }
  return Uint8List(0);
}