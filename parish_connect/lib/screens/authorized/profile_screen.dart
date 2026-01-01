import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parish_connect/widgets/builds/build_deanery_dropdown.dart';
import 'package:parish_connect/widgets/builds/build_parish_profile_dropdown.dart';
import 'package:parish_connect/widgets/builds/build_profile_field.dart';
import 'package:parish_connect/widgets/builds/build_section_label.dart';
import 'package:parish_connect/widgets/builds/build_static_profile_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:parish_connect/repositories/auth/check_auth_repository.dart';
import 'package:parish_connect/theme/theme.dart';

// =============================================================================
// PROFILE SCREEN
// =============================================================================

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();

  // Controllers mapped to User.ts schema
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  String? selectedDeanery;
  String? selectedParish;

  @override
  void initState() {
    super.initState();
    // Initialize data from the Auth Repository
    final user = ref.read(checkAuthRepositoryStateProvider)!.user!;
    _fullNameController = TextEditingController(text: user.fullName);
    _usernameController = TextEditingController(text: user.username);
    _bioController = TextEditingController(text: user.bio ?? "");
    selectedDeanery = user.deanery;
    selectedParish = user.parish;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _handleImagePicking() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gallery permission is required to change photos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = ref.watch(checkAuthRepositoryStateProvider)!.user!;

    // Using ListView directly (No Scaffold) to avoid "laid out exactly once" error in MainShell
    return ListView(
      // Increased top padding to 60 to ensure the profile pic is clear of the front camera
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
                    : (user.profilePic != null ? NetworkImage(user.profilePic!) : null) as ImageProvider?,
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
                    onPressed: _handleImagePicking,
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(user.email, style: TextStyle(color: cs.outline, fontSize: 14)),
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_isEditing ? 'Edit Profile' : 'Profile Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                controller: _fullNameController,
                label: 'Full Name',
                icon: Icons.badge_outlined,
                enabled: _isEditing,
                context: context
              ),
              const SizedBox(height: 16),
              buildField(
                controller: _usernameController,
                label: 'Username',
                icon: Icons.alternate_email,
                enabled: _isEditing,
                context: context
              ),
              const SizedBox(height: 16),
              buildField(
                controller: _bioController,
                label: 'Bio',
                icon: Icons.description_outlined,
                enabled: _isEditing,
                maxLines: 3,
                context: context
              ),
              const SizedBox(height: 24),

              buildSectionLabel('CHURCH AFFILIATION', context),
              const SizedBox(height: 12),

              _isEditing
                ? buildDeaneryDropdown(selectedDeanery: selectedDeanery, onChanged: (val) => setState(() {
                  selectedDeanery = val;
                  selectedParish = null;
                }),)
                : buildStaticField('Deanery', selectedDeanery ?? 'Not Assigned', Icons.map_outlined, context),
              const SizedBox(height: 16),
              _isEditing
                ? buildParishDropdown(
                  selectedParish,
                  selectedDeanery,
                  (val) => setState(() => selectedParish = val),
                )
                : buildStaticField('Parish', selectedParish ?? 'Not Assigned', Icons.church_outlined, context),

              if (_isEditing) ...[
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Logic to save to MongoDB goes here
                        setState(() => _isEditing = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile updated locally')),
                        );
                      }
                    },
                    child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
