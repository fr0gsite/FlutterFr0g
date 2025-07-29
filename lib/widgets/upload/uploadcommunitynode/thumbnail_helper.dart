
import 'dart:typed_data';

import 'package:image/image.dart' as img;

export 'thumbnail_helper_other.dart'
  if (dart.library.html) 'thumbnail_helper_web.dart';


Uint8List createImageThumbnail(Uint8List imageBytes) {
  final originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) {
    // If the image cannot be decoded,
    // simply return the original bytes
    return imageBytes;
  }

  // 2. Scale to 128×128
  final resized = img.copyResize(
    originalImage,
    width: 128,
    height: 128,
    // optional: img.copyResize automatically keeps the aspect ratio
    // if only width or height is provided.
    // If you want to preserve the aspect ratio, specify just one dimension
    // (e.g. width: 128) and set "height: null".
  );

  // 3. Re-encode the image (e.g. as JPG)
  final thumbnailJpg = img.encodeJpg(resized, quality: 90);

  return Uint8List.fromList(thumbnailJpg);
}