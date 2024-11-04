import 'dart:convert';
import 'package:image_picker/image_picker.dart';

Future<String> convertImageToBase64(XFile image) async {
  final bytes = await image.readAsBytes();
  String base64Image = base64Encode(bytes);
  return "data:${image.mimeType};base64,$base64Image";
}
