import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class Utils {
  static Future<File> convertToJpgIfWebp(File imageFile) async {
    final ext = path.extension(imageFile.path).toLowerCase();

    if (ext != '.webp') return imageFile;

    final bytes = await imageFile.readAsBytes();
    final decodedImage = img.decodeImage(bytes);
    if (decodedImage == null) throw Exception("Could not decode image");

    final jpgBytes = img.encodeJpg(decodedImage);
    final tempDir = await getTemporaryDirectory();
    final jpgPath = path.join(
      tempDir.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final convertedFile = File(jpgPath)..writeAsBytesSync(jpgBytes);

    return convertedFile;
  }
}
