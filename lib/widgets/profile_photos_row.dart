import 'dart:io';

import 'package:flutter/material.dart';

/// Two circular profile photos (you and your partner), each with an
/// optional name label underneath, and a small heart badge between them —
/// mirroring the hero layout of "Been Together"-style apps. Falls back to a
/// person icon per side when no photo is set. Long-press the photo or the
/// name to edit it in place.
class ProfilePhotosRow extends StatelessWidget {
  const ProfilePhotosRow({
    super.key,
    required this.userPhotoPath,
    required this.partnerPhotoPath,
    this.userName = '',
    this.partnerName = '',
    this.onUserPhotoLongPress,
    this.onPartnerPhotoLongPress,
    this.onUserNameLongPress,
    this.onPartnerNameLongPress,
  });

  final String? userPhotoPath;
  final String? partnerPhotoPath;
  final String userName;
  final String partnerName;
  final VoidCallback? onUserPhotoLongPress;
  final VoidCallback? onPartnerPhotoLongPress;
  final VoidCallback? onUserNameLongPress;
  final VoidCallback? onPartnerNameLongPress;

  /// Radius of each avatar circle; exposed so the home screen can compute
  /// how far this row should overlap the photo/sheet boundary.
  static const double avatarRadius = 36.0;

  /// Total height of a name label slot (text + spacing), so callers can
  /// account for it whether or not a name is actually set.
  static const double nameLabelHeight = 26.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Avatar(
          path: userPhotoPath,
          name: userName,
          onPhotoLongPress: onUserPhotoLongPress,
          onNameLongPress: onUserNameLongPress,
        ),
        Padding(
          padding: EdgeInsets.only(top: avatarRadius - 10, left: 12, right: 12),
          child: const Text('❤️', style: TextStyle(fontSize: 20)),
        ),
        _Avatar(
          path: partnerPhotoPath,
          name: partnerName,
          onPhotoLongPress: onPartnerPhotoLongPress,
          onNameLongPress: onPartnerNameLongPress,
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.path,
    required this.name,
    required this.onPhotoLongPress,
    required this.onNameLongPress,
  });

  final String? path;
  final String name;
  final VoidCallback? onPhotoLongPress;
  final VoidCallback? onNameLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const radius = ProfilePhotosRow.avatarRadius;

    return Column(
      children: [
        GestureDetector(
          onLongPress: onPhotoLongPress,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 8,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
              backgroundImage: path != null ? FileImage(File(path!)) : null,
              child: path == null
                  ? Icon(
                      Icons.person,
                      size: radius,
                      color: theme.colorScheme.onSurfaceVariant,
                    )
                  : null,
            ),
          ),
        ),
        GestureDetector(
          onLongPress: onNameLongPress,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: ProfilePhotosRow.nameLabelHeight,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                name.isEmpty ? '+ Name' : name,
                style: TextStyle(
                  fontFamily: 'Baloo2',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: name.isEmpty
                      ? theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        )
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
