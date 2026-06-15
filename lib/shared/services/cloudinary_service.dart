import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:crypto/crypto.dart';

class CloudinaryService {
  static Future<String?> uploadFile(XFile file) async {
    try {
      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
      final apiKey = dotenv.env['CLOUDINARY_API_KEY'];
      final apiSecret = dotenv.env['CLOUDINARY_API_SECRET'];

      if (cloudName == null || apiKey == null || apiSecret == null) {
        throw Exception('Cloudinary configuration not found in .env');
      }

      final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();
      final folder = dotenv.env['CLOUDINARY_FOLDER_NAME'];

      if (folder == null) {
        throw Exception('Cloudinary folder not found in .env');
      }
      
      // Signature parameters must be sorted alphabetically
      final signatureStr = 'folder=$folder&timestamp=$timestamp$apiSecret';
      final bytes = utf8.encode(signatureStr);
      final signature = sha1.convert(bytes).toString();

      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/auto/upload');

      final request = http.MultipartRequest('POST', url)
        ..fields['api_key'] = apiKey
        ..fields['timestamp'] = timestamp
        ..fields['signature'] = signature
        ..fields['folder'] = folder
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          await file.readAsBytes(),
          filename: file.name,
        ));

      final response = await request.send().timeout(const Duration(seconds: 60));
      final responseData = await response.stream.toBytes().timeout(const Duration(seconds: 30));
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      if (response.statusCode == 200) {
        return jsonMap['secure_url'];
      } else {
        throw Exception('Failed to upload file: ${jsonMap['error']['message']}');
      }
    } catch (e) {
      debugPrint('Cloudinary upload error: $e');
      return null;
    }
  }

  // Keep as alias for backward compatibility or ease of use
  static Future<String?> uploadImage(XFile imageFile) => uploadFile(imageFile);

  static Future<bool> deleteImage(String secureUrl) async {
    try {
      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
      final apiKey = dotenv.env['CLOUDINARY_API_KEY'];
      final apiSecret = dotenv.env['CLOUDINARY_API_SECRET'];
      
      if (cloudName == null || apiKey == null || apiSecret == null) return false;

      // Extract public_id from secureUrl.
      final uploadIndex = secureUrl.indexOf('/upload/');
      if (uploadIndex == -1) return false;
      
      String afterUpload = secureUrl.substring(uploadIndex + 8);
      // Remove version tag if it exists (e.g., v1612345678/)
      final versionRegex = RegExp(r'^v\d+/');
      afterUpload = afterUpload.replaceFirst(versionRegex, '');
      
      // Strip extension
      final lastDot = afterUpload.lastIndexOf('.');
      if (lastDot != -1) {
        afterUpload = afterUpload.substring(0, lastDot);
      }
      final publicId = afterUpload;

      final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();
      
      final signatureStr = 'public_id=$publicId&timestamp=$timestamp$apiSecret';
      final bytes = utf8.encode(signatureStr);
      final signature = sha1.convert(bytes).toString();

      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/destroy');

      final response = await http.post(url, body: {
        'api_key': apiKey,
        'public_id': publicId,
        'timestamp': timestamp,
        'signature': signature,
      });

      final jsonMap = jsonDecode(response.body);
      if (response.statusCode == 200 && jsonMap['result'] == 'ok') {
        return true;
      } else {
        debugPrint('Failed to delete image: ${jsonMap['error']?['message'] ?? jsonMap}');
        return false;
      }
    } catch (e) {
      debugPrint('Cloudinary delete error: $e');
      return false;
    }
  }
}
