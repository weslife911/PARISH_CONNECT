import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:parish_connect/utils/logger_util.dart';

class UserProfileCloudinaryService {
  final cloudinary = CloudinaryPublic(
    'dnwwwuj3l',
    'parish_connect_user_preset',
    cache: false,
  );

  Future<String?> uploadSingleImage(File image) async {
    try {
      logger.i("Cloudinary: Starting upload for profile image...");

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path, folder: 'user_profiles'),
      );

      logger.i("Cloudinary: Upload successful: ${response.secureUrl}");
      return response.secureUrl;
    } catch (e) {
      logger.e("Cloudinary Service Error: $e");
      return null;
    }
  }
}
