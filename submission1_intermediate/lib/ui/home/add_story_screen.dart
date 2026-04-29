import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../provider/story_provider.dart';
import '../widget/image_picker_section.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile;
  LatLng? _selectedLocation;
  String? _address;

  static const int _maxDescLength = 500;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_imageFile == null) {
      _showSnackBar(AppLocalizations.of(context)!.choosePhoto, isError: true);
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final provider = context.read<StoryProvider>();
    final bytes = await _imageFile!.readAsBytes();
    final success = await provider.uploadStory(
      _descriptionController.text.trim(),
      bytes,
      _imageFile!.name,
      lat: _selectedLocation?.latitude,
      lon: _selectedLocation?.longitude,
    );

    if (!mounted) return;

    if (success) {
      _showSnackBar(AppLocalizations.of(context)!.successUpload);
      context.pop();
    } else {
      _showSnackBar(provider.message, isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.addStoryTitle), centerTitle: false),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            ImagePickerSection(
              imageFile: _imageFile,
              onImageSelected: (file) => setState(() => _imageFile = file),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _DescriptionField(
              controller: _descriptionController,
              maxLength: _maxDescLength,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 8),
            Consumer<StoryProvider>(
              builder: (context, provider, child) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_on_outlined, color: Colors.red),
                  title: Text(
                    provider.address ?? AppLocalizations.of(context)!.addLocation,
                    style: TextStyle(
                      fontWeight: provider.address != null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    provider.selectedLocation == null
                        ? AppLocalizations.of(context)!.tapToPickLocation
                        : AppLocalizations.of(context)!.locationSaved,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final result = await context.push<LatLng?>('/pick_location');

                    if (result != null) {
                      provider.setLocation(result, loadingText: AppLocalizations.of(context)!.loadingAddress,
                        notFoundText: AppLocalizations.of(context)!.addressNotFound,);
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 12),
            _TipCard(),
            const SizedBox(height: 24),
            Consumer<StoryProvider>(
              builder: (context, provider, _) {
                return FilledButton.icon(
                  onPressed: provider.isUploading ? null : _submit,
                  icon: provider.isUploading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.cloud_upload_outlined, size: 20),
                  label: Text(
                    provider.isUploading
                        ? AppLocalizations.of(context)!.uploading
                        : AppLocalizations.of(context)!.uploadStory,
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({
    required this.controller,
    required this.maxLength,
    required this.onChanged,
  });

  final TextEditingController controller;
  final int maxLength;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final charCount = controller.text.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.descStory,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          maxLines: 5,
          maxLength: maxLength,
          buildCounter:
              (_, {required currentLength, required isFocused, maxLength}) =>
          null,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.writeDescHint,
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppLocalizations.of(context)!.descEmptyError;
            }
            return null;
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$charCount / $maxLength',
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withAlpha(04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.tipCardText,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onPrimaryContainer,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}