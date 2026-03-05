import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parish_connect/models/auth/profile/update_user_request_model.dart';
import 'package:parish_connect/repositories/auth/auth_repository.dart';
import 'package:parish_connect/services/cloudinary/user_profile_cloudinary_service.dart';
import 'package:parish_connect/widgets/builds/build_deanery_dropdown.dart';
import 'package:parish_connect/widgets/builds/build_parish_profile_dropdown.dart';
import 'package:parish_connect/widgets/builds/build_profile_field.dart';
import 'package:parish_connect/widgets/builds/build_section_label.dart';
import 'package:parish_connect/widgets/builds/build_static_profile_field.dart';
import 'package:parish_connect/widgets/helpers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:parish_connect/repositories/auth/check_auth_repository.dart';
import 'package:parish_connect/theme/theme.dart';
import 'package:toastification/toastification.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = false;
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  String? selectedDeanery;
  String? selectedParish;

  @override
  void initState() {
    super.initState();
    final user = ref.read(checkAuthRepositoryStateProvider)!.user!;
    _fullNameController = TextEditingController(text: user.fullName);
    _usernameController = TextEditingController(text: user.username);
    _bioController = TextEditingController(text: user.bio ?? "");
    selectedDeanery = user.deanery;
    selectedParish = user.parish;
  }

  Future<void> _pickImage() async {
    PermissionStatus status;

    if (Platform.isIOS) {
      status = await Permission.photos.request();
    } else {
      if (Platform.isAndroid) {
        status = await Permission.photos.request();

        if (status.isDenied) {
          status = await Permission.storage.request();
        }
      } else {
        status = await Permission.storage.request();
      }
    }

    if (!mounted) return;

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (!mounted || pickedFile == null) return;

      setState(() => _imageFile = File(pickedFile.path));
    } else if (status.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'Please enable gallery access in settings to update your profile picture.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Settings'),
            ),
          ],
        ),
      );
    } else {
      showToast(context, 'Permission denied', type: ToastificationType.warning);
    }
  }

  final UserProfileCloudinaryService _cloudinaryService =
      UserProfileCloudinaryService();

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final currentUser = ref.read(checkAuthRepositoryStateProvider)!.user!;
      String? finalProfilePicUrl = currentUser.profilePic;

      if (_imageFile != null) {
        final uploadedUrl = await _cloudinaryService.uploadSingleImage(
          _imageFile!,
        );

        if (uploadedUrl == null) {
          if (mounted) {
            showToast(
              context,
              'Failed to upload image to cloud',
              type: ToastificationType.error,
            );
          }
          setState(() => _isLoading = false);
          return;
        }
        finalProfilePicUrl = uploadedUrl;
      }

      final updateData = UpdateUserRequestModel(
        fullName: _fullNameController.text,
        username: _usernameController.text,
        email: currentUser.email,
        deanery: selectedDeanery ?? "",
        parish: selectedParish ?? "",
        bio: _bioController.text,
        profilePic: finalProfilePicUrl,
      );

      final result = await ref
          .read(authRepositoryProvider)
          .updateProfile(currentUser.id!, updateData);

      if (!mounted) return;

      if (result.success) {
        setState(() {
          _isEditing = false;
          _imageFile = null;
        });

        await ref.read(checkAuthRepositoryProvider).checkAuth();
        ref.invalidate(checkAuthRepositoryStateProvider);

        if (mounted) {
          showToast(context, result.message, type: ToastificationType.success);
        }
      } else {
        if (mounted) {
          showToast(context, result.message, type: ToastificationType.error);
        }
      }
    } catch (e) {
      if (!mounted) return;
      showToast(
        context,
        'An error occurred during update',
        type: ToastificationType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = ref.watch(checkAuthRepositoryStateProvider)!.user!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 110),
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.primary(context),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: cs.surface,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (user.profilePic != null
                                ? NetworkImage(user.profilePic!)
                                : null)
                            as ImageProvider?,
                  child: (_imageFile == null && user.profilePic == null)
                      ? Icon(Icons.person, size: 60, color: cs.primary)
                      : null,
                ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: FloatingActionButton.small(
                    onPressed: _pickImage, // Now correctly linked
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            user.email,
            style: TextStyle(color: cs.outline, fontSize: 14),
          ),
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _isEditing ? 'Edit Profile' : 'Profile Information',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton.filledTonal(
              onPressed: () => setState(() => _isEditing = !_isEditing),
              icon: Icon(_isEditing ? Icons.close : Icons.edit),
            ),
          ],
        ),
        const Divider(height: 32),

        Form(
          key: _formKey,
          child: Column(
            children: [
              buildField(
                context: context,
                controller: _fullNameController,
                label: 'Full Name',
                icon: Icons.badge_outlined,
                enabled: _isEditing,
              ),
              const SizedBox(height: 16),
              buildField(
                context: context,
                controller: _usernameController,
                label: 'Username',
                icon: Icons.alternate_email,
                enabled: _isEditing,
              ),
              const SizedBox(height: 16),
              buildField(
                context: context,
                controller: _bioController,
                label: 'Bio',
                icon: Icons.description_outlined,
                enabled: _isEditing,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              buildSectionLabel(context, 'CHURCH AFFILIATION'),
              const SizedBox(height: 12),

              _isEditing
                  ? buildDeaneryDropdown(
                      selectedDeanery: selectedDeanery,
                      onChanged: (val) => setState(() {
                        selectedDeanery = val;
                        selectedParish = null;
                      }),
                    )
                  : buildStaticField(
                      'Deanery',
                      selectedDeanery ?? 'Not Assigned',
                      Icons.map_outlined,
                      context,
                    ),
              const SizedBox(height: 16),
              _isEditing
                  ? buildParishDropdown(
                      selectedParish,
                      selectedDeanery,
                      (val) => setState(() => selectedParish = val),
                    )
                  : buildStaticField(
                      'Parish',
                      selectedParish ?? 'Not Assigned',
                      Icons.church_outlined,
                      context,
                    ),

              if (_isEditing) ...[
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
