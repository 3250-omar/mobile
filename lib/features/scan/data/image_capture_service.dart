import 'package:file_picker/file_picker.dart';

/// Abstract service for acquiring image files locally.
abstract interface class ImageCaptureService {
  /// Picks an image file from the device gallery or local storage.
  Future<String?> pickImageFromGallery();

  /// Captures an image from the device camera.
  Future<String?> captureImageFromCamera();
}

/// Default implementation of [ImageCaptureService] using [FilePicker].
class FilePickerImageCaptureService implements ImageCaptureService {
  const FilePickerImageCaptureService();

  @override
  Future<String?> pickImageFromGallery() async {
    try {
      final files = await FilePicker.pickFiles(type: FileType.image);
      if (files.isNotEmpty) {
        return files.first.path;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> captureImageFromCamera() async {
    // For local environments where direct camera hardware or permissions
    // are mediated through image selection or camera intent, delegates to file picker.
    return pickImageFromGallery();
  }
}
