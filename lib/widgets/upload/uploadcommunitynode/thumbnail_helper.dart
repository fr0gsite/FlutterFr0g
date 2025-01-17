
//  Implementierung für Mobile/Desktop mit video_thumbnail
// ------------------------------------------------------
import 'dart:convert';
import 'dart:typed_data';

import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:universal_html/html.dart' as html;
import 'package:image/image.dart' as img;


Future<Uint8List> generateVideoThumbnailMobileDesktop(PlatformFile videoFile) async {
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


// ------------------------------------------------------
//  Implementierung für Web
// ------------------------------------------------------

Future<Uint8List> generateVideoThumbnailWeb(Uint8List videoBytes) async {
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

Uint8List createImageThumbnail(Uint8List imageBytes) {
  final originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) {
    // Falls das Bild nicht dekodiert werden kann, 
    // gib einfach die Original-Bytes zurück
    return imageBytes;
  }

  // 2. Auf 128×128 skalieren
  final resized = img.copyResize(
    originalImage,
    width: 128,
    height: 128,
    // optional: img.copyResize gibt automatisch das Seitenverhältnis
    // nicht beibehalten, wenn man sowohl width als auch height angibt.
    // Möchtest du das Seitenverhältnis bewahren, gib nur eine Dimension an 
    // (z.B. width: 128) und setze "height: null".
  );

  // 3. Das Bild wieder encodieren (z.B. als JPG)
  final thumbnailJpg = img.encodeJpg(resized, quality: 90);

  return Uint8List.fromList(thumbnailJpg);
}



/*
Future<Uint8List> generateVideoThumbnailWeb(Uint8List videoBytes) async {
  // 1. Erzeuge ein Blob-Objekt für das Video
  final blob = html.Blob([videoBytes], 'video/mp4');
  final url = html.Url.createObjectUrl(blob);

  // 2. Erstelle ein <video>-Element und setze die Quelle
  final video = html.VideoElement()
    ..src = url
    ..autoplay = false
    ..controls = false
    ..muted = true;

  // 3. Warte, bis die Metadaten des Videos geladen sind (z.B. Auflösung, Dauer)
  await video.onLoadedMetadata.first;

  // 4. Spule an eine Stelle im Video, z.B. 1 Sekunde, damit wir ein brauchbares Standbild haben
  video.currentTime = 1.0;
  await video.onSeeked.first;

  // 5. Zeichne das Video in ein Canvas
  final canvas = html.CanvasElement(width: video.videoWidth, height: video.videoHeight);
  final ctx = canvas.context2D;
  ctx.drawImage(video, 0, 0);

  // Optional: Canvas verkleinern für Thumbnail (z.B. 128x128)
  // Dafür könntest du ein zweites Canvas nutzen oder direkt
  // hier beim ersten Canvas die Zielgröße anpassen. 
  // Hier machen wir es einfach, indem wir die Originalgröße nehmen.

  // 6. Erzeuge ein JPEG-Bild aus dem Canvas
  final dataUrl = canvas.toDataUrl('image/jpeg');
  // Blob-URL wieder freigeben
  html.Url.revokeObjectUrl(url);

  // 7. dataUrl ist z.B. "data:image/jpeg;base64,...."
  //    -> Base64-Teil ausschneiden und dekodieren
  final base64Header = 'data:image/jpeg;base64,';
  if (dataUrl.startsWith(base64Header)) {
    final base64string = dataUrl.substring(base64Header.length);
    final thumbnailBytes = base64Decode(base64string);
    return thumbnailBytes;
  }

  return Uint8List(0);
}
*/
