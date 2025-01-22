
import 'dart:typed_data';

import 'package:image/image.dart' as img;

export 'thumbnail_helper_other.dart'
  if (dart.library.html) 'thumbnail_helper_web.dart';


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