import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';
import 'package:tasklyai/models/profile_model.dart';
import 'package:tasklyai/presentation/profile/provider/profile_provider.dart';

class EditProfileBottomSheet extends StatefulWidget {
  const EditProfileBottomSheet(this.profile, {super.key});

  final ProfileModel profile;

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();

  File? _newAvatar;

  @override
  void initState() {
    _nameController.text = widget.profile.name;
    _emailController.text = widget.profile.email;
    _bioController.text = widget.profile.bio;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _newAvatar = File(picked.path);
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ProfileProvider>();

    if (_nameController.text.trim() != widget.profile.name) {
      provider.updateProfile(context, _nameController.text.trim());
    }
    if (_newAvatar != null) {
      provider.updateAvatar(context, _newAvatar!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// HEADER
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Edit Profile',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// AVATAR
                GestureDetector(
                  onTap: _pickAvatar,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade200,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: _newAvatar != null
                                ? FileImage(_newAvatar!)
                                : (widget.profile.avatar != null
                                      ? NetworkImage(widget.profile.avatar!)
                                      : const AssetImage(
                                              'assets/images/avatar_placeholder.png',
                                            )
                                            as ImageProvider),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// FULL NAME
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Full Name', style: textTheme.bodySmall),
                ),
                const SizedBox(height: 6),
                AppTextField(
                  hint: 'Full Name',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập họ tên';
                    }
                    if (value.trim().length < 3) {
                      return 'Họ tên quá ngắn';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                /// EMAIL (DISABLED)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Email', style: textTheme.bodySmall),
                ),
                const SizedBox(height: 6),
                AppTextField(
                  hint: 'Email',
                  controller: _emailController,
                  readOnly: true,
                ),

                const SizedBox(height: 16),

                /// BIO
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Bio (optional)', style: textTheme.bodySmall),
                ),
                const SizedBox(height: 6),
                AppTextField(
                  hint: 'Tell us about yourself...',
                  controller: _bioController,
                  maxLines: 3,
                ),

                const SizedBox(height: 24),

                /// SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(
                      'Save Changes',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
