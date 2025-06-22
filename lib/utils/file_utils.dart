import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class FileUtils {
  static Future<bool> saveImageToGallery(
    String filePath,
    BuildContext context,
  ) async {
    // final status = await Permission.storage.request();
    // print(status);
    // if (!status.isGranted) return false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(child: CircularProgressIndicator()),
        );
      },
    );
    final bytes;
    print(filePath);
    if (filePath.contains("http")) {
      final response = await http.get(Uri.parse(filePath));
      bytes = response.bodyBytes;
    } else {
      bytes = await File(filePath).readAsBytes();
    }

    final result = await ImageGallerySaverPlus.saveImage(
      Uint8List.fromList(bytes),
      quality: 100,
      name: "kevit_post_${DateTime.now().millisecondsSinceEpoch}",
    );
    Navigator.pop(context);
    return result['isSuccess'] == true;
  }

  static Future<void> requestMediaPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isDenied) {
        await Permission.photos.request();
      }
      if (await Permission.storage.isDenied) {
        await Permission.storage.request(); // Optional below API 33
      }
    }
  }
}
