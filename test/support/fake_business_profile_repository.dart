import 'dart:async';

import 'package:offline_quotes/features/settings/domain/business_profile.dart';
import 'package:offline_quotes/features/settings/domain/business_profile_repository.dart';

/// Test fake implementing [BusinessProfileRepository] in-memory.
class FakeBusinessProfileRepository implements BusinessProfileRepository {
  FakeBusinessProfileRepository({BusinessProfile? initial})
    : current = initial ?? BusinessProfile.defaults();

  BusinessProfile current;
  final StreamController<BusinessProfile> _controller =
      StreamController<BusinessProfile>.broadcast();

  bool saveCalled = false;
  bool saveLogoCalled = false;
  bool deleteLogoCalled = false;

  @override
  Future<BusinessProfile> load() async => current;

  @override
  Stream<BusinessProfile> watch() async* {
    yield current;
    yield* _controller.stream;
  }

  @override
  Future<BusinessProfile> save(BusinessProfile profile) async {
    saveCalled = true;
    current = profile.copyWith(updatedAt: DateTime.now());
    _controller.add(current);
    return current;
  }

  @override
  Future<String> saveLogoFile(List<int> bytes, String extension) async {
    saveLogoCalled = true;
    final path = 'profile/logo_mock.$extension';
    current = current.copyWith(logoPath: path);
    _controller.add(current);
    return path;
  }

  @override
  Future<void> deleteLogoFile() async {
    deleteLogoCalled = true;
    current = current.copyWith(clearLogo: true);
    _controller.add(current);
  }

  void dispose() {
    _controller.close();
  }
}
