import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Picks a photo, lets the user pan/zoom/rotate it into place via a crop
/// screen, then copies the result into the app's own documents directory,
/// keyed by a fixed slot name (background/user/partner).
///
/// Each save uses a fresh, uniquely-named file (rather than overwriting the
/// same filename every time) so Flutter's image cache — which keys
/// [FileImage]/[Image.file] by file path — can never serve stale bytes for a
/// photo that has since changed on disk.
class ImageService {
  Future<String?> pickAndSaveImage(String slot, {required bool isAvatar}) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      imageQuality: 90,
    );
    if (picked == null) return null;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      maxWidth: isAvatar ? 1024 : 1920,
      maxHeight: isAvatar ? 1024 : 1920,
      aspectRatio: isAvatar ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Adjust Photo',
          cropStyle: isAvatar ? CropStyle.circle : CropStyle.rectangle,
          lockAspectRatio: isAvatar,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'Adjust Photo',
          aspectRatioLockEnabled: isAvatar,
          cropStyle: isAvatar ? CropStyle.circle : CropStyle.rectangle,
        ),
      ],
    );
    if (cropped == null) return null;

    final imagesDir = await _imagesDirectory();
    final extension = cropped.path.contains('.')
        ? cropped.path.substring(cropped.path.lastIndexOf('.'))
        : '.jpg';
    final uniqueName = '${slot}_${DateTime.now().millisecondsSinceEpoch}$extension';
    final destPath = '${imagesDir.path}/$uniqueName';

    final saved = await File(cropped.path).copy(destPath);
    await _deleteOtherVariants(imagesDir, slot, keep: uniqueName);
    return saved.path;
  }

  Future<void> deleteImage(String? path) async {
    if (path == null) return;
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<Directory> _imagesDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${docsDir.path}/images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    return imagesDir;
  }

  /// Removes any previously saved file for [slot] other than [keep], so
  /// switching photos doesn't leave old ones orphaned on disk.
  Future<void> _deleteOtherVariants(
    Directory imagesDir,
    String slot, {
    required String keep,
  }) async {
    if (!await imagesDir.exists()) return;
    await for (final entity in imagesDir.list()) {
      final name = entity.uri.pathSegments.last;
      if (entity is File && name.startsWith('${slot}_') && name != keep) {
        await entity.delete();
      }
    }
  }
}
