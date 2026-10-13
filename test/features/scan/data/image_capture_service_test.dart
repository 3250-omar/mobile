import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/features/scan/data/image_capture_service.dart';

class FakeImageCaptureService implements ImageCaptureService {
  final String? returnedPath;

  const FakeImageCaptureService([this.returnedPath]);

  @override
  Future<String?> captureImageFromCamera() async => returnedPath;

  @override
  Future<String?> pickImageFromGallery() async => returnedPath;
}

void main() {
  group('ImageCaptureService', () {
    test('returns local path when image is picked', () async {
      const service = FakeImageCaptureService('/storage/emulated/0/slip.jpg');
      final path = await service.pickImageFromGallery();
      expect(path, equals('/storage/emulated/0/slip.jpg'));
    });

    test('returns null when user cancels selection', () async {
      const service = FakeImageCaptureService(null);
      final path = await service.pickImageFromGallery();
      expect(path, isNull);
    });
  });
}
