import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../l10n/app_localizations.dart';

class ImagePickerSection extends StatelessWidget {
  const ImagePickerSection({
    super.key,
    required this.imageFile,
    required this.onImageSelected,
  });

  final XFile? imageFile;
  final ValueChanged<XFile> onImageSelected;

  Future<void> _pick(ImageSource source) async {
    final file = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (file != null) onImageSelected(file);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _ImagePreview(imageFile: imageFile, colorScheme: colorScheme),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SourceButton(
                icon: Icons.camera_alt_outlined,
                label: AppLocalizations.of(context)!.camera,
                onTap: () => _pick(ImageSource.camera),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SourceButton(
                icon: Icons.photo_library_outlined,
                label: AppLocalizations.of(context)!.gallery,
                onTap: () => _pick(ImageSource.gallery),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.imageFile, required this.colorScheme});

  final XFile? imageFile;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: imageFile == null
                ? colorScheme.outlineVariant
                : Colors.transparent,
            width: 1.5,
            style: imageFile == null ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        child: imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 52,
                    color: colorScheme.onSurfaceVariant.withAlpha(04),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.pickOrTakePhoto,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  kIsWeb
                      ? Image.network(imageFile!.path, fit: BoxFit.cover)
                      : Image.file(File(imageFile!.path), fit: BoxFit.cover),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppLocalizations.of(context)!.photoSelected,
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: colorScheme.primary, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
