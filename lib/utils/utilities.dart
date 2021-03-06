import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as Im;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static String getUsername(String email) {

    return "live:${email.split('@')[0]}";

  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];
    return firstNameInitial + lastNameInitial;
  }

  static Future<File> pickImageSource({@required imageSource})async {
    final ImagePicker _picker = ImagePicker();
    XFile selectedImage = await _picker.pickImage(source: imageSource);
    return compressImage(File(selectedImage.path));
  }

  static Future<File> compressImage(File imageToCompress) async{
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int random = Random().nextInt(1000);
    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image,width: 500,height: 500);
    return new File('$path/img_$random.jpg')..writeAsBytesSync(Im.encodeJpg(image,quality: 50));
  }
}